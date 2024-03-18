create or replace package as_pdf is
/*
******************************************************************************
**
** Author: Anton Scheffer
** Date: 11-04-2012
** Website:  http://technology.amis.nl
** See also: http://technology.amis.nl/?p=17718
**
** Changelog:
**   Date: 17-03-2024 Javier Meza
**     modify adler32 function with version by Andreas Weiden for error when chunk size is 32K
**     added global g_version
**   Date: 17-07-2021 Lee Lindley
**     added c_get_page_count and return of same from function get()
**      If you want to modify your own version, search for c_get_page_count
**      in this source. It is only 2 lines. Otherwise identical to the original.
**   Date: 13-08-2012
**     added two procedure for Andreas Weiden
**     see https://sourceforge.net/projects/pljrxml2pdf/
**   Date: 16-04-2012
**     changed code for parse_png
**   Date: 15-04-2012
**     only dbms_lob.freetemporary for temporary blobs
**   Date: 11-04-2012
**     Initial release of as_pdf3
**
******************************************************************************
** Author: Valerio Rossetti
** Date: 27-07-2012
** Website:  http://valeriorossetti.blogspot.it/
** See also: http://valeriorossetti.blogspot.it/2014/07/aspdf3v5-new-features-versione-italiana.html
**
** Changelog:
** Date: 27-07-2012                    Version:  0.3.5.00
**   type tp_column                    :Formatting each heder and table columns
**   query2table and refcursor2table Added parameters
**     p_formats (table of tp_columns) :Define column's and header formats
**     (width, font, style, size, aligment, numberformat, colors, ...)
**     p_colors                        :9 default colors, including odd/even lines
**     p_hRowHeight                    :minimum header row height
**     p_dRowHeight                    :minimum table  row height
**     p_pm                            :measurement unit
**     p_startX                        :start X position for table (indent it)
**     p_BreakField                    :check break from filed 1 to p_BreakField (0 none)
**   Add function BorderType           :translate border string TBLR into nuber 0-15
**   Add function to word wrap lines that exceeds column width
**   Add Procedure LogoCoop that print Logo on Upper Left corner
**
** Date: 10-06-2014                    Version:  0.3.5.01
**   +Multirow Record Added:
**    offsetX                          OffsetX from left border of table,
**                                     reset it when change row
**    cellRow                          Row where cell are printed, use strinct sequence
**    hCHeight / tCHeight              Cella Height              (header e table)
**  +Selective Border Added:
**    function BorderType('TBLR')      convert literal into 4 bit bynary
**    hBorder  / tBorder               4 bit bynanry border settimg 0 no border
**
** Data: 10-07-2014                    Version:  0.3.5.02
**   some bug fixes in text alignment
**   +offsetY                          OffsetY from Top side of record block
**   +LabelMode                        Print Records as row/col stickers
**
** Date: 18-09-2014                    Version:  0.3.5.03
**   bugfix and impovement suggested by Giuseppe Polo
**   +query2table                      added Interline parameter
**    setCellFont                      bugfix for Header
** Date: 26-09-2014                    Version:  0.3.5.04
**   bugfix for recursive call of function Write
** Date: 29-09-2014                    Version:  0.3.5.05
**   +query2table                      added pFrame parameter ex:  'L=2pt; C=FF0000'
**                                     where L=Linesize and C=rgb hex colour
**   +query2table                      p_colors also accept CSV string of colors rdb colours
**   +set_Language                     Set language for error messages. (English, Italian)
**   +put_image                        add parameters p_cellWidth, p_cellheight
**   +Columns can contain blob IMAGE
**   +FullJustify Alignment            for write & query2table
**
** Date: 25-11-2014                    Version:  0.3.5.06
**   bugfix for query with more than 200 records
**   +query2table and cursor2table     Add optional parameter p_bulk_size:=200 (Buffer size)
**                                     if = 0 buffer is autodetected, but query runs 2 times!
** Date: 24-06-2015                    Version:  0.3.5.07
**   BugFix query2table                Reset rowHeith when RowHeight Min or Exacat as specified
** Date: 30-06-2015                    Version:  0.3.5.08
**   BugFix PrepareRecord              Fix problem with rowHeight
** Date: 26-08-2015                    Version:  0.3.5.09
**   BugFix colorTable                 Fix problem with undefined collection
**   WARNING! if you change package name, propertly set g_package variable
** Date: 14-12-2015                    Version:  0.3.5.10
**   Bugix in PrepareRecord
** Date: 11-05-2016                    Version:  0.3.5.11
**   Bugfix error when calling with null colours
**   colorTable changed and moved before query2Table
**   query2table & query2label changed
**   when calling query2table you must use empty string '' instead of null for p_colors parameter
** Date: 06-09-2016                    Version:  0.3.5.12
**   Bugfix error in recursive call of write procedure, um must be in pt
**
******************************************************************************
Copyright (C) 2012 by Anton Scheffer

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

******************************************************************************
*/
--
  c_get_page_width     constant pls_integer := 0;
  c_get_page_height    constant pls_integer := 1;
  c_get_margin_top     constant pls_integer := 2;
  c_get_margin_right   constant pls_integer := 3;
  c_get_margin_bottom  constant pls_integer := 4;
  c_get_margin_left    constant pls_integer := 5;
  c_get_x              constant pls_integer := 6;
  c_get_y              constant pls_integer := 7;
  c_get_fontsize       constant pls_integer := 8;
  c_get_current_font   constant pls_integer := 9;
  c_get_current_fcolor constant pls_integer :=10;
  c_get_current_bcolor constant pls_integer :=11;
  -- added ltl for GetPdf wrapper package 20210717
  c_get_page_count     constant pls_integer :=12;
