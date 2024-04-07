create or replace package as_pdf is
/*
******************************************************************************
**
** Author: Anton Scheffer
** Date: 11-04-2012
** Website:  http://technology.amis.nl
** See also: http://technology.amis.nl/?p=17718
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

--
  function file2blob( p_dir varchar2, p_file_name varchar2 )
  return blob;
--
  function conv2uu( p_value number, p_unit varchar2 )
  return number;
--
  function adler32( p_src in blob )
  return varchar2;
--
  procedure set_Log(p_vNewValue in boolean:=true);
--
  procedure set_Language(p_vNewValue in varchar2:='EN');
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
  procedure put_txt
    ( p_x number
    , p_y number
    , p_txt varchar2
    , p_degrees_rotation number := null
    , p_um varchar2 := 'pt' -- Add by ValR
    );

  procedure g_put_txt
    ( p_x varchar2
    , p_y varchar2
    , p_txt varchar2
    , p_degrees_rotation number := null
    );
--
  function str_len( p_txt varchar2 )
  return number;
--
-- ValR Chiamata alternativa, con unit? di misura all'inizio
  procedure write
    ( p_txt in varchar2
    , p_x in number := null
    , p_y in number := null
    , p_line_height in number := null
    , p_start in number := null -- left side of the available text box
    , p_width in number := null -- width of the available text box
    , p_alignment in varchar2 := null
    , p_um in varchar2 := 'pt'
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
    ( p_x varchar2
    , p_y varchar2
    , p_width varchar2
    , p_line_width varchar2 := '0.5pt'
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
    ( p_x varchar2
    , p_y varchar2
    , p_height varchar2
    , p_line_width varchar2 := '0.5pt'
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
    ( p_x varchar2
    , p_y varchar2
    , p_width varchar2
    , p_height varchar2
    , p_line_color varchar2 := null
    , p_fill_color varchar2 := null
    , p_line_width varchar2 := '0.5pt'
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
    , p_um varchar2 := 'pt'
    -- New parameters for cell Width & Height
    , p_cellWidth number := null
    , p_cellHeight number := null
    , p_adler32 varchar2 := null
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
    , p_um varchar2 := 'pt'
    -- New parameters for cell Width & Height
    , p_cellWidth number := null
    , p_cellHeight number := null
    , p_adler32 varchar2 := null
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
    , p_um varchar2 := 'pt'
    -- New parameters for cell Width & Height
    , p_cellWidth number := null
    , p_cellHeight number := null
    , p_adler32 varchar2 := null
    );
--
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
    , p_formats    tp_columns
    , p_colors     tp_colors
    , p_hRowHeight number      := null
    , p_tRowHeight number      := null
    , p_um         varchar2    := 'pt'
    , p_startX     number      := 0    -- Distance from left border
    , p_BreakField number      := 0
    , p_Interline  number      := 1.2
    , p_startY     number      := 0    -- Distance from top border
    , p_Frame      varchar2    := null -- Border Around format
    , p_bulk_size  pls_integer := 200
    );
  procedure query2table
    ( p_query      varchar2
    , p_formats    tp_columns
    , p_colors     varchar2
    , p_hRowHeight number      := null
    , p_tRowHeight number      := null
    , p_um         varchar2    := 'pt'
    , p_startX     number      := 0    -- Distance from left border
    , p_BreakField number      := 0
    , p_Interline  number      := 1.2
    , p_startY     number      := 0    -- Distance from top border
    , p_Frame      varchar2    := null -- Border Around format
    , p_bulk_size  pls_integer := 200
    );
  procedure query2table
    ( p_query   varchar2
    , p_widths  tp_col_widths := null
    , p_headers tp_headers    := null
    );
--
  procedure query2Labels
    ( p_query      varchar2
    , p_formats    tp_columns
    , p_colors     tp_colors
    , p_hRowHeight number      := null
    , p_tRowHeight number      := null
    , p_um         varchar2    := 'pt'
    , p_startX     number      := 0    -- Distance from left border
    , p_labelDef   tp_labeldef
    , p_Interline  number      := 1.2
    , p_startY     number      := 0    -- Distance from top border
    , p_Frame      varchar2    := null -- Border Around format
    , p_bulk_size  pls_integer := 200
    );
  procedure query2Labels
    ( p_query      varchar2
    , p_formats    tp_columns
    , p_colors     varchar2
    , p_hRowHeight number      := null
    , p_tRowHeight number      := null
    , p_um         varchar2    := 'pt'
    , p_startX     number      := 0    -- Distance from left border
    , p_labelDef   tp_labeldef
    , p_Interline  number      := 1.2
    , p_startY     number      := 0    -- Distance from top border
    , p_Frame      varchar2    := null -- Border Around format
    , p_bulk_size  pls_integer := 200
    );
--
-- Defined starting from ORACLE 11
$IF not DBMS_DB_VERSION.ver_le_10 $THEN
  procedure refcursor2table
    ( p_rc         sys_refcursor
    , p_formats    tp_columns
    , p_colors     tp_colors
    , p_hRowHeight number      := null
    , p_tRowHeight number      := null
    , p_um         varchar2    := 'pt'
    , p_startX     number      := 0    -- Distance from left border
    , p_BreakField number      := 0
    , p_Interline  number      := 1.2
    , p_startY     number      := 0    -- Distance from top border
    , p_Frame      varchar2    := null -- Border Around format
    , p_bulk_size  pls_integer := 200
    );
  procedure refcursor2table
    ( p_rc         sys_refcursor
    , p_formats    tp_columns
    , p_colors     varchar2
    , p_hRowHeight number      := null
    , p_tRowHeight number      := null
    , p_um         varchar2    := 'pt'
    , p_startX     number      := 0    -- Distance from left border
    , p_BreakField number      := 0
    , p_Interline  number      := 1.2
    , p_startY     number      := 0    -- Distance from top border
    , p_Frame      varchar2    := null -- Border Around format
    , p_bulk_size  pls_integer := 200
    );
  procedure refcursor2table
    ( p_rc      sys_refcursor
    , p_widths  tp_col_widths := null
    , p_headers tp_headers    := null
    );
--
  procedure refcursor2label
    ( p_rc         sys_refcursor
    , p_formats    tp_columns
    , p_colors     tp_colors
    , p_hRowHeight number      := null
    , p_tRowHeight number      := null
    , p_um         varchar2    := 'pt'
    , p_startX     number      := 0    -- Distance from left border
    , p_labelDef   tp_labeldef
    , p_Interline  number      := 1.2
    , p_startY     number      := 0    -- Distance from top border
    , p_Frame      varchar2    := null -- Border Around format
    , p_bulk_size  pls_integer := 200
    );
  procedure refcursor2label
    ( p_rc         sys_refcursor
    , p_formats    tp_columns
    , p_colors     varchar2
    , p_hRowHeight number      := null
    , p_tRowHeight number      := null
    , p_um         varchar2    := 'pt'
    , p_startX     number      := 0    -- Distance from left border
    , p_labelDef   tp_labeldef
    , p_Interline  number      := 1.2
    , p_startY     number      := 0    -- Distance from top border
    , p_Frame      varchar2    := null -- Border Around format
    , p_bulk_size  pls_integer := 200
    );
$END
--
  type tVertices is table of number index by pls_integer;

  PATH_MOVE_TO    CONSTANT NUMBER:=1;
  PATH_LINE_TO    CONSTANT NUMBER:=2;
  PATH_CURVE_TO   CONSTANT NUMBER:=3;
  PATH_CLOSE      CONSTANT NUMBER:=4;

  type tPathElement IS RECORD (
    nType NUMBER,
    nVal1 NUMBER,
    nVal2 NUMBER,
    nVal3 NUMBER,
    nVal4 NUMBER,
    nVal5 NUMBER,
    nVal6 NUMBER
  );

  TYPE tPath IS TABLE OF tPathElement INDEX BY BINARY_INTEGER;
--
  PROCEDURE PR_GOTO_PAGE(i_nPage IN NUMBER);

  PROCEDURE PR_GOTO_CURRENT_PAGE;

  PROCEDURE PR_LINE(i_nX1         IN NUMBER,
                    i_nY1         IN NUMBER,
                    i_nX2         IN NUMBER,
                    i_nY2         IN NUMBER,
                    i_vcLineColor IN VARCHAR2 DEFAULT NULL,
                    i_nLineWidth  IN NUMBER DEFAULT 0.5,
                    i_vcStroke    IN VARCHAR2 DEFAULT NULL
                   );

  PROCEDURE PR_POLYGON(i_lXs         IN tVertices,
                       i_lYs         IN tVertices,
                       i_vcLineColor IN VARCHAR2 DEFAULT NULL,
                       i_vcFillColor IN VARCHAR2 DEFAULT NULL,
                       i_nLineWidth  IN NUMBER DEFAULT 0.5
                      );

  PROCEDURE PR_PATH(i_lPath       IN tPath,
                    i_vcLineColor IN VARCHAR2 DEFAULT NULL,
                    i_vcFillColor IN VARCHAR2 DEFAULT NULL,
                    i_nLineWidth  IN NUMBER DEFAULT 0.5
                   );
--

end;
/