--
  -- Set default colours ternary (ink,paper and border)
  -- Header   = Black/Cyan/Black
  -- evenRows = Black/White/Black
  -- oddRows  = Black/Light Gray/Black
  c_dft_colours        constant varchar2(64):='000000,e0ffff,000000,000000,ffffff,000000,000000,d0d0d0,000000';

-- Decimal separator used in the text
  g_vDP VARCHAR2(1):= CASE WHEN instr(to_char(15/10),'.') = 0 THEN ',' ELSE '.' END;

  g_Language varchar2(1):='E';

--
  function file2blob( p_dir varchar2, p_file_name varchar2 )
  return blob;
--
  function conv2uu( p_value number, p_unit varchar2 )
  return number;
--
  procedure set_Language(p_vNewValue in varchar2:='E');
--
  procedure set_page_size
    ( p_width  number
    , p_height number
    , p_unit   varchar2 := 'cm'
    );
--
  procedure set_page_format( p_format varchar2 := 'A4' );
--
  procedure set_page_orientation( p_orientation varchar2 := 'PORTRAIT' );
--
  procedure set_margins
    ( p_top    number := null
    , p_left   number := null
    , p_bottom number := null
    , p_right  number := null
    , p_unit   varchar2 := 'cm'
    );
--
  procedure set_info
    ( p_title    varchar2 := null
    , p_author   varchar2 := null
    , p_subject  varchar2 := null
    , p_keywords varchar2 := null
    );
--
  procedure init;
--
  function get_pdf
  return blob;
--
  procedure save_pdf
    ( p_dir      varchar2 := 'PDF'
    , p_filename varchar2 := 'my.pdf'
    , p_freeblob boolean := true
    );
--
  procedure txt2page( p_txt varchar2 );
--
  procedure put_txt(p_x number, p_y number, p_txt varchar2,
                    p_degrees_rotation NUMBER := NULL,
                    p_um VARCHAR2 := 'pt'  -- Add by ValR
                    );
  procedure put_txt(p_um VARCHAR2 := 'pt',
                    p_x number, p_y number, p_txt varchar2,
                    p_degrees_rotation NUMBER := NULL
                    );
  procedure g_put_txt( p_x VARCHAR2, p_y VARCHAR2, p_txt varchar2,
                     p_degrees_rotation number := NULL);
--
  function str_len( p_txt varchar2 )
  return number;
--
-- ValR Chiamata alternativa, con unit? di misura all'inizio
  procedure write
    ( p_txt in VARCHAR2
    , p_um VARCHAR :='pt'
    , p_x in number := null
    , p_y in number := null
    , p_line_height in number := null
    , p_start in number := null -- left side of the available text box
    , p_width in number := null -- width of the available text box
    , p_alignment in varchar2 := NULL
    );
--
  procedure set_font
    ( p_index pls_integer
    , p_fontsize_pt number
    , p_output_to_doc boolean := true
    );
--
  function set_font
    ( p_fontname varchar2
    , p_fontsize_pt number
    , p_output_to_doc boolean := true
    )
  return pls_integer;
--
  procedure set_font
    ( p_fontname varchar2
    , p_fontsize_pt number
    , p_output_to_doc boolean := true
    );
--
  function set_font
    ( p_family varchar2
    , p_style varchar2 := 'N'
    , p_fontsize_pt number := null
    , p_output_to_doc boolean := true
    )
  return pls_integer;
--
  procedure set_font
    ( p_family varchar2
    , p_style varchar2 := 'N'
    , p_fontsize_pt number := null
    , p_output_to_doc boolean := true
    );
--
  procedure set_font_style(p_style varchar2 := 'N');
--
  procedure new_page;
--
  function load_ttf_font
    ( p_font blob
    , p_encoding varchar2 := 'WINDOWS-1252'
    , p_embed boolean := false
    , p_compress boolean := true
    , p_offset number := 1
    )
  return pls_integer;
--
  procedure load_ttf_font
    ( p_font blob
    , p_encoding varchar2 := 'WINDOWS-1252'
    , p_embed boolean := false
    , p_compress boolean := true
    , p_offset number := 1
    );
--
  function load_ttf_font
    ( p_dir varchar2 := 'MY_FONTS'
    , p_filename varchar2 := 'BAUHS93.TTF'
    , p_encoding varchar2 := 'WINDOWS-1252'
    , p_embed boolean := false
    , p_compress boolean := true
    )
  return pls_integer;
--
  procedure load_ttf_font
    ( p_dir varchar2 := 'MY_FONTS'
    , p_filename varchar2 := 'BAUHS93.TTF'
    , p_encoding varchar2 := 'WINDOWS-1252'
    , p_embed boolean := false
    , p_compress boolean := true
    );
--
  procedure load_ttc_fonts
    ( p_ttc blob
    , p_encoding varchar2 := 'WINDOWS-1252'
    , p_embed boolean := false
    , p_compress boolean := true
    );
--
  procedure load_ttc_fonts
    ( p_dir varchar2 := 'MY_FONTS'
    , p_filename varchar2 := 'CAMBRIA.TTC'
    , p_encoding varchar2 := 'WINDOWS-1252'
    , p_embed boolean := false
    , p_compress boolean := true
    );
--
  procedure set_color( p_rgb varchar2 := '000000' );
--
  procedure set_color
    ( p_red number := 0
    , p_green number := 0
    , p_blue number := 0
    );
--
  procedure set_bk_color( p_rgb varchar2 := 'ffffff' );
--
  procedure set_bk_color
    ( p_red number := 0
    , p_green number := 0
    , p_blue number := 0
    );
--
  procedure horizontal_line
    ( p_x in number
    , p_y in number
    , p_width in number
    , p_line_width in number := 0.5
    , p_line_color in varchar2 := '000000'
    );
  procedure horizontal_line
    ( p_x VARCHAR2
    , p_y VARCHAR2
    , p_width VARCHAR2
    , p_line_width VARCHAR2 := '0.5pt'
    , p_line_color varchar2 := '000000'
    );
--
  procedure vertical_line
    ( p_x in number
    , p_y in number
    , p_height in number
    , p_line_width in number := 0.5
    , p_line_color in varchar2 := '000000'
    );
  procedure vertical_line
    ( p_x VARCHAR2
    , p_y VARCHAR2
    , p_height VARCHAR2
    , p_line_width VARCHAR2 := '0.5pt'
    , p_line_color varchar2 := '000000'
    );

--
  procedure rect
    ( p_x in number
    , p_y in number
    , p_width in number
    , p_height in number
    , p_line_color in varchar2 := null
    , p_fill_color in varchar2 := null
    , p_line_width in number := 0.5
    );

  procedure rect
    ( p_x VARCHAR2
    , p_y VARCHAR2
    , p_width VARCHAR2
    , p_height VARCHAR2
    , p_line_color varchar2 := null
    , p_fill_color varchar2 := null
    , p_line_width VARCHAR2 := '0.5pt'
    );
--
  function get_ParamPT(p_vString   IN VARCHAR2,
                       p_vXY IN VARCHAR2 DEFAULT 'Y') RETURN NUMBER;

  function get( p_what in pls_integer )
  return number;
--
procedure put_image
    ( p_img blob
    , p_x number
    , p_y number
    , p_width number := null
    , p_height number := null
    , p_align varchar2 := 'center'
    , p_valign varchar2 := 'top'
    , p_um VARCHAR:='pt'
  --ITA:  Nuovi parametri per Larghezza e Altezza Cella
  --ENG:  New parameter for cell Width & Height
    , p_cellWidth number:=null
    , p_cellHeight number:=null
  );
--
  procedure put_image
    ( p_dir varchar2
    , p_file_name varchar2
    , p_x number
    , p_y number
    , p_width number := null
    , p_height number := null
    , p_align varchar2 := 'center'
    , p_valign varchar2 := 'top'
    , p_um VARCHAR:='pt'
    );
--
  procedure put_image
    ( p_url varchar2
    , p_x number
    , p_y number
    , p_width number := null
    , p_height number := null
    , p_align varchar2 := 'center'
    , p_valign varchar2 := 'top'
    , p_um VARCHAR:='pt'
    );

  Function BorderType(p_vBorder in varchar2) return number;
--
  procedure set_page_proc( p_src clob );
  procedure set_page_proc( p_src VARCHAR2 );
--
  type tp_col_widths is table of number;
  type tp_headers    is table of varchar2(32767);
  type tp_formats    is table of varchar2(32767);
  type tp_colors     is table of varchar2(6); -- Array of 6 varchar (2 color triads)
  type tp_colors9    is table of varchar2(9); -- Array of 9 varchar (3 color triads)
  type tp_column IS RECORD (    --Columns format
     colLabel    VARCHAR2(100), --Column Label - Intestazione Colonna
     colWidth    NUMBER,        --Column Width - Larghezza colonna (mm)
     offsetX     number,        --X position of Column - Force X from LEFT side
     offsetY     number,        --Y position of Column - Force Y position from TOP
                                --  how many [um] move down from top border of data row
                                -- (this value is subtracted from y)
     cellRow     INTEGER,       --Column's row for "multirow record"
     -- Header formatting
     hFontName   VARCHAR2(100), --Font Family as Helvetica - Times-Roman
     hFontStyle  VARCHAR2(2),   --Font Style as Bold / Italic ecc
     hFontSize   NUMBER,        --Font Size in pt
     hFontColor  VARCHAR2(6),   --ink color
     hBackColor  VARCHAR2(6),   --paper color
     hLineColor  VARCHAR2(6),   --border color
     hLineSize   NUMBER,        --Border Thickness; 0 no border
     hBorder     number(2),     --Side of border to drow 0-15 (binary mode TBLR see BorderType function)
     hAlignment  VARCHAR2(1),   --Horizontal Alignment Left, Center, Right, Justified
     hAlignVert  VARCHAR2(1),   --Vertical   Alignment Top , Middle, Bottom
     hTMargin    NUMBER,        --Top    Margin
     hBMargin    NUMBER,        --Bottom Margin
     hLMargin    NUMBER,        --Left   Margin
     hRMargin    NUMBER,        --Right  Margin
     hCHeight    number,        --Cell Height (mm); Default is rowHeight
     -- Table formatting
     tFontName   VARCHAR2(100), --Font Family as Helvetica - Times-Roman
     tFontStyle  VARCHAR2(2),   --Font Style as Bold / Italic ecc
     tFontSize   NUMBER,        --Font Size in pt
     tFontColor  VARCHAR2(6),   --ink color
     tBackColor  VARCHAR2(6),   --paper color
     tLineColor  VARCHAR2(6),   --border color
     tLineSize   NUMBER,        --Border Thickness; 0 no border
     tBorder     number(2),     --Side of border to drow 0-15 (binary mode TBLR see BorderType function)
     tAlignment  VARCHAR2(1),   --Horizontal Alignment Left, Center, Right, Justified
     tAlignVert  VARCHAR2(1),   --Vertical   Alignment Top , Middle, Bottom
     tTMargin    NUMBER,        --Top    Margin
     tBMargin    NUMBER,        --Bottom Margin
     tLMargin    NUMBER,        --Left   Margin
     tRMargin    NUMBER,        --Right  Margin
     tCHeight    number,        --Cell Height (mm); Default is rowHeight
     tNumFormat  VARCHAR2(100),  --Number or Date Format : Default TM9 o dd.mm.yyyy

     vSpacing    VARCHAR2(10),  --Spacing bewteen lines in pt, font%, mm
     vInterline  VARCHAR2(10),  --Interline in pt, font%, mm. Override vSpacing if defined
     hSpacing    VARCHAR2(10),  --Header Spacing bewteen lines in pt, font%, mm
     hInterline  VARCHAR2(10),  --Header Interline in pt, font%, mm. Override vSpacing if defined

     -- Calculate values
     cSpacing      NUMBER,      --Spacing in pt
     cInterline    NUMBER,      --Interline in pt
     cTextArea     NUMBER       --Max text width in column

     ,ctSpacing    NUMBER       --Spacing in pt
     ,ctInterline  NUMBER       --Interline in pt
     ,ctTextArea   NUMBER       --Max text width in column
     ,chSpacing    NUMBER       --Spacing in pt
     ,chInterline  NUMBER       --Interline in pt
     ,chTextArea   NUMBER       --Max text width in column

     );
  TYPE tp_columns IS TABLE OF tp_column;

  TYPE tp_labeldef is record (
      MaxColumns   PLS_INTEGER  -- Number of Label Columns in a sheet
     ,MaxRows      PLS_INTEGER  -- Number of Label Rows    in a sheet
     ,Width        NUMBER       -- Label Width  in pt
     ,Height       NUMBER       -- Label Height in pt
     ,hDistance    NUMBER       -- Horizontal distance between two labels in pt
     ,vDistance    NUMBER       -- Vertical   distance between two labels in pt
  );
  g_labeldef tp_labeldef;

  type tp_CellRowText      is table of varchar2(400) INDEX BY BINARY_INTEGER;
  type tp_CellRowTextX     is table of NUMBER        INDEX BY BINARY_INTEGER;
  type tp_CellRowTextY     is table of NUMBER        INDEX BY BINARY_INTEGER;
  type tp_CellRowTextWidth is table of NUMBER        INDEX BY BINARY_INTEGER;
  type tp_CellRowHeight    is table of NUMBER        INDEX BY BINARY_INTEGER;

  TYPE tp_Cell IS RECORD (             -- Content of the cell
     cX            NUMBER,             -- Left side
     cY            NUMBER,             -- Bottom side
     cYbase        NUMBER,             -- Baseline of cell row
     cTextHeight   NUMBER,             -- Text Height of all text rows
     cRowsCount    NUMBER,             -- Number of text rows
     cTy           NUMBER,             -- Text distance of firts row from top side
     cWidth        NUMBER,             -- Cell Width  (pt)
     cHeight       NUMBER,             -- Cell Height (pt)
     cRowText      tp_CellRowText,     -- array of text
     cRowTextX     tp_CellRowTextX,    -- array of distance from left side
     cRowTextY     tp_CellRowTextY,    -- array of distance from cTy
     cRowTextWidth tp_CellRowTextWidth,-- array of text width
     cImage        BLOB                -- blob of image
     );
  TYPE tp_Cells IS TABLE OF tp_Cell INDEX BY BINARY_INTEGER; -- Array of cells in a data row
--
  procedure query2table
    ( p_query      varchar2
    , p_formats    tp_columns :=null
    , p_colors     tp_colors  :=null --Default Colors
    , p_hRowHeight NUMBER     :=null --Autodetect
    , p_tRowHeight NUMBER     :=null --Autodetect
    , p_um         VARCHAR2   :='pt' --
    , p_startX     number     := 0   -- Distance from left border
    , p_BreakField number     := 0   -- No Break
    , p_Interline  number     :=1.2
    , p_startY     number     := 0   -- Distance from top border
    , p_Frame      varchar2   :=null -- Border Around format
    , p_bulk_size  pls_integer:= 200
    );
  PROCEDURE query2table
    ( p_query      VARCHAR2
    , p_formats    tp_columns :=null
    , p_colors     varchar2   :=NULL -- colour list CSV
    , p_hRowHeight NUMBER     :=NULL
    , p_tRowHeight NUMBER     :=NULL
    , p_um         VARCHAR2   :='pt'
    , p_startX     number     := 0
    , p_BreakField number     := 0
    , p_Interline  number     :=1.2
    , p_startY     number     := 0   -- Distance from top border
    , p_Frame      varchar2   :=null -- Border Around format
    , p_bulk_size  pls_integer:= 200
    );

  PROCEDURE query2Labels
    ( p_query      VARCHAR2
    , p_formats    tp_columns :=null
    , p_colors     tp_colors  :=NULL
    , p_hRowHeight NUMBER     :=NULL
    , p_tRowHeight NUMBER     :=NULL
    , p_um         VARCHAR2   :='pt'
    , p_startX     number     := 0
    , p_labelDef   tp_labeldef
    , p_Interline  number     :=1.2
    , p_startY     number     := 0   -- Distance from top border
    , p_Frame      varchar2   :=null -- Border Around format
    );
  PROCEDURE query2Labels
    ( p_query      VARCHAR2
    , p_formats    tp_columns :=null
    , p_colors     varchar2   :=NULL -- colour list CSV
    , p_hRowHeight NUMBER     :=NULL
    , p_tRowHeight NUMBER     :=NULL
    , p_um         VARCHAR2   :='pt'
    , p_startX     number     := 0
    , p_labelDef   tp_labeldef
    , p_Interline  number     :=1.2
    , p_startY     number     := 0   -- Distance from top border
    , p_Frame      varchar2   :=null -- Border Around format
    );
--
$IF not DBMS_DB_VERSION.ver_le_10 $THEN
  procedure refcursor2table
    ( p_rc          sys_refcursor
    , p_formats     tp_columns  :=null
    , p_colors      tp_colors   :=null
    , p_hRowHeight  NUMBER      :=null
    , p_tRowHeight  NUMBER      :=null
    , p_um          VARCHAR2    :='pt'
    , p_startX      NUMBER      := 0
    , p_BreakField  number      := 0
    , p_Interline   number      :=1.2
    , p_startY      NUMBER      := 0
    , p_Frame       varchar2    :=null -- Border Around format
    , p_bulk_size   pls_integer := 200
    );
$END
$IF not DBMS_DB_VERSION.ver_le_10 $THEN
  procedure refcursor2label
    ( p_rc          sys_refcursor
    , p_formats     tp_columns  :=null
    , p_colors      tp_colors   :=null
    , p_hRowHeight  NUMBER      :=null
    , p_tRowHeight  NUMBER      :=null
    , p_um          VARCHAR2    :='pt'
    , p_startX      NUMBER      := 0
    , p_labelDef    tp_labeldef
    , p_Interline   number      :=1.2
    , p_startY      NUMBER      := 0
    , p_Frame       varchar2    :=null -- Border Around format
    , p_bulk_size   pls_integer := 200
    );
$END
--
  procedure pr_goto_page( i_npage number );
--
  procedure pr_goto_current_page;

end;
/
