create or replace package body as_pdf is

-- *****************************************************
-- constants
  c_package constant varchar2(32) := 'AS_PDF'; -- Package Name
  c_version constant varchar2(32) := '3.6.3'; -- Package Version
  c_nl      constant varchar2(2)  := chr(13) || chr(10);
--
  type tp_pls_tab is table of pls_integer index by pls_integer;
  type tp_objects_tab is table of number(10) index by pls_integer;
  type tp_pages_tab is table of blob index by pls_integer;
  type tp_settings is record (
      page_width      number
    , page_height     number
    , margin_left     number
    , margin_right    number
    , margin_top      number
    , margin_bottom   number
    , hRowHeight      number  -- Default Row Header Height  (pt)
    , tRowHeight      number  -- Default Row Table Height   (pt)
    , tRowHeightMin   number  -- Minumum Row Table height
    , tRowHeightExact number  -- Exact   Row Table height
    , LabelMode       boolean
    );
  type tp_settings_tab is table of tp_settings index by pls_integer;
  type tp_font is record (
      standard boolean
    , family varchar2(100)
    , style varchar2(2)  -- N Normal
                         -- I Italic
                         -- B Bold
                         -- BI Bold Italic
    , subtype varchar2(15)
    , name varchar2(100)
    , fontname varchar2(100)
    , char_width_tab tp_pls_tab
    , encoding varchar2(100)    , charset varchar2(1000)
    , compress_font boolean := true
    , fontsize number
    , unit_norm number
    , bb_xmin pls_integer
    , bb_ymin pls_integer
    , bb_xmax pls_integer
    , bb_ymax pls_integer
    , flags pls_integer
    , first_char pls_integer
    , last_char pls_integer
    , italic_angle number
    , ascent pls_integer
    , descent pls_integer
    , capheight pls_integer
    , stemv pls_integer
    , diff varchar2(32767)
    , cid boolean := false
    , fontfile2 blob
    , ttf_offset pls_integer
    , used_chars tp_pls_tab
    , numGlyphs pls_integer
    , indexToLocFormat pls_integer
    , loca tp_pls_tab
    , code2glyph tp_pls_tab
    , hmetrics tp_pls_tab
    );
  type tp_font_tab is table of tp_font index by pls_integer;
  type tp_img is record (
      adler32 varchar2(8)
    , width pls_integer
    , height pls_integer
    , color_res pls_integer
    , color_tab raw(768)
    , greyscale boolean
    , pixels blob
    , type varchar2(5)
    , nr_colors pls_integer
    , transparancy_index pls_integer
    );
  type tp_img_tab is table of tp_img index by pls_integer;
  type tp_info is record (
      title varchar2(1024)
    , author varchar2(1024)
    , subject varchar2(1024)
    , keywords varchar2(32767)
    );
  type tp_page_prcs is table of clob index by pls_integer;
--
  type tHex is table of pls_integer index by VARCHAR2(2);

  lHex tHex;
-- *****************************************************
-- globals
  g_objects             tp_objects_tab;
  g_pages               tp_pages_tab;
  g_settings_per_page   tp_settings_tab;
  g_settings            tp_settings;
  g_fonts               tp_font_tab;
  g_used_fonts          tp_pls_tab;
  g_images              tp_img_tab;
  g_info                tp_info;
  g_page_prcs           tp_page_prcs;
  g_current_font_record tp_font;
  g_current_font        pls_integer; -- Index of last font used
  g_current_fontPDF     pls_integer; -- Index of last font sent to doc
  g_page_nr             pls_integer;
  g_pdf_doc             blob;        -- the PDF-document being constructed
  g_x                   number;      -- current x-location of the "cursor"
  g_y                   number;      -- current y-location of the "cursor"
  g_current_fcolor      VARCHAR2(6); -- Current Foreground Color
  g_current_bcolor      VARCHAR2(6); -- Current Background Color
  g_bForce              BOOLEAN;     -- Force Font Changing
  g_Log                 BOOLEAN     := FALSE;
  g_Language            VARCHAR2(2) := 'EN';

-- Generic Functions
  PROCEDURE log(p_vString IN VARCHAR2, p_bFlag IN BOOLEAN:=FALSE) IS
  BEGIN
    IF g_Log THEN
      if p_bFlag then
        dbms_output.put_line(p_vString);
      end if;
    END IF;
  END;
-- Return only First Char of string in Uppercase, . if null
  FUNCTION Upper1(p_vText in varchar2,
                  p_vDefault in varchar2 Default '.' ) return varchar2 is
  begin
    return upper(substr(p_vText||p_vDefault,1,1));
  END;
-- Return numeric value, with decimals, from string of parameter
  FUNCTION get_ParamNumber(p_vString IN VARCHAR2) RETURN NUMBER IS
  BEGIN
    RETURN to_number(regexp_replace(regexp_substr(p_vString,'[[:digit:]-,.]+'),'[,.]', g_vDP ));
  END;
-- Return measure unit of parameter string, accept letter and % symbol
  FUNCTION get_ParamUDM(p_vString IN VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN regexp_substr(p_vString,'[[:alpha:]%]+');
  END;
  -- Return pt value from parameter string with  measure unit
  FUNCTION get_ParamPT(p_vString   IN VARCHAR2,
                       p_vXY IN VARCHAR2 DEFAULT 'Y') RETURN NUMBER IS
    v_nParam NUMBER;
  BEGIN
    v_nParam := conv2uu(get_ParamNumber(p_vString),get_ParamUDM(p_vString));
    IF v_nParam < 0 THEN
      IF p_vXY='Y' THEN
        v_nParam:=g_settings.page_height+v_nParam; --Negative Y = Distance from Top border
      ELSE
        v_nParam:=g_settings.page_width +v_nParam; --Negative X = Distance from Right border
      END IF;
    END IF;
    RETURN v_nParam;
  END;

  Function parseString(v_vParse in out varchar2,
                       p_vSep   in varchar2:=',') return varchar2 is
    c integer;
    v_vReturn varchar2(100);
  BEGIN
    c := instr(v_vParse, p_vSep);
    case c
      when 0 then
        v_vReturn:=v_vParse;
        v_vParse:='';
      when 1 then
        v_vReturn:='';
        v_vParse:=substr(v_vParse,2);
      else
        v_vReturn:=substr(v_vParse, 1, c-1);
        v_vParse:=substr(v_vParse, c+1);
    end case;
    return v_vReturn;
  END;

  procedure set_Log(p_vNewValue in boolean:=true) is
  begin
    g_Log:=p_vNewValue;
  end;

  procedure set_Language(p_vNewValue in varchar2:='EN') is
  begin
    g_Language:=upper(p_vNewValue);
  end;

  procedure RaiseError(p_nErrNum in number) is
    v_vMsg varchar2(100);
  begin
    case g_Language
      when 'ES' then -- Spanish
        case p_nErrNum
          when -20001 then
            v_vMsg:='demasiadas columnas o ancho excesivo de las columnas';
          when -20002 then
            v_vMsg:='no se pudo calcular el número máximo de columnas';
          when -20003 then
            v_vMsg:='demasiadas columnas, excede el ancho de la página';
          when -20011 then
            v_vMsg:='demasiadas filas o alto excesivo de las filas';
          when -20012 then
            v_vMsg:='no se pudo calcular el número máximo de filas';
          when -20013 then
            v_vMsg:='demasiadas filas, excede el alto de la página';
          when -20100 then
            v_vMsg:='el ancho de las columnas excede el ancho de la página';
          else
            v_vMsg:='Error no identificado';
        end case;
      when 'IT' then -- Italian
        case p_nErrNum
          when -20001 then
            v_vMsg:='Troppe colonne o larghezza colonne eccessiva';
          when -20002 then
            v_vMsg:='non posso calcolare il numeor massimo di colonne';
          when -20003 then
            v_vMsg:='Troppe colonne, eccedono larghezza pagina';
          when -20011 then
            v_vMsg:='Troppe righe o altezza righe eccessiva';
          when -20012 then
            v_vMsg:='non posso calcolare in numero massimo di righe';
          when -20013 then
            v_vMsg:='Troppe righe, eccedono altezza pagina';
          when -20100 then
            v_vMsg:='La larghezza delle colonne eccede la larghezza del foglio';
          else
            v_vMsg:='Errore non codificato';
        end case;
      else -- English (Default)
        case p_nErrNum
          when -20001 then
            v_vMsg:='too many columns or excessive column width';
          when -20002 then
            v_vMsg:='unable to calculate max columns';
          when -20003 then
            v_vMsg:='too many columns, exceed page width';
          when -20011 then
            v_vMsg:='too many rows or excessive row height';
          when -20012 then
            v_vMsg:='unable to calculate max rows';
          when -20013 then
            v_vMsg:='too many rows, exceed page height';
          when -20100 then
            v_vMsg:='Columns width exceed page width';
          else
            v_vMsg:='Error whithout description';
        end case;
    end case;
    Raise_application_error(p_nErrNum,v_vMsg);
  end;

  function num2raw( p_value number )
  return raw
  is
  begin
    return hextoraw( to_char( p_value, 'FM0XXXXXXX' ) );
  end;
--
  function raw2num( p_value raw )
  return number
  is
  begin
    return to_number( rawtohex( p_value ), 'XXXXXXXX' );
  end;
--
  function raw2num( p_value raw, p_pos pls_integer, p_len pls_integer )
  return pls_integer
  is
  begin
    return to_number( rawtohex( utl_raw.substr( p_value, p_pos, p_len ) ), 'XXXXXXXX' );
  end;
--
  function to_short( p_val raw, p_factor number := 1 )
  return number
  is
    t_rv number;
  begin
    t_rv := to_number( rawtohex( p_val ), 'XXXXXXXXXX' );
    if t_rv > 32767
    then
      t_rv := t_rv - 65536;
    end if;
    return t_rv * p_factor;
  end;
--
  function blob2num( p_blob blob, p_len integer, p_pos integer )
  return number
  is
  begin
    return to_number( rawtohex( dbms_lob.substr( p_blob, p_len, p_pos ) ), 'xxxxxxxx' );
  end;
--
  function file2blob( p_dir varchar2, p_file_name varchar2 )
  return blob
  is
    t_raw raw(32767);
    t_blob blob;
    fh utl_file.file_type;
  begin
    fh := utl_file.fopen( p_dir, p_file_name, 'rb' );
    dbms_lob.createtemporary( t_blob, true );
    loop
      begin
        utl_file.get_raw( fh, t_raw );
        dbms_lob.append( t_blob, t_raw );
      exception
        when no_data_found
        then
          exit;
      end;
    end loop;
    utl_file.fclose( fh );
    return t_blob;
  exception
    when others
    then
      if utl_file.is_open( fh )
      then
        utl_file.fclose( fh );
      end if;
      raise;
  end;
--
  procedure init_core_fonts
  is
    function uncompress_withs( p_compressed_tab varchar2 )
    return tp_pls_tab
    is
      t_rv tp_pls_tab;
      t_tmp raw(32767);
    begin
      if p_compressed_tab is not null
      then
        t_tmp := utl_compress.lz_uncompress
          ( utl_encode.base64_decode( utl_raw.cast_to_raw( p_compressed_tab ) ) );
        for i in 0 .. 255
        loop
          t_rv( i ) := to_number( utl_raw.substr( t_tmp, i * 4 + 1, 4 ), '0xxxxxxx' );
        end loop;
      end if;
      return t_rv;
    end;
--
    procedure init_core_font
      ( p_ind pls_integer
      , p_family varchar2
      , p_style varchar2
      , p_name varchar2
      , p_compressed_tab varchar2
      )
    is
    begin
      g_fonts( p_ind ).family := p_family;
      g_fonts( p_ind ).style := p_style;
      g_fonts( p_ind ).name := p_name;
      g_fonts( p_ind ).fontname := p_name;
      g_fonts( p_ind ).standard := true;
      g_fonts( p_ind ).encoding := 'WE8MSWIN1252';
      g_fonts( p_ind ).charset := sys_context( 'userenv', 'LANGUAGE' );
      g_fonts( p_ind ).charset := substr( g_fonts( p_ind ).charset
                                        , 1
                                        , instr( g_fonts( p_ind ).charset, '.' )
                                        ) || g_fonts( p_ind ).encoding;
      g_fonts( p_ind ).char_width_tab := uncompress_withs( p_compressed_tab );
    end;
  begin
    init_core_font( 1, 'helvetica', 'N', 'Helvetica'
      ,  'H4sIAAAAAAAAC81Tuw3CMBC94FQMgMQOLAGVGzNCGtc0dAxAT+8lsgE7RKJFomOA'
      || 'SLT4frHjBEFJ8XSX87372C8A1Qr+Ax5gsWGYU7QBAK4x7gTnGLOS6xJPOd8w5NsM'
      || '2OvFvQidAP04j1nyN3F7iSNny3E6DylPeeqbNqvti31vMpfLZuzH86oPdwaeo6X+'
      || '5X6Oz5VHtTqJKfYRNVu6y0ZyG66rdcxzXJe+Q/KJ59kql+bTt5K6lKucXvxWeHKf'
      || '+p6Tfersfh7RHuXMZjHsdUkxBeWtM60gDjLTLoHeKsyDdu6m8VK3qhnUQAmca9BG'
      || 'Dq3nP+sV/4FcD6WOf9K/ne+hdav+DTuNLeYABAAA' );
--
    init_core_font( 2, 'helvetica', 'I', 'Helvetica-Oblique'
      ,  'H4sIAAAAAAAAC81Tuw3CMBC94FQMgMQOLAGVGzNCGtc0dAxAT+8lsgE7RKJFomOA'
      || 'SLT4frHjBEFJ8XSX87372C8A1Qr+Ax5gsWGYU7QBAK4x7gTnGLOS6xJPOd8w5NsM'
      || '2OvFvQidAP04j1nyN3F7iSNny3E6DylPeeqbNqvti31vMpfLZuzH86oPdwaeo6X+'
      || '5X6Oz5VHtTqJKfYRNVu6y0ZyG66rdcxzXJe+Q/KJ59kql+bTt5K6lKucXvxWeHKf'
      || '+p6Tfersfh7RHuXMZjHsdUkxBeWtM60gDjLTLoHeKsyDdu6m8VK3qhnUQAmca9BG'
      || 'Dq3nP+sV/4FcD6WOf9K/ne+hdav+DTuNLeYABAAA' );
--
    init_core_font( 3, 'helvetica', 'B', 'Helvetica-Bold'
      ,  'H4sIAAAAAAAAC8VSsRHCMAx0SJcBcgyRJaBKkxXSqKahYwB6+iyRTbhLSUdHRZUB'
      || 'sOWXLF8SKCn+ZL/0kizZuaJ2/0fn8XBu10SUF28n59wbvoCr51oTD61ofkHyhBwK'
      || '8rXusVaGAb4q3rXOBP4Qz+wfUpzo5FyO4MBr39IH+uLclFvmCTrz1mB5PpSD52N1'
      || 'DfqS988xptibWfbw9Sa/jytf+dz4PqQz6wi63uxxBpCXY7uUj88jNDNy1mYGdl97'
      || '856nt2f4WsOFed4SpzumNCvlT+jpmKC7WgH3PJn9DaZfA42vlgh96d+wkHy0/V95'
      || 'xyv8oj59QbvBN2I/iAuqEAAEAAA=' );
--
    init_core_font( 4, 'helvetica', 'BI', 'Helvetica-BoldOblique'
      ,  'H4sIAAAAAAAAC8VSsRHCMAx0SJcBcgyRJaBKkxXSqKahYwB6+iyRTbhLSUdHRZUB'
      || 'sOWXLF8SKCn+ZL/0kizZuaJ2/0fn8XBu10SUF28n59wbvoCr51oTD61ofkHyhBwK'
      || '8rXusVaGAb4q3rXOBP4Qz+wfUpzo5FyO4MBr39IH+uLclFvmCTrz1mB5PpSD52N1'
      || 'DfqS988xptibWfbw9Sa/jytf+dz4PqQz6wi63uxxBpCXY7uUj88jNDNy1mYGdl97'
      || '856nt2f4WsOFed4SpzumNCvlT+jpmKC7WgH3PJn9DaZfA42vlgh96d+wkHy0/V95'
      || 'xyv8oj59QbvBN2I/iAuqEAAEAAA=' );
--
    init_core_font( 5, 'times', 'N', 'Times-Roman'
      ,  'H4sIAAAAAAAAC8WSKxLCQAyG+3Bopo4bVHbwHGCvUNNT9AB4JEwvgUBimUF3wCNR'
      || 'qAoGRZL9twlQikR8kzTvZBtF0SP6O7Ej1kTnSRfEhHw7+Jy3J4XGi8w05yeZh2sE'
      || '4j312ZDeEg1gvSJy6C36L9WX1urr4xrolfrSrYmrUCeDPGMu5+cQ3Ur3OXvQ+TYf'
      || '+2FGexOZvTM1L3S3o5fJjGQJX2n68U2ur3X5m3cTvfbxsk9pcsMee60rdTjnhNkc'
      || 'Zip9HOv9+7/tI3Oif3InOdV/oLdx3gq2HIRaB1Ob7XPk35QwwxDyxg3e09Dv6nSf'
      || 'rxQjvty8ywDce9CXvdF9R+4y4o+7J1P/I9sABAAA' );
--
    init_core_font( 6, 'times', 'I', 'Times-Italic'
      ,  'H4sIAAAAAAAAC8WSPQ6CQBCFF+i01NB5g63tPcBegYZTeAB6SxNLjLUH4BTEeAYr'
      || 'Kwpj5ezsW2YgoKXFl2Hnb9+wY4x5m7+TOOJMdIFsRywodkfMBX9aSz7bXGp+gj6+'
      || 'R4TvOtJ3CU5Eq85tgGsbxG3QN8iFZY1WzpxXwkckFTR7e1G6osZGWT1bDuBnTeP5'
      || 'KtW/E71c0yB2IFbBphuyBXIL9Y/9fPvhf8se6vsa8nmeQtU6NSf6ch9fc8P9DpqK'
      || 'cPa5/I7VxDwruTN9kV3LDvQ+h1m8z4I4x9LIbnn/Fv6nwOdyGq+d33jk7/cxztyq'
      || 'XRhTz/it7Mscg7fT5CO+9ahnYk20Hww5IrwABAAA' );
--
    init_core_font( 7, 'times', 'B', 'Times-Bold'
      , 'H4sIAAAAAAAAC8VSuw3CQAy9XBqUAVKxAZkgHQUNEiukySxpqOjTMQEDZIrUDICE'
      || 'RHUVVfy9c0IQJcWTfbafv+ece7u/Izs553cgAyN/APagl+wjgN3XKZ5kmTg/IXkw'
      || 'h4JqXUEfAb1I1VvwFYysk9iCffmN4+gtccSr5nlwDpuTepCZ/MH0FZibDUnO7MoR'
      || 'HXdDuvgjpzNxgevG+dF/hr3dWfoNyEZ8Taqn+7d7ozmqpGM8zdMYruFrXopVjvY2'
      || 'in9gXe+5vBf1KfX9E6TOVBsb8i5iqwQyv9+a3Gg/Cv+VoDtaQ7xdPwfNYRDji09g'
      || 'X/FvLNGmO62B9jSsoFwgfM+jf1z/SPwrkTMBOkCTBQAEAAA=' );
--
    init_core_font( 8, 'times', 'BI', 'Times-BoldItalic'
      ,  'H4sIAAAAAAAAC8WSuw2DMBCGHegYwEuECajIAGwQ0TBFBnCfPktkAKagzgCRIqWi'
      || 'oso9fr+Qo5RB+nT2ve+wMWYzf+fgjKmOJFelPhENnS0xANJXHfwHSBtjfoI8nMMj'
      || 'tXo63xKW/Cx9ONRn3US6C/wWvYeYNr+LH2IY6cHGPkJfvsc5kX7mFjF+Vqs9iT6d'
      || 'zwEL26y1Qz62nWlvD5VSf4R9zPuon/ne+C45+XxXf5lnTGLTOZCXPx8v9Qfdjdid'
      || '5vD/f/+/pE/Ur14kG+xjTHRc84pZWsC2Hjk2+Hgbx78j4Z8W4DlL+rBnEN5Bie6L'
      || 'fsL+1u/InuYCdsdaeAs+RxftKfGdfQDlDF/kAAQAAA==' );
--
    init_core_font( 9, 'courier', 'N', 'Courier', null );
    for i in 0 .. 255
    loop
      g_fonts( 9 ).char_width_tab( i ) := 600;
    end loop;
--
    init_core_font( 10, 'courier', 'I', 'Courier-Oblique', null );
    g_fonts( 10 ).char_width_tab := g_fonts( 9 ).char_width_tab;
--
    init_core_font( 11, 'courier', 'B', 'Courier-Bold', null );
    g_fonts( 11 ).char_width_tab := g_fonts( 9 ).char_width_tab;
--
    init_core_font( 12, 'courier', 'BI', 'Courier-BoldOblique', null );
    g_fonts( 12 ).char_width_tab := g_fonts( 9 ).char_width_tab;
--
    init_core_font( 13, 'symbol', 'N', 'Symbol'
      ,  'H4sIAAAAAAAAC82SIU8DQRCFZ28xIE+cqcbha4tENKk/gQCJJ6AweIK9H1CHqKnp'
      || 'D2gTFBaDIcFwCQkJSTG83fem7SU0qYNLvry5nZ25t7NnZkv7c8LQrFhAP6GHZvEY'
      || 'HOB9ylxGubTfNVRc34mKpFonzBQ/gUZ6Ds7AN6i5lv1dKv8Ab1eKQYSV4hUcgZFq'
      || 'J/Sec7fQHtdTn3iqfvdrb7m3e2pZW+xDG3oIJ/Li3gfMr949rlU74DyT1/AuTX1f'
      || 'YGhOzTP8B0/RggsEX/I03vgXPrrslZjfM8/pGu40t2ZjHgud97F7337mXP/GO4h9'
      || '3WmPPaOJ/jrOs9yC52MlrtUzfWupfTX51X/L+13Vl/J/s4W2S3pSfSh5DmeXerMf'
      || '+LXhWQAEAAA=' );
--
    init_core_font( 14, 'zapfdingbats', 'N', 'ZapfDingbats'
      ,  'H4sIAAAAAAAAC83ROy9EQRjG8TkzjdJl163SSHR0EpdsVkSi2UahFhUljUKUIgoq'
      || 'CrvJCtFQyG6EbSSERGxhC0ofQAQFxbIi8T/7PoUPIOEkvzxzzsycdy7O/fUTtToX'
      || 'bnCuvHPOV8gk4r423ovkGQ5od5OTWMeesmBz/RuZIWv4wCAY4z/xjipeqflC9qAD'
      || 'aRwxrxkJievSFzrRh36tZ1zttL6nkGX+A27xrLnttE/IBji9x7UvcIl9nPJ9AL36'
      || 'd1L9hyihoDW10L62cwhNyhntryZVExYl3kMj+zym+CrJv6M8VozPmfr5L8uwJORL'
      || 'tox7NFHG/Obj79FlwhqZ1X292xn6CbAXP/fjjv6rJYyBtUdl1vxEO6fcRB7bMmJ3'
      || 'GYZsTN0GdrDL/Ao5j1GZNr5kwqydX5z1syoiYEq5gCtlSrXi+mVbi3PfVAuhoQAE'
      || 'AAA=' );
--
  end;
--
  function to_char_round
    ( p_value number
    , p_precision pls_integer := 2
    )
  return varchar2
  is
  begin
    return to_char( round( p_value, p_precision ), 'TM9', 'NLS_NUMERIC_CHARACTERS=.,' );
  end;
--
  procedure raw2pdfdoc( p_raw blob )
  is
  begin
    dbms_lob.append( g_pdf_doc, p_raw );
  end;
--
  procedure txt2pdfdoc( p_txt varchar2 )
  is
  begin
    raw2pdfdoc( utl_raw.cast_to_raw( p_txt || c_nl ) );
  end;
--
  function add_object( p_txt varchar2 := null )
  return number
  is
    t_self number(10);
  begin
    t_self := g_objects.count( );
    g_objects( t_self ) := dbms_lob.getlength( g_pdf_doc );
--
    if p_txt is null
    then
      txt2pdfdoc( t_self || ' 0 obj' );
    else
      txt2pdfdoc( t_self || ' 0 obj' || c_nl || '<<' || p_txt || '>>' || c_nl || 'endobj' );
    end if;
--
    return t_self;
  end;
--
  procedure add_object( p_txt varchar2 := null )
  is
    t_dummy number(10) := add_object( p_txt );
  begin
    null;
  end;
--
  function adler32( p_src in blob )
  return varchar2
  is
    s1 pls_integer := 1;
    s2 pls_integer := 0;
    n  pls_integer;
    step_size number;
    tmp varchar2(32766);
    c65521 constant pls_integer := 65521;
  begin
    step_size := trunc( 16383 / dbms_lob.getchunksize( p_src ) ) * dbms_lob.getchunksize( p_src );
    -- AW: Bugfix for Chunksizes > 16383
    if step_size=0 then
      step_size:=16383;
    end if;
    for j in 0 .. trunc( ( dbms_lob.getlength( p_src ) - 1 ) / step_size )
    loop
      tmp := rawtohex( dbms_lob.substr( p_src, step_size, j * step_size + 1 ) );
      for i in 1 .. length( tmp ) / 2
      loop
        --n := to_number( substr( tmp, i * 2 - 1, 2 ), 'xx' );
        n := lHex( substr( tmp, i * 2 - 1, 2 ) );
        s1 := s1 + n;
        if s1 >= c65521
        then
          s1 := s1 - c65521;
        end if;
        s2 := s2 + s1;
        if s2 >= c65521
        then
          s2 := s2 - c65521;
        end if;
      end loop;
    end loop;
    return to_char( s2, 'fm0XXX' ) || to_char( s1, 'fm0XXX' );
  end;
--
  function flate_encode( p_val blob )
  return blob
  is
    t_blob blob;
  begin
    t_blob := hextoraw( '789C' );
    dbms_lob.copy( t_blob
                 , utl_compress.lz_compress( p_val )
                 , dbms_lob.lobmaxsize
                 , 3
                 , 11
                 );
    dbms_lob.trim( t_blob, dbms_lob.getlength( t_blob ) - 8 );
    dbms_lob.append( t_blob, hextoraw( adler32( p_val ) ) );
    return t_blob;
  end;
--
  procedure put_stream
    ( p_stream blob
    , p_compress boolean := true
    , p_extra varchar2 := ''
    , p_tag boolean := true
    )
  is
    t_blob blob;
    t_compress boolean := false;
  begin
    if p_compress and nvl( dbms_lob.getlength( p_stream ), 0 ) > 0
    then
      t_compress := true;
      t_blob := flate_encode( p_stream );
    else
      t_blob := p_stream;
    end if;
    txt2pdfdoc( case when p_tag then '<<' end
                || case when t_compress then '/Filter /FlateDecode ' end
                || '/Length ' || nvl( length( t_blob ), 0 )
                || p_extra
                || '>>' );
    txt2pdfdoc( 'stream' );
    raw2pdfdoc( t_blob );
    txt2pdfdoc( 'endstream' );
    if dbms_lob.istemporary( t_blob ) = 1
    then
      dbms_lob.freetemporary( t_blob );
    end if;
  end;
--
  function add_stream
    ( p_stream blob
    , p_extra varchar2 := ''
    , p_compress boolean := true
    )
  return number
  is
    t_self number(10);
  begin
    t_self := add_object;
    put_stream( p_stream
              , p_compress
              , p_extra
              );
    txt2pdfdoc( 'endobj' );
    return t_self;
  end;
--
  function subset_font( p_index pls_integer )
  return blob
  is
    t_tmp           blob;
    t_header        blob;
    t_tables        blob;
    t_len           pls_integer;
    t_code          pls_integer;
    t_glyph         pls_integer;
    t_offset        pls_integer;
    t_factor        pls_integer;
    t_unicode       pls_integer;
    t_used_glyphs   tp_pls_tab;
    t_fmt           varchar2(10);
    t_utf16_charset varchar2(1000);
    t_raw           raw(32767);
    t_v             varchar2(32767);
    t_table_records raw(32767);
  begin
    if g_fonts( p_index ).cid
    then
      t_used_glyphs := g_fonts( p_index ).used_chars;
      t_used_glyphs( 0 ) := 0;
    else
      t_utf16_charset := substr( g_fonts( p_index ).charset, 1, instr( g_fonts( p_index ).charset, '.' ) ) || 'AL16UTF16';
      t_used_glyphs( 0 ) := 0;
      t_code := g_fonts( p_index ).used_chars.first;
      while t_code is not null
      loop
        t_unicode := to_number( rawtohex( utl_raw.convert( hextoraw( to_char( t_code, 'fm0x' ) )
                                                                    , t_utf16_charset
                                                                    , g_fonts( p_index ).charset  -- ???? database characterset ?????
                                                                    )
                                        ), 'XXXXXXXX' );
        if g_fonts( p_index ).flags = 4 -- a symbolic font
        then
-- assume code 32, space maps to the first code from the font
          t_used_glyphs( g_fonts( p_index ).code2glyph( g_fonts( p_index ).code2glyph.first + t_unicode - 32 ) ) := 0;
        else
          t_used_glyphs( g_fonts( p_index ).code2glyph( t_unicode ) ) := 0;
        end if;
        t_code := g_fonts( p_index ).used_chars.next( t_code );
      end loop;
    end if;
--
    dbms_lob.createtemporary( t_tables, true );
    t_header := utl_raw.concat( hextoraw( '00010000' )
                              , dbms_lob.substr( g_fonts( p_index ).fontfile2, 8, g_fonts( p_index ).ttf_offset + 4 )
                              );
    t_offset := 12 + blob2num( g_fonts( p_index ).fontfile2, 2, g_fonts( p_index ).ttf_offset + 4 ) * 16;
    t_table_records := dbms_lob.substr( g_fonts( p_index ).fontfile2
                                      , blob2num( g_fonts( p_index ).fontfile2, 2, g_fonts( p_index ).ttf_offset + 4 ) * 16
                                      , g_fonts( p_index ).ttf_offset + 12
                                      );
    for i in 1 .. blob2num( g_fonts( p_index ).fontfile2, 2, g_fonts( p_index ).ttf_offset + 4 )
    loop
      case utl_raw.cast_to_varchar2( utl_raw.substr( t_table_records, i * 16 - 15, 4 ) )
        when 'post'
        then
          dbms_lob.append( t_header
                         , utl_raw.concat( utl_raw.substr( t_table_records, i * 16 - 15, 4 ) -- tag
                                         , hextoraw( '00000000' ) -- checksum
                                         , num2raw( t_offset + dbms_lob.getlength( t_tables ) ) -- offset
                                         , num2raw( 32 ) -- length
                                         )
                         );
          dbms_lob.append( t_tables
                         , utl_raw.concat( hextoraw( '00030000' )
                                         , dbms_lob.substr( g_fonts( p_index ).fontfile2
                                                          , 28
                                                          , raw2num( t_table_records, i * 16 - 7, 4 ) + 5
                                                          )
                                         )
                         );
        when 'loca'
        then
          if g_fonts( p_index ).indexToLocFormat = 0
          then
            t_fmt := 'fm0XXX';
          else
            t_fmt := 'fm0XXXXXXX';
          end if;
          t_raw := null;
          dbms_lob.createtemporary( t_tmp, true );
          t_len := 0;
          for g in 0 .. g_fonts( p_index ).numGlyphs - 1
          loop
            t_raw := utl_raw.concat( t_raw, hextoraw( to_char( t_len, t_fmt ) ) );
            if utl_raw.length( t_raw ) > 32770
            then
              dbms_lob.append( t_tmp, t_raw );
              t_raw := null;
            end if;
            if t_used_glyphs.exists( g )
            then
              t_len := t_len + g_fonts( p_index ).loca( g + 1 ) - g_fonts( p_index ).loca( g );
            end if;
          end loop;
          t_raw := utl_raw.concat( t_raw, hextoraw( to_char( t_len, t_fmt ) ) );
          dbms_lob.append( t_tmp, t_raw );
          dbms_lob.append( t_header
                         , utl_raw.concat( utl_raw.substr( t_table_records, i * 16 - 15, 4 ) -- tag
                                         , hextoraw( '00000000' ) -- checksum
                                         , num2raw( t_offset + dbms_lob.getlength( t_tables ) ) -- offset
                                         , num2raw( dbms_lob.getlength( t_tmp ) ) -- length
                                         )
                         );
          dbms_lob.append( t_tables, t_tmp );
          dbms_lob.freetemporary( t_tmp );
        when 'glyf'
        then
          if g_fonts( p_index ).indexToLocFormat = 0
          then
            t_factor := 2;
          else
            t_factor := 1;
          end if;
          t_raw := null;
          dbms_lob.createtemporary( t_tmp, true );
          for g in 0 .. g_fonts( p_index ).numGlyphs - 1
          loop
            if (   t_used_glyphs.exists( g )
               and g_fonts( p_index ).loca( g + 1 ) > g_fonts( p_index ).loca( g )
               )
            then
              t_raw := utl_raw.concat( t_raw
                                     , dbms_lob.substr( g_fonts( p_index ).fontfile2
                                                      , ( g_fonts( p_index ).loca( g + 1 ) - g_fonts( p_index ).loca( g ) ) * t_factor
                                                      , g_fonts( p_index ).loca( g ) * t_factor + raw2num( t_table_records, i * 16 - 7, 4 ) + 1
                                                      )
                                     );
              if utl_raw.length( t_raw ) > 32778
              then
                dbms_lob.append( t_tmp, t_raw );
                t_raw := null;
              end if;
            end if;
          end loop;
          if utl_raw.length( t_raw ) > 0
          then
            dbms_lob.append( t_tmp, t_raw );
          end if;
          dbms_lob.append( t_header
                         , utl_raw.concat( utl_raw.substr( t_table_records, i * 16 - 15, 4 ) -- tag
                                         , hextoraw( '00000000' ) -- checksum
                                         , num2raw( t_offset + dbms_lob.getlength( t_tables ) ) -- offset
                                         , num2raw( dbms_lob.getlength( t_tmp ) ) -- length
                                         )
                         );
          dbms_lob.append( t_tables, t_tmp );
          dbms_lob.freetemporary( t_tmp );
        else
          dbms_lob.append( t_header
                         , utl_raw.concat( utl_raw.substr( t_table_records, i * 16 - 15, 4 )    -- tag
                                         , utl_raw.substr( t_table_records, i * 16 - 11, 4 )    -- checksum
                                         , num2raw( t_offset + dbms_lob.getlength( t_tables ) ) -- offset
                                         , utl_raw.substr( t_table_records, i * 16 - 3, 4 )     -- length
                                         )
                         );
          dbms_lob.copy( t_tables
                       , g_fonts( p_index ).fontfile2
                       , raw2num( t_table_records, i * 16 - 3, 4 )
                       , dbms_lob.getlength( t_tables ) + 1
                       , raw2num( t_table_records, i * 16 - 7, 4 ) + 1
                       );
      end case;
    end loop;
    dbms_lob.append( t_header, t_tables );
    dbms_lob.freetemporary( t_tables );
    return t_header;
  end;
--
  function add_font( p_index pls_integer )
  return number
  is
    t_self number(10);
    t_fontfile number(10);
    t_font_subset blob;
    t_used pls_integer;
    t_used_glyphs tp_pls_tab;
    t_w varchar2(32767);
    t_unicode pls_integer;
    t_utf16_charset varchar2(1000);
    t_width number;
  begin
    if g_fonts( p_index ).standard
    then
      return add_object( '/Type/Font'
                       || '/Subtype/Type1'
                       || '/BaseFont/' || g_fonts( p_index ).name
                       || '/Encoding/WinAnsiEncoding' -- code page 1252
                       );
    end if;
--
    if g_fonts( p_index ).cid
    then
      t_self := add_object;
      txt2pdfdoc( '<</Type/Font/Subtype/Type0/Encoding/Identity-H'
                || '/BaseFont/' || g_fonts( p_index ).name
                || '/DescendantFonts ' || to_char( t_self + 1 ) || ' 0 R'
                || '/ToUnicode ' || to_char( t_self + 8 ) || ' 0 R'
                || '>>' );
      txt2pdfdoc( 'endobj' );
      add_object;
      txt2pdfdoc( '[' || to_char( t_self + 2 ) || ' 0 R]' );
      txt2pdfdoc( 'endobj' );
      add_object( '/Type/Font/Subtype/CIDFontType2/CIDToGIDMap/Identity/DW 1000'
                || '/BaseFont/' || g_fonts( p_index ).name
                || '/CIDSystemInfo ' || to_char( t_self + 3 ) || ' 0 R'
                || '/W ' || to_char( t_self + 4 ) || ' 0 R'
                || '/FontDescriptor ' || to_char( t_self + 5 ) || ' 0 R' );
      add_object( '/Ordering(Identity) /Registry(Adobe) /Supplement 0' );
--
      t_utf16_charset := substr( g_fonts( p_index ).charset, 1, instr( g_fonts( p_index ).charset, '.' ) ) || 'AL16UTF16';
      t_used_glyphs := g_fonts( p_index ).used_chars;
      t_used_glyphs( 0 ) := 0;
      t_used := t_used_glyphs.first();
      while t_used is not null
      loop
        if g_fonts( p_index ).hmetrics.exists( t_used )
        then
          t_width := g_fonts( p_index ).hmetrics( t_used );
        else
          t_width := g_fonts( p_index ).hmetrics( g_fonts( p_index ).hmetrics.last() );
        end if;
        t_width := trunc( t_width * g_fonts( p_index ).unit_norm );
        if t_used_glyphs.prior( t_used ) = t_used - 1
        then
          t_w := t_w || ' ' || t_width;
        else
          t_w := t_w || '] ' || t_used || ' [' || t_width;
        end if;
        t_used := t_used_glyphs.next( t_used );
      end loop;
      t_w := '[' || ltrim( t_w, '] ' ) || ']]';
      add_object;
      txt2pdfdoc( t_w );
      txt2pdfdoc( 'endobj' );
      add_object
        (    '/Type/FontDescriptor'
          || '/FontName/' || g_fonts( p_index ).name
          || '/Flags ' || g_fonts( p_index ).flags
          || '/FontBBox [' || g_fonts( p_index ).bb_xmin
          || ' ' || g_fonts( p_index ).bb_ymin
          || ' ' || g_fonts( p_index ).bb_xmax
          || ' ' || g_fonts( p_index ).bb_ymax
          || ']'
          || '/ItalicAngle ' || to_char_round( g_fonts( p_index ).italic_angle )
          || '/Ascent ' || g_fonts( p_index ).ascent
          || '/Descent ' || g_fonts( p_index ).descent
          || '/CapHeight ' || g_fonts( p_index ).capheight
          || '/StemV ' || g_fonts( p_index ).stemv
          || '/FontFile2 ' || to_char( t_self + 6 ) || ' 0 R' );
      t_fontfile := add_stream( g_fonts( p_index ).fontfile2
                              , '/Length1 ' || dbms_lob.getlength( g_fonts( p_index ).fontfile2 )
                              , g_fonts( p_index ).compress_font
                              );
      t_font_subset := subset_font( p_index );
      t_fontfile := add_stream( t_font_subset
                              , '/Length1 ' || dbms_lob.getlength( t_font_subset )
                              , g_fonts( p_index ).compress_font
                              );
      declare
        t_g2c tp_pls_tab;
        t_code     pls_integer;
        t_c_start  pls_integer;
        t_map  varchar2(32767);
        t_cmap varchar2(32767);
        t_cor pls_integer;
        t_cnt pls_integer;
      begin
        t_code := g_fonts( p_index ).code2glyph.first;
        if g_fonts( p_index ).flags = 4 -- a symbolic font
        then
-- assume code 32, space maps to the first code from the font
          t_cor := t_code - 32;
        else
          t_cor := 0;
        end if;
        while t_code is not null
        loop
          t_g2c( g_fonts( p_index ).code2glyph( t_code ) ) := t_code - t_cor;
          t_code := g_fonts( p_index ).code2glyph.next( t_code );
        end loop;
        t_cnt := 0;
        t_used_glyphs := g_fonts( p_index ).used_chars;
        t_used := t_used_glyphs.first();
        while t_used is not null
        loop
          t_map := t_map || '<' || to_char( t_used, 'FM0XXX' )
                 || '> <' || to_char( t_g2c( t_used ), 'FM0XXX' )
                 || '>' || chr( 10 );
          if t_cnt = 99
          then
            t_cnt := 0;
            t_cmap := t_cmap || chr( 10 ) || '100 beginbfchar' || chr( 10 ) || t_map || 'endbfchar';
            t_map := '';
          else
            t_cnt := t_cnt + 1;
          end if;
          t_used := t_used_glyphs.next( t_used );
        end loop;
        if t_cnt > 0
        then
          t_cmap := t_cnt || ' beginbfchar' || chr( 10 ) || t_map || 'endbfchar';
        end if;
        t_fontfile := add_stream( utl_raw.cast_to_raw(
'/CIDInit /ProcSet findresource begin 12 dict begin
begincmap
/CIDSystemInfo
<< /Registry (Adobe) /Ordering (UCS) /Supplement 0 >> def
/CMapName /Adobe-Identity-UCS def /CMapType 2 def
1 begincodespacerange
<0000> <FFFF>
endcodespacerange
' || t_cmap || '
endcmap
CMapName currentdict /CMap defineresource pop
end
end' ) );
      end;
      return t_self;
    end if;
--
    g_fonts( p_index ).first_char := g_fonts( p_index ).used_chars.first();
    g_fonts( p_index ).last_char := g_fonts( p_index ).used_chars.last();
    t_self := add_object;
    txt2pdfdoc( '<</Type /Font '
              || '/Subtype /' || g_fonts( p_index ).subtype
              || ' /BaseFont /' || g_fonts( p_index ).name
              || ' /FirstChar ' || g_fonts( p_index ).first_char
              || ' /LastChar ' || g_fonts( p_index ).last_char
              || ' /Widths ' || to_char( t_self + 1 ) || ' 0 R'
              || ' /FontDescriptor ' || to_char( t_self + 2 ) || ' 0 R'
              || ' /Encoding ' || to_char( t_self + 3 ) || ' 0 R'
              || ' >>' );
    txt2pdfdoc( 'endobj' );
    add_object;
    txt2pdfdoc( '[' );
      begin
        for i in g_fonts( p_index ).first_char .. g_fonts( p_index ).last_char
        loop
          txt2pdfdoc( g_fonts( p_index ).char_width_tab( i ) );
        end loop;
      exception
        when others
        then
          log( '**** ' || g_fonts( p_index ).name );
      end;
      txt2pdfdoc( ']' );
      txt2pdfdoc( 'endobj' );
      add_object
        (    '/Type /FontDescriptor'
          || ' /FontName /' || g_fonts( p_index ).name
          || ' /Flags ' || g_fonts( p_index ).flags
          || ' /FontBBox [' || g_fonts( p_index ).bb_xmin
          || ' ' || g_fonts( p_index ).bb_ymin
          || ' ' || g_fonts( p_index ).bb_xmax
          || ' ' || g_fonts( p_index ).bb_ymax
          || ']'
          || ' /ItalicAngle ' || to_char_round( g_fonts( p_index ).italic_angle )
          || ' /Ascent ' || g_fonts( p_index ).ascent
          || ' /Descent ' || g_fonts( p_index ).descent
          || ' /CapHeight ' || g_fonts( p_index ).capheight
          || ' /StemV ' || g_fonts( p_index ).stemv
          || case
               when g_fonts( p_index ).fontfile2 is not null
                 then ' /FontFile2 ' || to_char( t_self + 4 ) || ' 0 R'
             end );
      add_object(    '/Type /Encoding /BaseEncoding /WinAnsiEncoding '
                         || g_fonts( p_index ).diff
                         || ' ' );
      if g_fonts( p_index ).fontfile2 is not null
      then
        t_font_subset := subset_font( p_index );
        t_fontfile :=
          add_stream( t_font_subset
                    , '/Length1 ' || dbms_lob.getlength( t_font_subset )
                    , g_fonts( p_index ).compress_font
                    );
    end if;
    return t_self;
  end;
--
  procedure add_image( p_img tp_img )
  is
    t_pallet number(10);
  begin
    if p_img.color_tab is not null
    then
      t_pallet := add_stream( p_img.color_tab );
    else
      t_pallet := add_object;  -- add an empty object
      txt2pdfdoc( 'endobj' );
    end if;
    add_object;
    txt2pdfdoc( '<</Type /XObject /Subtype /Image'
              ||  ' /Width ' || to_char( p_img.width )
              || ' /Height ' || to_char( p_img.height )
              || ' /BitsPerComponent ' || to_char( p_img.color_res )
              );
--
    if p_img.transparancy_index is not null
    then
      txt2pdfdoc( '/Mask [' || p_img.transparancy_index || ' ' || p_img.transparancy_index || ']' );
    end if;
    if p_img.color_tab is null
    then
      if p_img.greyscale
      then
        txt2pdfdoc( '/ColorSpace /DeviceGray' );
      else
        txt2pdfdoc( '/ColorSpace /DeviceRGB' );
      end if;
    else
      txt2pdfdoc(    '/ColorSpace [/Indexed /DeviceRGB '
                || to_char( utl_raw.length( p_img.color_tab ) / 3 - 1 )
                || ' ' || to_char( t_pallet ) || ' 0 R]'
                );
    end if;
--
    if p_img.type = 'jpg'
    then
      put_stream( p_img.pixels, false, '/Filter /DCTDecode', false );
    elsif p_img.type = 'png'
    then
      put_stream( p_img.pixels, false
                ,  ' /Filter /FlateDecode /DecodeParms <</Predictor 15 '
                || '/Colors ' || p_img.nr_colors
                || '/BitsPerComponent ' || p_img.color_res
                || ' /Columns ' || p_img.width
                || ' >> '
                , false );
    else
      put_stream( p_img.pixels, p_tag => false );
    end if;
    txt2pdfdoc( 'endobj' );
  end;
--
  function add_resources
  return number
  is
    t_ind pls_integer;
    t_self number(10);
    t_fonts tp_objects_tab;
  begin
--
    t_ind := g_used_fonts.first;
    while t_ind is not null
    loop
      t_fonts( t_ind ) := add_font( t_ind );
      t_ind := g_used_fonts.next( t_ind );
    end loop;
--
    t_self := add_object;
    txt2pdfdoc( '<</ProcSet [/PDF /Text]' );
--
    if g_used_fonts.count() > 0
    then
      txt2pdfdoc( '/Font <<' );
      t_ind := g_used_fonts.first;
      while t_ind is not null
      loop
        txt2pdfdoc( '/F'|| to_char( t_ind ) || ' '
                  || to_char( t_fonts( t_ind ) ) || ' 0 R'
                  );
        t_ind := g_used_fonts.next( t_ind );
      end loop;
      txt2pdfdoc( '>>' );
    end if;
--
    if g_images.count( ) > 0
    then
      txt2pdfdoc( '/XObject <<' );
      for i in g_images.first .. g_images.last
      loop
        txt2pdfdoc( '/I' || to_char( i ) || ' ' || to_char( t_self + 2 * i ) || ' 0 R' );
      end loop;
      txt2pdfdoc( '>>' );
    end if;
--
    txt2pdfdoc( '>>' );
    txt2pdfdoc( 'endobj' );
--
    if g_images.count( ) > 0
    then
      for i in g_images.first .. g_images.last
      loop
        add_image( g_images( i ) );
      end loop;
    end if;
    return t_self;
  end;
--
  procedure add_page
    ( p_page_ind pls_integer
    , p_parent number
    , p_resources number
    )
  is
    t_content number(10);
  begin
    t_content := add_stream( g_pages( p_page_ind ) );
    add_object;
    txt2pdfdoc( '<< /Type /Page' );
    txt2pdfdoc( '/Parent ' || to_char( p_parent ) || ' 0 R' );
    -- AW: Add a mediabox to each page
    txt2pdfdoc(    '/MediaBox [0 0 '
                || to_char_round( g_settings_per_page( p_page_ind ).page_width
                                , 0
                                )
                || ' '
                || to_char_round( g_settings_per_page( p_page_ind ).page_height
                                , 0
                                )
                || ']' );
    txt2pdfdoc( '/Contents ' || to_char( t_content ) || ' 0 R' );
    txt2pdfdoc( '/Resources ' || to_char( p_resources ) || ' 0 R' );
    txt2pdfdoc( '>>' );
    txt2pdfdoc( 'endobj' );
  end;
--
  function add_pages
  return number
  is
    t_self number(10);
    t_resources number(10);
  begin
    t_resources := add_resources;
    t_self := add_object;
    txt2pdfdoc( '<</Type/Pages/Kids [' );
--
    for i in g_pages.first .. g_pages.last
    loop
      txt2pdfdoc( to_char( t_self + i * 2 + 2 ) || ' 0 R' );
    end loop;
--
    -- AW: take the settings from page 1 as global settings
    if g_settings_per_page.exists(0) then
      g_settings := g_settings_per_page(0);
    end if;
    txt2pdfdoc( ']' );
    txt2pdfdoc( '/Count ' || g_pages.count() );
    txt2pdfdoc(    '/MediaBox [0 0 '
                || to_char_round( g_settings.page_width
                                , 0
                                )
                || ' '
                || to_char_round( g_settings.page_height
                                , 0
                                )
                || ']' );
    txt2pdfdoc( '>>' );
    txt2pdfdoc( 'endobj' );
--
    if g_pages.count() > 0
    then
      for i in g_pages.first .. g_pages.last
      loop
        add_page( i, t_self, t_resources );
      end loop;
    end if;
--
    return t_self;
  end;
--
  function add_catalogue
  return number
  is
  begin
    return add_object( '/Type/Catalog'
                     || '/Pages ' || to_char( add_pages ) || ' 0 R'
                     || '/OpenAction [0 /XYZ null null 0.77]'
                     );
  end;
--
  function add_info
  return number
  is
    t_banner varchar2( 1000 );
  begin
    begin
      select    replace( replace( replace( substr( banner
                                                 , 1
                                                 , 950
                                                 )
                                         , '\'
                                         , '\\'
                                         )
                                , '('
                                , '\('
                                )
                       , ')'
                       , '\)'
                       )
      into t_banner
      from v$version
      where instr( upper( banner )
                 , 'DATABASE'
                 ) > 0;
      t_banner := '/Creator (' || t_banner || ')';
    exception
      when others
      then
        null;
    end;
--
    return add_object( '/CreationDate (D:' || to_char( current_timestamp, 'YYYYMMDDhh24misstzh'':tzm''' ) || ')'
                     || '/ModDate (D:' || to_char( current_timestamp, 'YYYYMMDDhh24misstzh'':tzm''' ) || ')'
                     || t_banner
                     || '/Producer (' || c_package || ' ' || c_version || ' by Anton Scheffer)'
                     || '/Title <FEFF' || utl_i18n.string_to_raw( g_info.title, 'AL16UTF16' ) || '>'
                     || '/Author <FEFF' || utl_i18n.string_to_raw( g_info.author, 'AL16UTF16' ) || '>'
                     || '/Subject <FEFF' || utl_i18n.string_to_raw( g_info.subject, 'AL16UTF16' ) || '>'
                     || '/Keywords <FEFF' || utl_i18n.string_to_raw( g_info.keywords, 'AL16UTF16' ) || '>'
                     );
  end;
--
  procedure finish_pdf
  is
    t_xref number;
    t_info number(10);
    t_catalogue number(10);
  begin
    if g_pages.count = 0 then
      new_page;
    end if;
    if g_page_prcs.count > 0
    then
      for i in g_pages.first .. g_pages.last
      loop
        g_page_nr := i;
        for p in g_page_prcs.first .. g_page_prcs.last
        loop
          BEGIN
          -- Replace substitution key with
          -- #PAGE_NR#    Current page number
          -- #PAGE_COUNT# Total page number
          -- §            Package name

            EXECUTE IMMEDIATE
              replace(replace(replace(
                g_page_prcs( p ),
                  '#PAGE_NR#', i + 1 ),
                  '#PAGE_COUNT#', g_pages.count),
                  '§', c_package);

          EXCEPTION
            when others then
              log( 'finish_pdf: '||to_char(i)||g_page_prcs( p ));
              log( to_char(SQLCODE)||SQLERRM);
              null;
          END;

        end loop;
      end loop;
    end if;
    dbms_lob.createtemporary( g_pdf_doc, true );
    txt2pdfdoc( '%PDF-1.3' );
    raw2pdfdoc( hextoraw( '25E2E3CFD30D0A' ) );          -- add a hex comment
    t_info := add_info;
    t_catalogue := add_catalogue;
    t_xref := dbms_lob.getlength( g_pdf_doc );
    txt2pdfdoc( 'xref' );
    txt2pdfdoc( '0 ' || to_char( g_objects.count() ) );
    txt2pdfdoc( '0000000000 65535 f ' );
    for i in 1 .. g_objects.count( ) - 1
    loop
      txt2pdfdoc( to_char( g_objects( i ), 'fm0000000000' ) || ' 00000 n' );
                        -- this line should be exactly 20 bytes, including EOL
    end loop;
    txt2pdfdoc( 'trailer' );
    txt2pdfdoc( '<< /Root ' || to_char( t_catalogue ) || ' 0 R' );
    txt2pdfdoc( '/Info ' || to_char( t_info ) || ' 0 R' );
    txt2pdfdoc( '/Size ' || to_char( g_objects.count() ) );
    txt2pdfdoc( '>>' );
    txt2pdfdoc( 'startxref' );
    txt2pdfdoc( to_char( t_xref ) );
    txt2pdfdoc( '%%EOF' );
--
    g_objects.delete;
    for i in g_pages.first .. g_pages.last
    loop
      dbms_lob.freetemporary( g_pages( i ) );
    end loop;
    g_objects.delete;
    g_pages.delete;
    -- AW: Page-settings
    g_settings_per_page.delete;
    g_fonts.delete;
    g_used_fonts.delete;
    g_page_prcs.delete;
    if g_images.count() > 0
    then
      for i in g_images.first .. g_images.last
      loop
        if dbms_lob.istemporary( g_images( i ).pixels ) = 1
        then
          dbms_lob.freetemporary( g_images( i ).pixels );
        end if;
      end loop;
      g_images.delete;
    end if;
  end;
--
  function conv2uu( p_value number, p_unit varchar2 ) return NUMBER  IS
  -- Convert from p_valore in p_unit to pt
   c_inch constant number := 25.40025;
  begin
    if p_value is null then
      return null;
    end if;
    return round( case lower( p_unit )
                    when 'mm'    then p_value * 72  / c_inch
                    when 'cm'    then p_value * 720 / c_inch
                    when 'pt'    then p_value       -- also point
                    when 'point' then p_value
                    when 'inch'  then p_value * 72
                    when 'in'    then p_value * 72  -- also inch
                    when 'pica'  then p_value * 12
                    when 'p'     then p_value * 12  -- also pica
                    when 'pc'    then p_value * 12  -- also pica
                    when 'em'    then p_value * 12  -- also pica
                    when 'px'    then p_value       -- pixel impostazione provvisoria
                    when 'px'    then p_value * 0.8 -- pixel
                    WHEN '2mm'   THEN p_value/72*c_inch -- convert pt to mm
                    else null
                  end
                , 3
                );
  end;
--
  procedure set_page_size
    ( p_width number
    , p_height number
    , p_unit varchar2 := 'cm'
    )
  is
  begin
    g_settings.page_width := conv2uu( p_width, p_unit );
    g_settings.page_height := conv2uu( p_height, p_unit );
  end;
--
  procedure set_page_format( p_format varchar2 := 'A4' )
  is
  begin
    case upper( p_format )
      when 'A3'
      then
        set_page_size( 420, 297, 'mm' );
      when 'A4'
      then
        set_page_size( 297, 210, 'mm' );
      when 'A5'
      then
        set_page_size( 210, 148, 'mm' );
      when 'A6'
      then
        set_page_size( 148, 105, 'mm' );
      when 'LEGAL'
      then
        set_page_size( 14, 8.5, 'in' );
      when 'LETTER'
      then
        set_page_size( 11, 8.5, 'in' );
      when 'QUARTO'
      then
        set_page_size( 11, 9, 'in' );
      when 'EXECUTIVE'
      then
        set_page_size( 10.5, 7.25, 'in' );
      else
        null;
    end case;
  end;
--
  procedure set_page_orientation( p_orientation varchar2 := 'PORTRAIT' )
  is
    t_tmp number;
  begin
    if (  (   upper( p_orientation ) in ( 'L', 'LANDSCAPE' )
          and g_settings.page_height > g_settings.page_width
          )
       or ( upper( p_orientation ) in( 'P', 'PORTRAIT' )
          and g_settings.page_height < g_settings.page_width
          )
       )
    then
      t_tmp := g_settings.page_width;
      g_settings.page_width := g_settings.page_height;
      g_settings.page_height := t_tmp;
    end if;
  end;
--
  procedure set_margins
    ( p_top number := null
    , p_left number := null
    , p_bottom number := null
    , p_right number := null
    , p_unit varchar2 := 'cm'
    )
  is
    t_tmp number;
  begin
    t_tmp := nvl( conv2uu( p_top, p_unit ), -1 );
    if t_tmp < 0 or t_tmp > g_settings.page_height
    then
      t_tmp := conv2uu( 3, 'cm' );
    end if;
    g_settings.margin_top := t_tmp;
    t_tmp := nvl( conv2uu( p_bottom, p_unit ), -1 );
    if t_tmp < 0 or t_tmp > g_settings.page_height
    then
      t_tmp := conv2uu( 4, 'cm' );
    end if;
    g_settings.margin_bottom := t_tmp;
    t_tmp := nvl( conv2uu( p_left, p_unit ), -1 );
    if t_tmp < 0 or t_tmp > g_settings.page_width
    then
      t_tmp := conv2uu( 1, 'cm' );
    end if;
    g_settings.margin_left := t_tmp;
    t_tmp := nvl( conv2uu( p_right, p_unit ), -1 );
    if t_tmp < 0 or t_tmp > g_settings.page_width
    then
      t_tmp := conv2uu( 1, 'cm' );
    end if;
    g_settings.margin_right := t_tmp;
--
    if g_settings.margin_top + g_settings.margin_bottom + conv2uu( 1, 'cm' )> g_settings.page_height
    then
      g_settings.margin_top := 0;
      g_settings.margin_bottom := 0;
    end if;
    if g_settings.margin_left + g_settings.margin_right + conv2uu( 1, 'cm' )> g_settings.page_width
    then
      g_settings.margin_left := 0;
      g_settings.margin_right := 0;
    end if;
  end;

  procedure set_rowHeight(p_hRowHeight in number default null,
                          p_tRowHeight in number default null,
                          p_unit varchar2 := 'cm') is
    k_nDefaultHeightPT number:=4;
  begin
  -- Header   (can be: 0=No Header, null=Default, or positive)
    g_settings.hRowHeight:=coalesce(conv2uu(p_hRowHeight, p_unit), k_nDefaultHeightPT);
  -- Table    (can be: Negative=Set Min, Positive=Set Exact, null=Automatic
    g_settings.tRowHeightExact:=null;
    case
      when coalesce(p_tRowHeight,0) = 0 then
        g_settings.tRowHeightMin:=k_nDefaultHeightPT;
        g_settings.tRowHeightExact:=null;
      when coalesce(p_tRowHeight,0) < 0 then
        g_settings.tRowHeightMin:=conv2uu(abs(p_tRowHeight), p_unit);
        g_settings.tRowHeightExact:=null;
      else
        g_settings.tRowHeightMin:=conv2uu(p_tRowHeight, p_unit);
        g_settings.tRowHeightExact:=g_settings.tRowHeightMin;
    end case;
    g_settings.tRowHeight:=g_settings.tRowHeightMin;
  end;
--
  procedure set_info(p_title    varchar2 := null,
                     p_author   varchar2 := null,
                     p_subject  varchar2 := null,
                     p_keywords varchar2 := null) is
  begin
    g_info.title    := substr(p_title, 1, 1024);
    g_info.author   := substr(p_author, 1, 1024);
    g_info.subject  := substr(p_subject, 1, 1024);
    g_info.keywords := substr(p_keywords, 1, 16383);
  end;
--
  procedure init is
  begin
    g_objects.delete;
    g_pages.delete;
    -- AW: Page-settings
    g_settings_per_page.delete;
    g_fonts.delete;
    g_used_fonts.delete;
    g_page_prcs.delete;
    g_images.delete;
    g_settings := null;
    g_current_font := null;
    g_x := null;
    g_y := null;
    g_info := null;
    g_page_nr := null;
    g_objects( 0 ) := 0;
    init_core_fonts;
    set_page_format;
    set_page_orientation;
    set_margins;
  end;
--
  function get_pdf return BLOB is
  begin
    finish_pdf;
    return g_pdf_doc;
  end;
--
  procedure save_pdf
    ( p_dir varchar2 := 'PDF'
    , p_filename varchar2 := 'my.pdf'
    , p_freeblob boolean := true
    )
  is
    t_fh utl_file.file_type;
    t_len pls_integer := 32767;
  begin
    finish_pdf;
    t_fh := utl_file.fopen( p_dir, p_filename, 'wb' );
    for i in 0 .. trunc( ( dbms_lob.getlength( g_pdf_doc ) - 1 ) / t_len )
    loop
      utl_file.put_raw( t_fh
                      , dbms_lob.substr( g_pdf_doc
                                       , t_len
                                       , i * t_len + 1
                                       )
                      );
    end loop;
    utl_file.fclose( t_fh );
    if p_freeblob
    then
      dbms_lob.freetemporary( g_pdf_doc );
    end if;
  end;
--
  procedure raw2page( p_txt raw )
  is
  begin
    if g_pages.count() = 0
    then
      new_page;
    end if;
    dbms_lob.append( g_pages( coalesce( g_page_nr, g_pages.count( ) - 1 ) )
                   , utl_raw.concat( p_txt, hextoraw( '0D0A' ) )
                   );
  end;
--
  procedure txt2page( p_txt varchar2 )
  is
  begin
    raw2page( utl_raw.cast_to_raw( p_txt ) );
  end;
--
  procedure output_font_to_doc( p_output_to_doc boolean )  is
  begin
    if p_output_to_doc then
      txt2page( 'BT /F' || g_current_font || ' '
              || to_char_round( g_fonts( g_current_font ).fontsize ) || ' Tf ET'
              );
      g_current_fontPDF:=g_current_font;
    end if;
  end;
--
  procedure set_font
    ( p_index pls_integer
    , p_fontsize_pt number
    , p_output_to_doc boolean := true
    )
  is
  begin
    if p_index is not null
    then
      g_used_fonts( p_index ) := 0;
      g_fonts( p_index ).fontsize := p_fontsize_pt;
      g_current_font_record.fontsize := p_fontsize_pt;
      if nvl( g_current_font, -1 ) != p_index then -- AW: set only if different
        g_current_font := p_index;
        g_current_font_record := g_fonts( p_index );
      end if;
      output_font_to_doc( p_output_to_doc );
    end if;
  end;
--
  function set_font
    ( p_fontname varchar2
    , p_fontsize_pt number
    , p_output_to_doc boolean := true
    )
  return pls_integer
  is
    t_fontname varchar2(100);
  begin
    if p_fontname is null then
      if (  g_current_font is not null
         and p_fontsize_pt != g_fonts( g_current_font ).fontsize
         )
      then
        g_fonts( g_current_font ).fontsize := p_fontsize_pt;
        g_current_font_record := g_fonts( g_current_font );
        output_font_to_doc( p_output_to_doc );
      end if;
      return g_current_font;
    end if;
--
    t_fontname := lower( p_fontname );
    for i in g_fonts.first .. g_fonts.last
    loop
      if lower( g_fonts( i ).fontname ) = t_fontname
      then
        exit when g_current_font = i
              and g_fonts( i ).fontsize = p_fontsize_pt
              and g_page_nr is null
              and g_bForce=FALSE;
        g_fonts( i ).fontsize := coalesce( p_fontsize_pt
                                         , g_fonts( nvl( g_current_font, i ) ).fontsize
                                         , 12
                                         );
        g_current_font := i;
        g_current_font_record := g_fonts( i );
        g_used_fonts( i ) := 0;
        output_font_to_doc( p_output_to_doc );
        return g_current_font;
      end if;
    end loop;
    return null;
  end;
--
  procedure set_font
    ( p_fontname varchar2
    , p_fontsize_pt number
    , p_output_to_doc boolean := true
    )
  is
    t_dummy pls_integer;
  begin
    t_dummy := set_font( p_fontname, p_fontsize_pt, p_output_to_doc );
  end;
--
  function set_font
    ( p_family varchar2
    , p_style varchar2 := 'N'
    , p_fontsize_pt number := null
    , p_output_to_doc boolean := true
    )
  return pls_integer
  is
    t_family varchar2(100);
    t_style varchar2(100);
  begin
    if p_family is null and g_current_font is null
    then
      return null;
    end if;
    if p_family is null and  p_style is null and p_fontsize_pt is null
    then
      return null;
    end if;
    t_family := coalesce( lower( p_family )
                        , g_fonts( g_current_font ).family
                        );
    t_style := upper( p_style );
    t_style := case t_style
                 when 'NORMAL' then 'N'
                 when 'REGULAR' then 'N'
                 when 'BOLD' then 'B'
                 when 'ITALIC' then 'I'
                 when 'OBLIQUE' then 'I'
                 else t_style
               end;
    t_style := coalesce( t_style
                       , case when g_current_font is null then 'N' else g_fonts( g_current_font ).style end
                       );
--
    for i in g_fonts.first .. g_fonts.last
    loop
      if (   g_fonts( i ).family = t_family
         and g_fonts( i ).style = t_style
         )
      then
        return set_font( g_fonts( i ).fontname, p_fontsize_pt, p_output_to_doc );
      end if;
    end loop;
    return null;
  end;
--
  procedure set_font
    ( p_family varchar2
    , p_style varchar2 := 'N'
    , p_fontsize_pt number := null
    , p_output_to_doc boolean := true
    )
  is
    t_dummy pls_integer;
  begin
    t_dummy := set_font( p_family, p_style, p_fontsize_pt, p_output_to_doc );
  end;

  -- Change only font style
  PROCEDURE set_font_style(p_style varchar2 := 'N') IS
    t_dummy pls_integer;
  BEGIN
    t_dummy := set_font(to_char(NULL),p_style);
  END;
--
  procedure new_page is
  begin
    g_pages( g_pages.count() ) := null;
    g_settings_per_page( g_settings_per_page.count() ) := g_settings;
    dbms_lob.createtemporary( g_pages( g_pages.count() - 1 ), true );
    if g_current_font is not null and g_pages.count() > 0
    then
      txt2page( 'BT /F' || g_current_font || ' '
              || to_char_round( g_fonts( g_current_font ).fontsize )
              || ' Tf ET'
              );
    end if;
    g_x := null;
    g_y := null;
  end;
--
  function pdf_string( p_txt in blob )
  return blob
  is
    t_rv blob;
    t_ind integer;
    type tp_tab_raw is table of raw(1);
    tab_raw tp_tab_raw
      := tp_tab_raw( utl_raw.cast_to_raw( '\' )
                   , utl_raw.cast_to_raw( '(' )
                   , utl_raw.cast_to_raw( ')' )
                   );
  begin
    t_rv := p_txt;
    for i in tab_raw.first .. tab_raw.last
    loop
      t_ind := -1;
      loop
        t_ind := dbms_lob.instr( t_rv
                               , tab_raw( i )
                               , t_ind + 2
                               );
        exit when t_ind <= 0;
        dbms_lob.copy( t_rv
                     , t_rv
                     , dbms_lob.lobmaxsize
                     , t_ind + 1
                     , t_ind
                     );
        dbms_lob.copy( t_rv
                     , utl_raw.cast_to_raw( '\' )
                     , 1
                     , t_ind
                     , 1
                     );
      end loop;
    end loop;
    return t_rv;
  end;
--
  function txt2raw( p_txt varchar2 )
  return raw
  is
    t_rv raw(32767);
    t_unicode pls_integer;
  begin
    if g_current_font is null then
      set_font( 'helvetica' );
    end if;
    if g_fonts( g_current_font ).cid then
      for i in 1 .. length( p_txt )
      loop
        t_unicode := utl_raw.cast_to_binary_integer( utl_raw.convert( utl_raw.cast_to_raw( substr( p_txt, i, 1 ) )
                                                                    , 'AMERICAN_AMERICA.AL16UTF16'
                                                                    , sys_context( 'userenv', 'LANGUAGE' )  -- ???? font characterset ?????
                                                                    )
                                                 );
        if g_fonts( g_current_font ).flags = 4 -- a symbolic font
        then
-- assume code 32, space maps to the first code from the font
          t_unicode := g_fonts( g_current_font ).code2glyph.first + t_unicode - 32;
        end if;
        if g_current_font_record.code2glyph.exists( t_unicode )
        then
          g_fonts( g_current_font ).used_chars( g_current_font_record.code2glyph( t_unicode ) ) := 0;
          t_rv := utl_raw.concat( t_rv
                                , utl_raw.cast_to_raw( to_char( g_current_font_record.code2glyph( t_unicode ), 'FM0XXX' ) )
                                );
        else
          t_rv := utl_raw.concat( t_rv, utl_raw.cast_to_raw( '0000' ) );
        end if;
      end loop;
      t_rv := utl_raw.concat( utl_raw.cast_to_raw( '<' )
                            , t_rv
                            , utl_raw.cast_to_raw( '>' )
                            );
    else
      t_rv := utl_raw.convert( utl_raw.cast_to_raw( p_txt )
                             , g_fonts( g_current_font ).charset
                             , sys_context( 'userenv', 'LANGUAGE' )
                             );
      for i in 1 .. utl_raw.length( t_rv )
      loop
        g_fonts( g_current_font ).used_chars( raw2num( t_rv, i, 1 ) ) := 0;
      end loop;
      t_rv := utl_raw.concat( utl_raw.cast_to_raw( '(' )
                            , pdf_string( t_rv )
                            , utl_raw.cast_to_raw( ')' )
                            );
    end if;
    return t_rv;
  end;
--
  procedure put_raw( p_x number, p_y number, p_txt raw, p_degrees_rotation number := null )
  is
    c_pi constant number := 3.14159265358979323846264338327950288419716939937510;
    t_tmp varchar2(32767);
    t_sin number;
    t_cos number;
  begin
    t_tmp := to_char_round( p_x ) || ' ' || to_char_round( p_y );
    if p_degrees_rotation is null
    then
      t_tmp := t_tmp || ' Td ';
    else
      t_sin := sin( p_degrees_rotation / 180 * c_pi );
      t_cos := cos( p_degrees_rotation / 180 * c_pi );
      t_tmp := to_char_round( t_cos, 5 ) || ' ' || t_tmp;
      t_tmp := to_char_round( - t_sin, 5 ) || ' ' || t_tmp;
      t_tmp := to_char_round( t_sin, 5 ) || ' ' || t_tmp;
      t_tmp := to_char_round( t_cos, 5 ) || ' ' || t_tmp;
      t_tmp := t_tmp || ' Tm ';
    end if;
    raw2page( utl_raw.concat( utl_raw.cast_to_raw( 'BT ' || t_tmp )
                            , p_txt
                            , utl_raw.cast_to_raw( ' Tj ET' )
                            )
              );
  end;
--
  procedure put_txt
    ( p_x number
    , p_y number
    , p_txt varchar2
    , p_degrees_rotation number := null
    , p_um varchar2 := 'pt' -- Add by ValR
    )
  is
  begin
    if p_txt is not null then


      put_raw(conv2uu(p_x, p_um),
              conv2uu(p_y, p_um),
              txt2raw(p_txt),
              p_degrees_rotation);


      log(replace(replace(
          'p_txt('||
            to_char(p_x)||'; '||
            to_char(p_y)||'; '||
            p_txt ||'; '||
            to_char(p_degrees_rotation)||'; '||
            p_um ||')',
            ',','.'),
            ';',',')||';'
         , true);


    end if;
  end;

  procedure g_put_txt
    ( p_x varchar2
    , p_y varchar2
    , p_txt varchar2
    , p_degrees_rotation number := null
    )
  is
  begin
  -- Some as previous put_txt, but move global g_x and g_y
  -- Checks the presence of the \n character to calculate g_y position
    g_x:=nvl(get_ParamPT(p_x),g_x);
    g_y:=nvl(get_ParamPT(p_y),g_y);
    if p_txt is not null then


      put_raw(g_x, g_y,
              txt2raw(p_txt),
              p_degrees_rotation);


    end if;
  end;
--
  function str_len( p_txt in varchar2 )
  return number
  is
    t_width number;
    t_char pls_integer;
    t_rtxt raw(32767);
    t_tmp number;
    --t_font tp_font;
  begin
    if p_txt is null
    then
      return 0;
    end if;
--
    t_width := 0;
    if g_current_font_record.cid 
    then
      t_rtxt := utl_raw.convert( utl_raw.cast_to_raw( p_txt )
                               , 'AMERICAN_AMERICA.AL16UTF16' -- 16 bit font => 2 bytes per char
                               , sys_context( 'userenv', 'LANGUAGE' )  -- ???? font characterset ?????
                               );
      for i in 1 .. utl_raw.length( t_rtxt ) / 2
      loop
        t_char := to_number( utl_raw.substr( t_rtxt, i * 2 - 1, 2 ), 'xxxx' );
        if g_current_font_record.flags = 4
        then
-- assume code 32, space maps to the first code from the font
          t_char := g_current_font_record.code2glyph.first + t_char - 32;
        end if;
        if (   g_current_font_record.code2glyph.exists( t_char )
           and g_current_font_record.hmetrics.exists( g_current_font_record.code2glyph( t_char ) )   
           )
        then
          t_tmp := g_current_font_record.hmetrics( g_current_font_record.code2glyph( t_char ) );
        else
          t_tmp := g_current_font_record.hmetrics( g_current_font_record.hmetrics.last() );
        end if;
        t_width := t_width + t_tmp;
      end loop;
      t_width := t_width * g_current_font_record.unit_norm;
      t_width := t_width * g_current_font_record.fontsize / 1000;
    else
      t_rtxt := utl_raw.convert( utl_raw.cast_to_raw( p_txt )
                               , g_current_font_record.charset  -- should be an 8 bit font
                               , sys_context( 'userenv', 'LANGUAGE' )
                               );
      for i in 1 .. utl_raw.length( t_rtxt )
      loop
        t_char := to_number( utl_raw.substr( t_rtxt, i, 1 ), 'xx' );
        t_width := t_width + g_current_font_record.char_width_tab( t_char );
      end loop;
      t_width := t_width * g_current_font_record.fontsize / 1000;
    end if;
    return t_width;
  end;
--
    /* Full Justified String. NOTE: multiple space are replaced with single space */
    Function Justify(p_vRiga       in varchar2,  -- String to justify
                     p_nLineWidth  in number,    -- Width of usabel space
                     p_nSpaceWidth in number,    -- Width of single space char
                     v_nTextWidth  in out number) return varchar2 is
      v_vJRiga      varchar2(4000):='';   -- Justified row
      v_nSpaziJ     integer:=0;           -- Number of space to add
    begin

      v_nTextWidth :=str_len(p_vRiga);
      if p_nSpaceWidth=0 then
        return(p_vRiga); -- NO Justify Required. Non change in p_vRiga
      end if;

      v_nSpaziJ := round((p_nLineWidth-v_nTextWidth)/p_nSpaceWidth,0);

      for w in
        (with
          p as (
            select rownum r, regexp_substr(p_vRiga,'[^ ]+', 1, level) Word
              from dual connect by
                   regexp_substr(p_vRiga, '[^ ]+', 1, level) is not null), -- Word Wrap
          s as (
            select count(*)-1 spTot,
                   trunc(v_nSpaziJ/count(*)-1)+1 nSp,
                   mod(v_nSpaziJ,count(*)-1) spResto
               from p) -- Number of space to add
          select r,
                 Word ||
                   case when r<=spTot then lpad(' ', s.nSp) end ||
                   case when r<=spResto then ' ' end Jword
           from p cross join s
           order by r) -- word list with filled spaces
      loop
        v_vJRiga:=v_vJRiga||w.Jword;
      end loop;
      v_nTextWidth:=p_nLineWidth;
      return(v_vJRiga);
    end;
  procedure write
    ( p_txt in varchar2
    , p_x in number := null
    , p_y in number := null
    , p_line_height in number := null
    , p_start in number := null  -- left side of the available text box
    , p_width in number := null  -- width of the available text box
    , p_alignment in varchar2 := null
    , p_um in varchar2 := 'pt'  -- For recursive call use pt
    )
  is
    t_line_height number;
    t_x number;
    t_y number;
    t_start number;
    t_width number;
    t_len number;
    t_cnt pls_integer;
    t_ind pls_integer;
    t_alignment varchar2(100);
    k_um constant varchar2(2) := 'pt'; 

    function chkNewPage(y in number, t_line_height in number) return number is
      t_y number;
    begin
    -- Update t_y and check in new page are necessary
      t_y := y - t_line_height;
      if t_y < g_settings.margin_bottom then
        new_page;
        t_y := g_settings.page_height - g_settings.margin_top - t_line_height;
      end if;
      return(t_y);

    end;

  begin
    if p_txt is null
    then
      return;
    end if;
--
    if g_current_font is null
    then
      set_font( 'helvetica' );
    end if;

--
    t_line_height := nvl( conv2uu(p_line_height,p_um ), g_fonts( g_current_font ).fontsize );
    if (  t_line_height < g_fonts( g_current_font ).fontsize
       or t_line_height > ( g_settings.page_height - g_settings.margin_top - t_line_height ) / 4
       )
    then
      t_line_height := g_fonts( g_current_font ).fontsize;
    end if;
    t_start := nvl( conv2uu(p_start,p_um), g_settings.margin_left );
    if (  t_start < g_settings.margin_left
       or t_start > g_settings.page_width - g_settings.margin_right - g_settings.margin_left
       )
    then
      t_start := g_settings.margin_left;
    end if;
    t_width := nvl( conv2uu(p_width,p_um)
                  , g_settings.page_width - g_settings.margin_right - g_settings.margin_left
                  );
    if (  t_width < str_len( '   ' )
       or t_width > g_settings.page_width - g_settings.margin_right - g_settings.margin_left
       )
    then
      t_width := g_settings.page_width - g_settings.margin_right - g_settings.margin_left;
    end if;
    t_x := coalesce( conv2uu(p_x,p_um), g_x, g_settings.margin_left );
    t_y := coalesce( conv2uu(p_y,p_um), g_y
                   , g_settings.page_height - g_settings.margin_top - t_line_height
                   );
    if t_y < 0 then
      t_y := coalesce( g_y
                     , g_settings.page_height - g_settings.margin_top - t_line_height
                     ) - t_line_height;
    end if;
    if t_x > t_start + t_width then
      t_x := t_start;
      t_y := t_y - t_line_height;
    elsif t_x < t_start then
      t_x := t_start;
    end if;
    if t_y < g_settings.margin_bottom then
      new_page;
      t_x := t_start;
      t_y := g_settings.page_height - g_settings.margin_top - t_line_height;
    end if;

    t_ind := instr( p_txt, chr(10) );
    if t_ind > 0 then
    -- String contain LF   (LineFeed Char)
      g_x := t_x;
      g_y := t_y;
      -- Call write in recursive mode for chars before LF
      write( rtrim( substr( p_txt, 1, t_ind - 1 ), chr(13) ), t_x, t_y, t_line_height, t_start, t_width, p_alignment, k_um );
      t_y := chkNewPage(g_y,t_line_height);
      -- Update row being coordinates
      g_x := t_start;
      g_y := t_y;
      -- Call write in recursive mode for char after LF (string can contain more  LF)
      write( substr( p_txt, t_ind + 1 ), t_start, t_y, t_line_height, t_start, t_width, p_alignment, k_um );
      return;
    end if;

    -- Detect string lenght
    t_len := str_len( p_txt );
    t_alignment := upper( substr( ltrim( p_alignment ), 1, 1 ) );
    if t_len <= t_width - t_x + t_start  then
    -- The row is shorter than the space available
      if (t_alignment='R' or t_alignment='E' ) then
      -- Right align
        t_x := t_start + t_width - t_len;
      elsif t_alignment='C' then
      -- Center into usable space
        t_x := ( t_width + t_x + t_start - t_len ) / 2;
      elsif t_alignment='J' then  -- instr( 'LJ',  t_alignment)
      -- Always begin on left if justified
        if t_x > t_start then
          t_x := t_start;
          t_y := chkNewPage(g_y,t_line_height);
        end if;
      end if;
    -- send text to document
      if t_alignment='J' then
        put_txt( t_x, t_y, Justify(p_txt, t_width, str_len(' '), t_len));
        g_x := t_width+t_start;
      else
        put_txt( t_x, t_y, p_txt );
        g_x := t_x + t_len + str_len( ' ' );
      end if;
      g_y := t_y;
      return;
    end if;
    -- Count words into usable row width
    if t_alignment='J' then  -- instr( 'LJ',  t_alignment)
    -- Always begin on left if justified
      if t_x > t_start then
        t_x := t_start;
        t_y := chkNewPage(g_y,t_line_height);
      end if;
    end if;
    t_cnt := 0;
    while (   instr( p_txt, ' ', 1, t_cnt + 1 ) > 0
          and str_len( substr( p_txt, 1, instr( p_txt, ' ', 1, t_cnt + 1 ) - 1 ) ) <= t_width - t_x + t_start
          )
    loop
      t_cnt := t_cnt + 1;
    end loop;
    if t_cnt > 0 then
    -- There is at least one word
      t_ind := instr( p_txt, ' ', 1, t_cnt );
    -- Call write recursvely for begin part
      write( substr( p_txt, 1, t_ind - 1 ), t_x, t_y, t_line_height, t_start, t_width, p_alignment, k_um );
      t_y := chkNewPage(t_y,t_line_height);
    -- Call write recursvely for remain part
      if t_alignment='J' then
        if str_len(substr( p_txt, t_ind + 1 )) <= t_width then
          write( substr( p_txt, t_ind + 1 ), t_start, t_y, t_line_height, t_start, t_width, 'L', k_um );
        else
          write( substr( p_txt, t_ind + 1 ), t_start, t_y, t_line_height, t_start, t_width, p_alignment, k_um );
        end if;
      else
        write( substr( p_txt, t_ind + 1 ), t_start, t_y, t_line_height, t_start, t_width, p_alignment, k_um );
      end if;
      return;
    end if;

    -- Words do not come in the useful space, I'm going to head
    if t_x > t_start and t_len < t_width then
      t_y := chkNewPage(t_y, t_line_height);
    -- Call recursively write for the new line
      write( p_txt, t_start, t_y, t_line_height, t_start, t_width, p_alignment, k_um );
    else
      if length( p_txt ) = 1 then
      -- Only one char
        if t_x > t_start then
          t_y := chkNewPage(t_y, t_line_height);
        end if;
        write( p_txt, t_x, t_y, t_line_height, t_start, t_len, null, k_um );
      else
        t_ind := 2; -- start with 2 to make sure we get smaller string!
        while str_len( substr( p_txt, 1, t_ind ) ) <= t_width - t_x + t_start
        loop
          t_ind := t_ind + 1;
        end loop;
        write( substr( p_txt, 1, t_ind - 1 ), t_x, t_y, t_line_height, t_start, t_width, p_alignment, k_um );
        t_y := chkNewPage(t_y, t_line_height);
        write( substr( p_txt, t_ind ), t_start, t_y, t_line_height, t_start, t_width, p_alignment, k_um );
      end if;
    end if;
  end;

--
  function load_ttf_font
    ( p_font blob
    , p_encoding varchar2 := 'WINDOWS-1252'
    , p_embed boolean := false
    , p_compress boolean := true
    , p_offset number := 1
    )
  return pls_integer
  is
    this_font tp_font;
    type tp_font_table is record
      ( offset pls_integer
      , length pls_integer
      );
    type tp_tables is table of tp_font_table index by varchar2(4);
    t_tables tp_tables;
    t_tag varchar2(4);
    t_blob blob;
    t_offset pls_integer;
    nr_hmetrics pls_integer;
    subtype tp_glyphname is varchar2(500);
    type tp_glyphnames is table of tp_glyphname index by pls_integer;
    t_glyphnames tp_glyphnames;
    t_glyph2name tp_pls_tab;
    t_font_ind pls_integer;
  begin
    if dbms_lob.substr( p_font, 4, p_offset ) != hextoraw( '00010000' ) --  OpenType Font
    then
      return null;
    end if;
    for i in 1 .. blob2num( p_font, 2, p_offset + 4 )
    loop
      t_tag :=
        utl_raw.cast_to_varchar2( dbms_lob.substr( p_font, 4, p_offset - 4 + i * 16 ) );
      t_tables( t_tag ).offset := blob2num( p_font, 4, p_offset + 4 + i * 16 ) + 1;
      t_tables( t_tag ).length := blob2num( p_font, 4, p_offset + 8 + i * 16 );
    end loop;
--
    if (  not t_tables.exists( 'cmap' )
       or not t_tables.exists( 'glyf' )
       or not t_tables.exists( 'head' )
       or not t_tables.exists( 'hhea' )
       or not t_tables.exists( 'hmtx' )
       or not t_tables.exists( 'loca' )
       or not t_tables.exists( 'maxp' )
       or not t_tables.exists( 'name' )
       or not t_tables.exists( 'post' )
       )
    then
      return null;
    end if;
--
    dbms_lob.createtemporary( t_blob, true );
    dbms_lob.copy( t_blob, p_font, t_tables( 'maxp' ).length, 1, t_tables( 'maxp' ).offset );
    this_font.numGlyphs := blob2num( t_blob, 2, 5 );
--
    dbms_lob.copy( t_blob, p_font, t_tables( 'cmap' ).length, 1, t_tables( 'cmap' ).offset );
    for i in 0 .. blob2num( t_blob, 2, 3 ) - 1
    loop
      if (   dbms_lob.substr( t_blob, 2, 5 + i * 8 ) = hextoraw( '0003' ) -- Windows
         and dbms_lob.substr( t_blob, 2, 5 + i * 8 + 2 )
               in ( hextoraw( '0000' ) -- Symbol
                  , hextoraw( '0001' ) -- Unicode BMP (UCS-2)
                  )
         )
      then
        if dbms_lob.substr( t_blob, 2, 5 + i * 8 + 2 ) = hextoraw( '0000' ) -- Symbol
        then
          this_font.flags := 4; -- symbolic
        else
          this_font.flags := 32; -- non-symbolic
        end if;
        t_offset := blob2num( t_blob, 4, 5 + i * 8 + 4 ) + 1;
        if dbms_lob.substr( t_blob, 2, t_offset ) != hextoraw( '0004' )
        then
          return null;
        end if;
        declare
          t_seg_cnt pls_integer;
          t_end_offs pls_integer;
          t_start_offs pls_integer;
          t_idDelta_offs pls_integer;
          t_idRangeOffset_offs pls_integer;
          t_tmp pls_integer;
          t_start pls_integer;
        begin
          t_seg_cnt := blob2num( t_blob, 2, t_offset + 6 ) / 2;
          t_end_offs := t_offset + 14;
          t_start_offs := t_end_offs + t_seg_cnt * 2 + 2;
          t_idDelta_offs := t_start_offs + t_seg_cnt * 2;
          t_idRangeOffset_offs := t_idDelta_offs + t_seg_cnt * 2;
          for seg in 0 .. t_seg_cnt - 1
          loop
            t_tmp := blob2num( t_blob, 2, t_idRangeOffset_offs + seg * 2 );
            if t_tmp = 0
            then
              t_tmp := blob2num( t_blob, 2, t_idDelta_offs + seg * 2 );
              for c in blob2num( t_blob, 2, t_start_offs + seg * 2 )
                    .. blob2num( t_blob, 2, t_end_offs + seg * 2 )
              loop
                this_font.code2glyph( c ) := mod( c + t_tmp, 65536 );
              end loop;
            else
              t_start := blob2num( t_blob, 2, t_start_offs + seg * 2 );
              for c in t_start .. blob2num( t_blob, 2, t_end_offs + seg * 2 )
              loop
                this_font.code2glyph( c ) := blob2num( t_blob, 2, t_idRangeOffset_offs + t_tmp + ( seg + c - t_start ) * 2 );
              end loop;
            end if;
          end loop;
        end;
        exit;
      end if;
    end loop;
--
    t_glyphnames( 0 ) := '.notdef';
    t_glyphnames( 1 ) := '.null';
    t_glyphnames( 2 ) := 'nonmarkingreturn';
    t_glyphnames( 3 ) := 'space';
    t_glyphnames( 4 ) := 'exclam';
    t_glyphnames( 5 ) := 'quotedbl';
    t_glyphnames( 6 ) := 'numbersign';
    t_glyphnames( 7 ) := 'dollar';
    t_glyphnames( 8 ) := 'percent';
    t_glyphnames( 9 ) := 'ampersand';
    t_glyphnames( 10 ) := 'quotesingle';
    t_glyphnames( 11 ) := 'parenleft';
    t_glyphnames( 12 ) := 'parenright';
    t_glyphnames( 13 ) := 'asterisk';
    t_glyphnames( 14 ) := 'plus';
    t_glyphnames( 15 ) := 'comma';
    t_glyphnames( 16 ) := 'hyphen';
    t_glyphnames( 17 ) := 'period';
    t_glyphnames( 18 ) := 'slash';
    t_glyphnames( 19 ) := 'zero';
    t_glyphnames( 20 ) := 'one';
    t_glyphnames( 21 ) := 'two';
    t_glyphnames( 22 ) := 'three';
    t_glyphnames( 23 ) := 'four';
    t_glyphnames( 24 ) := 'five';
    t_glyphnames( 25 ) := 'six';
    t_glyphnames( 26 ) := 'seven';
    t_glyphnames( 27 ) := 'eight';
    t_glyphnames( 28 ) := 'nine';
    t_glyphnames( 29 ) := 'colon';
    t_glyphnames( 30 ) := 'semicolon';
    t_glyphnames( 31 ) := 'less';
    t_glyphnames( 32 ) := 'equal';
    t_glyphnames( 33 ) := 'greater';
    t_glyphnames( 34 ) := 'question';
    t_glyphnames( 35 ) := 'at';
    t_glyphnames( 36 ) := 'A';
    t_glyphnames( 37 ) := 'B';
    t_glyphnames( 38 ) := 'C';
    t_glyphnames( 39 ) := 'D';
    t_glyphnames( 40 ) := 'E';
    t_glyphnames( 41 ) := 'F';
    t_glyphnames( 42 ) := 'G';
    t_glyphnames( 43 ) := 'H';
    t_glyphnames( 44 ) := 'I';
    t_glyphnames( 45 ) := 'J';
    t_glyphnames( 46 ) := 'K';
    t_glyphnames( 47 ) := 'L';
    t_glyphnames( 48 ) := 'M';
    t_glyphnames( 49 ) := 'N';
    t_glyphnames( 50 ) := 'O';
    t_glyphnames( 51 ) := 'P';
    t_glyphnames( 52 ) := 'Q';
    t_glyphnames( 53 ) := 'R';
    t_glyphnames( 54 ) := 'S';
    t_glyphnames( 55 ) := 'T';
    t_glyphnames( 56 ) := 'U';
    t_glyphnames( 57 ) := 'V';
    t_glyphnames( 58 ) := 'W';
    t_glyphnames( 59 ) := 'X';
    t_glyphnames( 60 ) := 'Y';
    t_glyphnames( 61 ) := 'Z';
    t_glyphnames( 62 ) := 'bracketleft';
    t_glyphnames( 63 ) := 'backslash';
    t_glyphnames( 64 ) := 'bracketright';
    t_glyphnames( 65 ) := 'asciicircum';
    t_glyphnames( 66 ) := 'underscore';
    t_glyphnames( 67 ) := 'grave';
    t_glyphnames( 68 ) := 'a';
    t_glyphnames( 69 ) := 'b';
    t_glyphnames( 70 ) := 'c';
    t_glyphnames( 71 ) := 'd';
    t_glyphnames( 72 ) := 'e';
    t_glyphnames( 73 ) := 'f';
    t_glyphnames( 74 ) := 'g';
    t_glyphnames( 75 ) := 'h';
    t_glyphnames( 76 ) := 'i';
    t_glyphnames( 77 ) := 'j';
    t_glyphnames( 78 ) := 'k';
    t_glyphnames( 79 ) := 'l';
    t_glyphnames( 80 ) := 'm';
    t_glyphnames( 81 ) := 'n';
    t_glyphnames( 82 ) := 'o';
    t_glyphnames( 83 ) := 'p';
    t_glyphnames( 84 ) := 'q';
    t_glyphnames( 85 ) := 'r';
    t_glyphnames( 86 ) := 's';
    t_glyphnames( 87 ) := 't';
    t_glyphnames( 88 ) := 'u';
    t_glyphnames( 89 ) := 'v';
    t_glyphnames( 90 ) := 'w';
    t_glyphnames( 91 ) := 'x';
    t_glyphnames( 92 ) := 'y';
    t_glyphnames( 93 ) := 'z';
    t_glyphnames( 94 ) := 'braceleft';
    t_glyphnames( 95 ) := 'bar';
    t_glyphnames( 96 ) := 'braceright';
    t_glyphnames( 97 ) := 'asciitilde';
    t_glyphnames( 98 ) := 'Adieresis';
    t_glyphnames( 99 ) := 'Aring';
    t_glyphnames( 100 ) := 'Ccedilla';
    t_glyphnames( 101 ) := 'Eacute';
    t_glyphnames( 102 ) := 'Ntilde';
    t_glyphnames( 103 ) := 'Odieresis';
    t_glyphnames( 104 ) := 'Udieresis';
    t_glyphnames( 105 ) := 'aacute';
    t_glyphnames( 106 ) := 'agrave';
    t_glyphnames( 107 ) := 'acircumflex';
    t_glyphnames( 108 ) := 'adieresis';
    t_glyphnames( 109 ) := 'atilde';
    t_glyphnames( 110 ) := 'aring';
    t_glyphnames( 111 ) := 'ccedilla';
    t_glyphnames( 112 ) := 'eacute';
    t_glyphnames( 113 ) := 'egrave';
    t_glyphnames( 114 ) := 'ecircumflex';
    t_glyphnames( 115 ) := 'edieresis';
    t_glyphnames( 116 ) := 'iacute';
    t_glyphnames( 117 ) := 'igrave';
    t_glyphnames( 118 ) := 'icircumflex';
    t_glyphnames( 119 ) := 'idieresis';
    t_glyphnames( 120 ) := 'ntilde';
    t_glyphnames( 121 ) := 'oacute';
    t_glyphnames( 122 ) := 'ograve';
    t_glyphnames( 123 ) := 'ocircumflex';
    t_glyphnames( 124 ) := 'odieresis';
    t_glyphnames( 125 ) := 'otilde';
    t_glyphnames( 126 ) := 'uacute';
    t_glyphnames( 127 ) := 'ugrave';
    t_glyphnames( 128 ) := 'ucircumflex';
    t_glyphnames( 129 ) := 'udieresis';
    t_glyphnames( 130 ) := 'dagger';
    t_glyphnames( 131 ) := 'degree';
    t_glyphnames( 132 ) := 'cent';
    t_glyphnames( 133 ) := 'sterling';
    t_glyphnames( 134 ) := 'section';
    t_glyphnames( 135 ) := 'bullet';
    t_glyphnames( 136 ) := 'paragraph';
    t_glyphnames( 137 ) := 'germandbls';
    t_glyphnames( 138 ) := 'registered';
    t_glyphnames( 139 ) := 'copyright';
    t_glyphnames( 140 ) := 'trademark';
    t_glyphnames( 141 ) := 'acute';
    t_glyphnames( 142 ) := 'dieresis';
    t_glyphnames( 143 ) := 'notequal';
    t_glyphnames( 144 ) := 'AE';
    t_glyphnames( 145 ) := 'Oslash';
    t_glyphnames( 146 ) := 'infinity';
    t_glyphnames( 147 ) := 'plusminus';
    t_glyphnames( 148 ) := 'lessequal';
    t_glyphnames( 149 ) := 'greaterequal';
    t_glyphnames( 150 ) := 'yen';
    t_glyphnames( 151 ) := 'mu';
    t_glyphnames( 152 ) := 'partialdiff';
    t_glyphnames( 153 ) := 'summation';
    t_glyphnames( 154 ) := 'product';
    t_glyphnames( 155 ) := 'pi';
    t_glyphnames( 156 ) := 'integral';
    t_glyphnames( 157 ) := 'ordfeminine';
    t_glyphnames( 158 ) := 'ordmasculine';
    t_glyphnames( 159 ) := 'Omega';
    t_glyphnames( 160 ) := 'ae';
    t_glyphnames( 161 ) := 'oslash';
    t_glyphnames( 162 ) := 'questiondown';
    t_glyphnames( 163 ) := 'exclamdown';
    t_glyphnames( 164 ) := 'logicalnot';
    t_glyphnames( 165 ) := 'radical';
    t_glyphnames( 166 ) := 'florin';
    t_glyphnames( 167 ) := 'approxequal';
    t_glyphnames( 168 ) := 'Delta';
    t_glyphnames( 169 ) := 'guillemotleft';
    t_glyphnames( 170 ) := 'guillemotright';
    t_glyphnames( 171 ) := 'ellipsis';
    t_glyphnames( 172 ) := 'nonbreakingspace';
    t_glyphnames( 173 ) := 'Agrave';
    t_glyphnames( 174 ) := 'Atilde';
    t_glyphnames( 175 ) := 'Otilde';
    t_glyphnames( 176 ) := 'OE';
    t_glyphnames( 177 ) := 'oe';
    t_glyphnames( 178 ) := 'endash';
    t_glyphnames( 179 ) := 'emdash';
    t_glyphnames( 180 ) := 'quotedblleft';
    t_glyphnames( 181 ) := 'quotedblright';
    t_glyphnames( 182 ) := 'quoteleft';
    t_glyphnames( 183 ) := 'quoteright';
    t_glyphnames( 184 ) := 'divide';
    t_glyphnames( 185 ) := 'lozenge';
    t_glyphnames( 186 ) := 'ydieresis';
    t_glyphnames( 187 ) := 'Ydieresis';
    t_glyphnames( 188 ) := 'fraction';
    t_glyphnames( 189 ) := 'currency';
    t_glyphnames( 190 ) := 'guilsinglleft';
    t_glyphnames( 191 ) := 'guilsinglright';
    t_glyphnames( 192 ) := 'fi';
    t_glyphnames( 193 ) := 'fl';
    t_glyphnames( 194 ) := 'daggerdbl';
    t_glyphnames( 195 ) := 'periodcentered';
    t_glyphnames( 196 ) := 'quotesinglbase';
    t_glyphnames( 197 ) := 'quotedblbase';
    t_glyphnames( 198 ) := 'perthousand';
    t_glyphnames( 199 ) := 'Acircumflex';
    t_glyphnames( 200 ) := 'Ecircumflex';
    t_glyphnames( 201 ) := 'Aacute';
    t_glyphnames( 202 ) := 'Edieresis';
    t_glyphnames( 203 ) := 'Egrave';
    t_glyphnames( 204 ) := 'Iacute';
    t_glyphnames( 205 ) := 'Icircumflex';
    t_glyphnames( 206 ) := 'Idieresis';
    t_glyphnames( 207 ) := 'Igrave';
    t_glyphnames( 208 ) := 'Oacute';
    t_glyphnames( 209 ) := 'Ocircumflex';
    t_glyphnames( 210 ) := 'apple';
    t_glyphnames( 211 ) := 'Ograve';
    t_glyphnames( 212 ) := 'Uacute';
    t_glyphnames( 213 ) := 'Ucircumflex';
    t_glyphnames( 214 ) := 'Ugrave';
    t_glyphnames( 215 ) := 'dotlessi';
    t_glyphnames( 216 ) := 'circumflex';
    t_glyphnames( 217 ) := 'tilde';
    t_glyphnames( 218 ) := 'macron';
    t_glyphnames( 219 ) := 'breve';
    t_glyphnames( 220 ) := 'dotaccent';
    t_glyphnames( 221 ) := 'ring';
    t_glyphnames( 222 ) := 'cedilla';
    t_glyphnames( 223 ) := 'hungarumlaut';
    t_glyphnames( 224 ) := 'ogonek';
    t_glyphnames( 225 ) := 'caron';
    t_glyphnames( 226 ) := 'Lslash';
    t_glyphnames( 227 ) := 'lslash';
    t_glyphnames( 228 ) := 'Scaron';
    t_glyphnames( 229 ) := 'scaron';
    t_glyphnames( 230 ) := 'Zcaron';
    t_glyphnames( 231 ) := 'zcaron';
    t_glyphnames( 232 ) := 'brokenbar';
    t_glyphnames( 233 ) := 'Eth';
    t_glyphnames( 234 ) := 'eth';
    t_glyphnames( 235 ) := 'Yacute';
    t_glyphnames( 236 ) := 'yacute';
    t_glyphnames( 237 ) := 'Thorn';
    t_glyphnames( 238 ) := 'thorn';
    t_glyphnames( 239 ) := 'minus';
    t_glyphnames( 240 ) := 'multiply';
    t_glyphnames( 241 ) := 'onesuperior';
    t_glyphnames( 242 ) := 'twosuperior';
    t_glyphnames( 243 ) := 'threesuperior';
    t_glyphnames( 244 ) := 'onehalf';
    t_glyphnames( 245 ) := 'onequarter';
    t_glyphnames( 246 ) := 'threequarters';
    t_glyphnames( 247 ) := 'franc';
    t_glyphnames( 248 ) := 'Gbreve';
    t_glyphnames( 249 ) := 'gbreve';
    t_glyphnames( 250 ) := 'Idotaccent';
    t_glyphnames( 251 ) := 'Scedilla';
    t_glyphnames( 252 ) := 'scedilla';
    t_glyphnames( 253 ) := 'Cacute';
    t_glyphnames( 254 ) := 'cacute';
    t_glyphnames( 255 ) := 'Ccaron';
    t_glyphnames( 256 ) := 'ccaron';
    t_glyphnames( 257 ) := 'dcroat';
--
    dbms_lob.copy( t_blob, p_font, t_tables( 'post' ).length, 1, t_tables( 'post' ).offset );
    this_font.italic_angle := to_short( dbms_lob.substr( t_blob, 2, 5 ) )
                            + to_short( dbms_lob.substr( t_blob, 2, 7 ) ) / 65536;
    case rawtohex( dbms_lob.substr( t_blob, 4, 1 ) )
      when '00010000'
      then
        for g in 0 .. 257
        loop
          t_glyph2name( g ) := g;
        end loop;
      when '00020000'
      then
        t_offset := blob2num( t_blob, 2, 33 ) * 2 + 35;
        while nvl( blob2num( t_blob, 1, t_offset ), 0 ) > 0
        loop
          t_glyphnames( t_glyphnames.count ) := utl_raw.cast_to_varchar2( dbms_lob.substr( t_blob, blob2num( t_blob, 1, t_offset ), t_offset + 1 ) );
          t_offset := t_offset + blob2num( t_blob, 1, t_offset ) + 1;
        end loop;
        for g in 0 .. blob2num( t_blob, 2, 33 ) - 1
        loop
          t_glyph2name( g ) := blob2num( t_blob, 2, 35 + 2 * g );
        end loop;
      when '00025000'
      then
        for g in 0 .. blob2num( t_blob, 2, 33 ) - 1
        loop
          t_offset := blob2num( t_blob, 1, 35 + g );
          if t_offset > 127
          then
            t_glyph2name( g ) := g - t_offset;
          else
            t_glyph2name( g ) := g + t_offset;
          end if;
        end loop;
      when '00030000'
      then
        t_glyphnames.delete;
      else
        log( 'no post ' || dbms_lob.substr( t_blob, 4, 1 ) );
    end case;
--
    dbms_lob.copy( t_blob, p_font, t_tables( 'head' ).length, 1, t_tables( 'head' ).offset );
    if dbms_lob.substr( t_blob, 4, 13 ) = hextoraw( '5F0F3CF5' )  -- magic
    then
      declare
        t_tmp pls_integer := blob2num( t_blob, 2, 45 );
      begin
        if bitand( t_tmp, 1 ) = 1
        then
          this_font.style := 'B';
        end if;
        if bitand( t_tmp, 2 ) = 2
        then
          this_font.style := this_font.style || 'I';
          this_font.flags := this_font.flags + 64;
        end if;
        this_font.style := nvl( this_font.style, 'N' );
        this_font.unit_norm := 1000 / blob2num( t_blob, 2, 19 );
        this_font.bb_xmin := to_short( dbms_lob.substr( t_blob, 2, 37 ), this_font.unit_norm );
        this_font.bb_ymin := to_short( dbms_lob.substr( t_blob, 2, 39 ), this_font.unit_norm );
        this_font.bb_xmax := to_short( dbms_lob.substr( t_blob, 2, 41 ), this_font.unit_norm );
        this_font.bb_ymax := to_short( dbms_lob.substr( t_blob, 2, 43 ), this_font.unit_norm );
        this_font.indexToLocFormat := blob2num( t_blob, 2, 51 ); -- 0 for short offsets, 1 for long
      end;
    end if;
--
    dbms_lob.copy( t_blob, p_font, t_tables( 'hhea' ).length, 1, t_tables( 'hhea' ).offset );
    if dbms_lob.substr( t_blob, 4, 1 ) = hextoraw( '00010000' ) -- version 1.0
    then
      this_font.ascent := to_short( dbms_lob.substr( t_blob, 2, 5 ), this_font.unit_norm );
      this_font.descent := to_short( dbms_lob.substr( t_blob, 2, 7 ), this_font.unit_norm );
      this_font.capheight := this_font.ascent;
      nr_hmetrics := blob2num( t_blob, 2, 35 );
    end if;
--
    dbms_lob.copy( t_blob, p_font, t_tables( 'hmtx' ).length, 1, t_tables( 'hmtx' ).offset );
    for j in 0 .. nr_hmetrics - 1
    loop
      this_font.hmetrics( j ) := blob2num( t_blob, 2, 1 + 4 * j );
    end loop;
--
    dbms_lob.copy( t_blob, p_font, t_tables( 'name' ).length, 1, t_tables( 'name' ).offset );
    if dbms_lob.substr( t_blob, 2, 1 ) = hextoraw( '0000' ) -- format 0
    then
      t_offset := blob2num( t_blob, 2, 5 ) + 1;
      for j in 0 .. blob2num( t_blob, 2, 3 ) - 1
      loop
        if (   dbms_lob.substr( t_blob, 2, 7  + j * 12 ) = hextoraw( '0003' ) -- Windows
           and dbms_lob.substr( t_blob, 2, 11 + j * 12 ) = hextoraw( '0409' ) -- English United States
           )
        then
          case rawtohex( dbms_lob.substr( t_blob, 2, 13 + j * 12 ) )
            when '0001'
            then
              this_font.family := utl_i18n.raw_to_char( dbms_lob.substr( t_blob, blob2num( t_blob, 2, 15 + j * 12 ), t_offset + blob2num( t_blob, 2, 17 + j * 12 ) ), 'AL16UTF16' );
            when '0006'
            then
              this_font.name := utl_i18n.raw_to_char( dbms_lob.substr( t_blob, blob2num( t_blob, 2, 15 + j * 12 ), t_offset + blob2num( t_blob, 2, 17 + j * 12 ) ), 'AL16UTF16' );
            else
              null;
          end case;
        end if;
      end loop;
    end if;
--
    if this_font.italic_angle != 0
    then
      this_font.flags := this_font.flags + 64;
    end if;
    this_font.subtype := 'TrueType';
    this_font.stemv := 50;
    this_font.family := lower( this_font.family );
    this_font.encoding := utl_i18n.map_charset( p_encoding
                                              , utl_i18n.generic_context
                                              , utl_i18n.iana_to_oracle
                                              );
    this_font.encoding := nvl( this_font.encoding, upper( p_encoding ) );
    this_font.charset := sys_context( 'userenv', 'LANGUAGE' );
    this_font.charset := substr( this_font.charset
                               , 1
                               , instr( this_font.charset, '.' )
                               ) || this_font.encoding;
    this_font.cid := upper( p_encoding ) in ( 'CID', 'AL16UTF16', 'UTF', 'UNICODE' );
    this_font.fontname := this_font.name;
    this_font.compress_font := p_compress;
--
    if ( p_embed or this_font.cid ) and t_tables.exists( 'OS/2' )
    then
      dbms_lob.copy( t_blob, p_font, t_tables( 'OS/2' ).length, 1, t_tables( 'OS/2' ).offset );
      if blob2num( t_blob, 2, 9 ) != 2
      then
        this_font.fontfile2 := p_font;
        this_font.ttf_offset := p_offset;
        this_font.name := dbms_random.string( 'u', 6 ) || '+' || this_font.name;
--
        t_blob := dbms_lob.substr( p_font, t_tables( 'loca' ).length, t_tables( 'loca' ).offset );
        declare
          t_size pls_integer := 2 + this_font.indexToLocFormat * 2; -- 0 for short offsets, 1 for long
        begin
          for i in 0 .. this_font.numGlyphs
          loop
            this_font.loca( i ) := blob2num( t_blob, t_size, 1 + i * t_size );
          end loop;
        end;
      end if;
    end if;
--
    if not this_font.cid
    then
      if this_font.flags = 4 -- a symbolic font
      then
        declare
          t_real pls_integer;
        begin
          for t_code in 32 .. 255
          loop
            t_real := this_font.code2glyph.first + t_code - 32; -- assume code 32, space maps to the first code from the font
            if this_font.code2glyph.exists( t_real )
            then
              this_font.first_char := least( nvl( this_font.first_char, 255 ), t_code );
              this_font.last_char := t_code;
              if this_font.hmetrics.exists( this_font.code2glyph( t_real ) )
              then
                this_font.char_width_tab( t_code ) := trunc( this_font.hmetrics( this_font.code2glyph( t_real ) ) * this_font.unit_norm );
              else
                this_font.char_width_tab( t_code ) := trunc( this_font.hmetrics( this_font.hmetrics.last() ) * this_font.unit_norm );
              end if;
            else
              this_font.char_width_tab( t_code ) := trunc( this_font.hmetrics( 0 ) * this_font.unit_norm );
            end if;
          end loop;
        end;
      else
        declare
          t_unicode pls_integer;
          t_prv_diff pls_integer;
          t_utf16_charset varchar2(1000);
          t_winansi_charset varchar2(1000);
          t_glyphname tp_glyphname;
        begin
          t_prv_diff := -1;
          t_utf16_charset := substr( this_font.charset, 1, instr( this_font.charset, '.' ) ) || 'AL16UTF16';
          t_winansi_charset := substr( this_font.charset, 1, instr( this_font.charset, '.' ) ) || 'WE8MSWIN1252';
          for t_code in 32 .. 255
          loop
            t_unicode := utl_raw.cast_to_binary_integer( utl_raw.convert( hextoraw( to_char( t_code, 'fm0x' ) )
                                                                        , t_utf16_charset
                                                                        , this_font.charset
                                                                        )
                                                       );
            t_glyphname := '';
            this_font.char_width_tab( t_code ) := trunc( this_font.hmetrics( this_font.hmetrics.last() ) * this_font.unit_norm );
            if this_font.code2glyph.exists( t_unicode )
            then
              this_font.first_char := least( nvl( this_font.first_char, 255 ), t_code );
              this_font.last_char := t_code;
              if this_font.hmetrics.exists( this_font.code2glyph( t_unicode ) )
              then
                this_font.char_width_tab( t_code ) := trunc( this_font.hmetrics( this_font.code2glyph( t_unicode ) ) * this_font.unit_norm );
              end if;
              if t_glyph2name.exists( this_font.code2glyph( t_unicode ) )
              then
                if t_glyphnames.exists( t_glyph2name( this_font.code2glyph( t_unicode ) ) )
                then
                  t_glyphname := t_glyphnames( t_glyph2name( this_font.code2glyph( t_unicode ) ) );
                end if;
              end if;
            end if;
--
            if (   t_glyphname is not null
               and t_unicode != utl_raw.cast_to_binary_integer( utl_raw.convert( hextoraw( to_char( t_code, 'fm0x' ) )
                                                                               , t_winansi_charset
                                                                               , this_font.charset
                                                                               )
                                                              )
               )
            then
              this_font.diff := this_font.diff || case when t_prv_diff != t_code - 1 then ' ' || t_code end || ' /' || t_glyphname;
              t_prv_diff := t_code;
            end if;
          end loop;
        end;
        if this_font.diff is not null
        then
          this_font.diff := '/Differences [' || this_font.diff || ']';
        end if;
      end if;
    end if;
--
    t_font_ind := g_fonts.count( ) + 1;
    g_fonts( t_font_ind ) := this_font;
/*
--
dbms_output.put_line( this_font.fontname || ' ' || this_font.family || ' ' || this_font.style
|| ' ' || this_font.flags
|| ' ' || this_font.code2glyph.first
|| ' ' || this_font.code2glyph.prior( this_font.code2glyph.last )
|| ' ' || this_font.code2glyph.last
|| ' nr glyphs: ' || this_font.numGlyphs
 ); */
--
    return t_font_ind;
  end;
--
  procedure load_ttf_font
    ( p_font blob
    , p_encoding varchar2 := 'WINDOWS-1252'
    , p_embed boolean := false
    , p_compress boolean := true
    , p_offset number := 1
    )
  is
    t_tmp pls_integer;
  begin
    t_tmp := load_ttf_font( p_font, p_encoding, p_embed, p_compress );
  end;
--
  function load_ttf_font
    ( p_dir varchar2 := 'MY_FONTS'
    , p_filename varchar2 := 'BAUHS93.TTF'
    , p_encoding varchar2 := 'WINDOWS-1252'
    , p_embed boolean := false
    , p_compress boolean := true
    )
  return pls_integer
  is
  begin
    return load_ttf_font( file2blob( p_dir, p_filename ), p_encoding, p_embed, p_compress );
  end;
--
  procedure load_ttf_font
    ( p_dir varchar2 := 'MY_FONTS'
    , p_filename varchar2 := 'BAUHS93.TTF'
    , p_encoding varchar2 := 'WINDOWS-1252'
    , p_embed boolean := false
    , p_compress boolean := true
    )
  is
  begin
    load_ttf_font( file2blob( p_dir, p_filename ), p_encoding, p_embed, p_compress );
  end;
--
  procedure load_ttc_fonts
    ( p_ttc blob
    , p_encoding varchar2 := 'WINDOWS-1252'
    , p_embed boolean := false
    , p_compress boolean := true
    )
  is
    type tp_font_table is record
      ( offset pls_integer
      , length pls_integer
      );
    type tp_tables is table of tp_font_table index by varchar2(4);
    t_tables tp_tables;
    t_tag varchar2(4);
    t_blob blob;
    t_offset pls_integer;
    t_font_ind pls_integer;
  begin
    if utl_raw.cast_to_varchar2( dbms_lob.substr( p_ttc, 4, 1 ) ) != 'ttcf'
    then
      return;
    end if;
    for f in 0 .. blob2num( p_ttc, 4, 9 ) - 1
    loop
      t_font_ind := load_ttf_font( p_ttc, p_encoding, p_embed, p_compress, blob2num( p_ttc, 4, 13 + f * 4 ) + 1 );
--dbms_output.put_line( t_font_ind || ' ' || g_fonts( t_font_ind ).fontname || ' ' || g_fonts( t_font_ind ).family || ' ' || g_fonts( t_font_ind ).style );
    end loop;
  end;
--
  procedure load_ttc_fonts
    ( p_dir varchar2 := 'MY_FONTS'
    , p_filename varchar2 := 'CAMBRIA.TTC'
    , p_encoding varchar2 := 'WINDOWS-1252'
    , p_embed boolean := false
    , p_compress boolean := true
    )
  is
  begin
    load_ttc_fonts( file2blob( p_dir, p_filename ), p_encoding, p_embed, p_compress );
  end;
--
  function rgb( p_hex_rgb varchar2 )
  return varchar2
  is
  begin
    return to_char_round( nvl( to_number( substr( ltrim( p_hex_rgb, '#' )
                                                , 1, 2 )
                                        , 'xx' ) / 255
                              , 0 )
                         , 5 ) || ' '
        || to_char_round( nvl(   to_number( substr( ltrim( p_hex_rgb, '#' )
                                                , 3, 2 )
                                        , 'xx' ) / 255
                              , 0 )
                         , 5 ) || ' '
        || to_char_round( nvl(   to_number( substr( ltrim( p_hex_rgb, '#' )
                                                , 5, 2 )
                                        , 'xx' ) / 255
                              , 0 )
                         , 5 ) || ' ';
  end;
--
  procedure set_color( p_rgb varchar2 := '000000', p_backgr boolean )
  IS
    v_vBackgr VARCHAR2(2):='rg';
  BEGIN
    CASE
    WHEN p_backgr THEN
      v_vBackgr:='RG';
      g_current_bcolor:=p_rgb;
    ELSE
      v_vBackgr:='rg';
      g_current_fcolor:=p_rgb;
    END CASE;
    txt2page( rgb(p_rgb) || v_vBackgr );
  end;
--
  procedure set_color( p_rgb varchar2 := '000000' )
  is
  begin
    set_color( p_rgb, false );
  end;
--
  procedure set_color
    ( p_red number := 0
    , p_green number := 0
    , p_blue number := 0
    )
  is
  begin
    if (     p_red between 0 and 255
       and p_blue  between 0 and 255
       and p_green between 0 and 255
       )
    then
      set_color(  to_char( p_red, 'fm0x' )
               || to_char( p_green, 'fm0x' )
               || to_char( p_blue, 'fm0x' )
               , false
               );
    end if;
  end;
--
  procedure set_bk_color( p_rgb varchar2 := 'ffffff' )
  is
  begin
    set_color( p_rgb, true );
  end;
--
  procedure set_bk_color
    ( p_red number := 0
    , p_green number := 0
    , p_blue number := 0
    )
  is
  begin
    if (     p_red between 0 and 255
       and p_blue  between 0 and 255
       and p_green between 0 and 255
       )
    then
      set_color(  to_char( p_red, 'fm0x' )
               || to_char( p_green, 'fm0x' )
               || to_char( p_blue, 'fm0x' )
               , true
               );
    end if;
  end;
--
  procedure horizontal_line
    ( p_x number
    , p_y number
    , p_width number
    , p_line_width number := 0.5
    , p_line_color varchar2 := '000000'
    )
  is
    t_use_color boolean;
  begin
    txt2page( 'q ' || to_char_round( p_line_width, 5 ) || ' w' );
    t_use_color := substr( p_line_color
                         , -6
                         ) != '000000';
    if t_use_color
    then
      set_color( p_line_color );
      set_bk_color( p_line_color );
    else
      txt2page( '0 g' );
    end if;
    txt2page(  to_char_round( p_x, 5 ) || ' '
            || to_char_round( p_y, 5 ) || ' m '
            || to_char_round( p_x + p_width, 5 ) || ' '
            || to_char_round( p_y, 5 ) || ' l b'
            );
    txt2page( 'Q' );
    log(replace(replace(
          'hline('||
          to_char_round(p_x, 5) ||'; '||
          to_char_round(p_y, 5) ||'; '||
          to_char_round(p_width, 5) ||'; '||
          to_char(p_line_width) || '; '||
          p_line_color ||')',
          ',','.'),
          ';',',')|| ';'
       , true);

  end;
  procedure horizontal_line
    ( p_x varchar2
    , p_y varchar2
    , p_width varchar2
    , p_line_width varchar2 := '0.5pt'
    , p_line_color varchar2 := '000000'
    )
  is
  begin
    horizontal_line(get_ParamPT(p_x), get_ParamPT(p_y), get_ParamPT(p_width), get_ParamPT(p_line_width), p_line_color);
  end;
--
  procedure vertical_line
    ( p_x number
    , p_y number
    , p_height number
    , p_line_width number := 0.5
    , p_line_color varchar2 := '000000'
    )
  is
    t_use_color boolean;
  begin
    txt2page( 'q ' || to_char_round( p_line_width, 5 ) || ' w' );
    t_use_color := substr( p_line_color
                         , -6
                         ) != '000000';
    if t_use_color
    then
      set_color( p_line_color );
      set_bk_color( p_line_color );
    else
      txt2page( '0 g' );
    end if;
    txt2page(  to_char_round( p_x, 5 ) || ' '
            || to_char_round( p_y, 5 ) || ' m '
            || to_char_round( p_x, 5 ) || ' '
            || to_char_round( p_y + p_height, 5 ) || ' l b'
            );
    txt2page( 'Q' );
    log(replace(replace(
          'vline('||
          to_char_round(p_x, 5) ||'; '||
          to_char_round(p_y, 5) ||'; '||
          to_char_round(p_height, 5) ||'; '||
          to_char(p_line_width) || '; '||
          p_line_color ||')',
          ',','.'),
          ';',',')|| ';'
       , true);

  end;
  procedure vertical_line
    ( p_x varchar2
    , p_y varchar2
    , p_height varchar2
    , p_line_width varchar2 := '0.5pt'
    , p_line_color varchar2 := '000000'
    )
  is
  begin
    vertical_line(get_ParamPT(p_x), get_ParamPT(p_y), get_ParamPT(p_height), get_ParamPT(p_line_width), p_line_color);
  end;
-- Print Rectangle: coordinates are in pt
  procedure rect
    ( p_x number
    , p_y number
    , p_width number
    , p_height number
    , p_line_color varchar2 := null
    , p_fill_color varchar2 := null
    , p_line_width number := 0.5
    )
  is
  begin
    txt2page( 'q' );
    if substr( p_line_color, -6 ) != substr( p_fill_color, -6 )
    then
      txt2page( to_char_round( p_line_width, 5 ) || ' w' );
    end if;
    if substr( p_line_color, -6 ) != '000000'
    then
      set_bk_color( p_line_color );
    else
      txt2page( '0 g' );
    end if;
    if p_fill_color is not null
    then
      set_color( p_fill_color );
    end if;
    txt2page(  to_char_round(p_x, 5) ||' '||to_char_round(p_y, 5) || ' '
            || to_char_round(p_width, 5) ||' '|| to_char_round(p_height, 5) || ' re '
            || case
                 when p_fill_color is null
                 then 'S'
                 else case when p_line_color is null then 'f' else 'b' end
               end
            );
    txt2page( 'Q' );

    log(replace(replace(
          'rect('||
          to_char_round(p_x, 5) ||'; '||
          to_char_round(p_y, 5) ||'; '||
          to_char_round(p_width, 5) ||'; '||
          to_char_round(p_height, 5) || '; '||
          p_line_color || '; '||
          p_fill_color || '; '||
          case
            when p_fill_color is null
            then 'S'
            else case when p_line_color is null then 'f' else 'b' end
          end || '; '||
          to_char(p_line_width)||')',
          ',','.'),
          ';',',')|| ';'
       , true);

  end;

  --  Print Rectangle: you can specify um for each coordinate
  --- examples rect('5mm','1.5cm','1in','40pt' .... )
  procedure rect
    ( p_x varchar2
    , p_y varchar2
    , p_width varchar2
    , p_height varchar2
    , p_line_color varchar2 := null
    , p_fill_color varchar2 := null
    , p_line_width varchar2 := '0.5pt'
    )
  is
  begin
    rect(get_ParamPT(p_x), get_ParamPT(p_y), get_ParamPT(p_width), get_ParamPT(p_height), p_line_color, p_fill_color, get_ParamPT(p_line_width));
  end;
--
  function get( p_what pls_integer )
  return number
  is
  begin
    return(
      case p_what
         when c_get_page_width     then g_settings.page_width
         when c_get_page_height    then g_settings.page_height
         when c_get_margin_top     then g_settings.margin_top
         when c_get_margin_right   then g_settings.margin_right
         when c_get_margin_bottom  then g_settings.margin_bottom
         when c_get_margin_left    then g_settings.margin_left
         when c_get_x              then g_x
         when c_get_y              then g_y
         when c_get_fontsize       then g_fonts(g_current_font).fontsize
         when c_get_current_font   then g_current_font
         when c_get_current_fcolor then g_current_fcolor
         when c_get_current_bcolor then g_current_bcolor
         -- added ltl for GetPdf wrapper package 20210717
         when c_get_page_count     then g_pages.count()
       end);
  end;
--
  function parse_jpg( p_img_blob blob )
  return tp_img
  is
    buf raw(4);
    t_img tp_img;
    t_ind integer;
  begin
    if (  dbms_lob.substr( p_img_blob, 2, 1 ) != hextoraw( 'FFD8' )                                      -- SOI Start of Image
       or dbms_lob.substr( p_img_blob, 2, dbms_lob.getlength( p_img_blob ) - 1 ) != hextoraw( 'FFD9' )   -- EOI End of Image
       )
    then  -- this is not a jpg I can handle
      return null;
    end if;
--
    t_img.pixels := p_img_blob;
    t_img.type := 'jpg';
    if dbms_lob.substr( t_img.pixels, 2, 3 ) in ( hextoraw( 'FFE0' )  -- a APP0 jpg
                                                , hextoraw( 'FFE1' )  -- a APP1 jpg
                                                )
    then
      t_img.color_res := 8;
      t_img.height := 1;
      t_img.width := 1;
--
      t_ind := 3;
      t_ind := t_ind + 2 + blob2num( t_img.pixels, 2, t_ind + 2 );
      loop
        buf := dbms_lob.substr( t_img.pixels, 2, t_ind );
        exit when buf = hextoraw( 'FFDA' );  -- SOS Start of Scan
        exit when buf = hextoraw( 'FFD9' );  -- EOI End Of Image
        exit when substr( rawtohex( buf ), 1, 2 ) != 'FF';
        if rawtohex( buf ) in ( 'FFD0'                                                          -- RSTn
                              , 'FFD1', 'FFD2', 'FFD3', 'FFD4', 'FFD5', 'FFD6', 'FFD7', 'FF01'  -- TEM
                              )
        then
          t_ind := t_ind + 2;
        else
          if buf = hextoraw( 'FFC0' )       -- SOF0 (Start Of Frame 0) marker
          then
            t_img.color_res := blob2num( t_img.pixels, 1, t_ind + 4 );
            t_img.height    := blob2num( t_img.pixels, 2, t_ind + 5 );
            t_img.width     := blob2num( t_img.pixels, 2, t_ind + 7 );
          end if;
          t_ind := t_ind + 2 + blob2num( t_img.pixels, 2, t_ind + 2 );
        end if;
      end loop;
    end if;
--
    return t_img;
  end;
--
  function parse_png( p_img_blob blob )
  return tp_img
  is
    t_img tp_img;
    buf raw(32767);
    len integer;
    ind integer;
    color_type pls_integer;
  begin
    if rawtohex( dbms_lob.substr( p_img_blob, 8, 1 ) ) != '89504E470D0A1A0A'  -- not the right signature
    then
      return null;
    end if;
    dbms_lob.createtemporary( t_img.pixels, true );
    ind := 9;
    loop
      len := blob2num( p_img_blob, 4, ind );  -- length
      exit when len is null or ind > dbms_lob.getlength( p_img_blob );
      case utl_raw.cast_to_varchar2( dbms_lob.substr( p_img_blob, 4, ind + 4 ) )  -- Chunk type
        when 'IHDR'
        then
          t_img.width     := blob2num( p_img_blob, 4, ind + 8 );
          t_img.height    := blob2num( p_img_blob, 4, ind + 12 );
          t_img.color_res := blob2num( p_img_blob, 1, ind + 16 );
          color_type      := blob2num( p_img_blob, 1, ind + 17 );
          t_img.greyscale := color_type in ( 0, 4 );
        when 'PLTE'
        then
          t_img.color_tab := dbms_lob.substr( p_img_blob, len, ind + 8 );
        when 'IDAT'
        then
          dbms_lob.copy( t_img.pixels, p_img_blob, len, dbms_lob.getlength( t_img.pixels ) + 1, ind + 8 );
        when 'IEND'
        then
          exit;
        else
          null;
      end case;
      ind := ind + 4 + 4 + len + 4;  -- Length + Chunk type + Chunk data + CRC
    end loop;
--
    t_img.type := 'png';
    t_img.nr_colors := case color_type
                         when 0 then 1
                         when 2 then 3
                         when 3 then 1
                         when 4 then 2
                         else 4
                       end;
--
    return t_img;
  end;
--
  function lzw_decompress
    ( p_blob blob
    , p_bits pls_integer
    )
  return blob
  is
    powers tp_pls_tab;
--
    g_lzw_ind pls_integer;
    g_lzw_bits pls_integer;
    g_lzw_buffer pls_integer;
    g_lzw_bits_used pls_integer;
--
    type tp_lzw_dict is table of raw(1000) index by pls_integer;
    t_lzw_dict tp_lzw_dict;
    t_clr_code pls_integer;
    t_nxt_code pls_integer;
    t_new_code pls_integer;
    t_old_code pls_integer;
    t_blob blob;
--
    function get_lzw_code
    return pls_integer
    is
      t_rv pls_integer;
    begin
      while g_lzw_bits_used < g_lzw_bits
      loop
        g_lzw_ind := g_lzw_ind + 1;
        g_lzw_buffer := blob2num( p_blob, 1, g_lzw_ind ) * powers( g_lzw_bits_used ) + g_lzw_buffer;
        g_lzw_bits_used := g_lzw_bits_used + 8;
      end loop;
      t_rv := bitand( g_lzw_buffer, powers( g_lzw_bits ) - 1 );
      g_lzw_bits_used := g_lzw_bits_used - g_lzw_bits;
      g_lzw_buffer := trunc( g_lzw_buffer / powers( g_lzw_bits ) );
      return t_rv;
    end;
--
  begin
    for i in 0 .. 30
    loop
      powers( i ) := power( 2, i );
    end loop;
--
    t_clr_code := powers( p_bits - 1 );
    t_nxt_code := t_clr_code + 2;
    for i in 0 .. least( t_clr_code - 1, 255 )
    loop
      t_lzw_dict( i ) := hextoraw( to_char( i, 'fm0X' ) );
    end loop;
    dbms_lob.createtemporary( t_blob, true );
    g_lzw_ind := 0;
    g_lzw_bits := p_bits;
    g_lzw_buffer := 0;
    g_lzw_bits_used := 0;
--
    t_old_code := null;
    t_new_code := get_lzw_code( );
    loop
      case nvl( t_new_code, t_clr_code + 1 )
        when t_clr_code + 1
        then
          exit;
        when t_clr_code
        then
          t_new_code := null;
          g_lzw_bits := p_bits;
          t_nxt_code := t_clr_code + 2;
        else
          if t_new_code = t_nxt_code
          then
            t_lzw_dict( t_nxt_code ) :=
              utl_raw.concat( t_lzw_dict( t_old_code )
                            , utl_raw.substr( t_lzw_dict( t_old_code ), 1, 1 )
                            );
            dbms_lob.append( t_blob, t_lzw_dict( t_nxt_code ) );
            t_nxt_code := t_nxt_code + 1;
          elsif t_new_code > t_nxt_code
          then
            exit;
          else
            dbms_lob.append( t_blob, t_lzw_dict( t_new_code ) );
            if t_old_code is not null
            then
              t_lzw_dict( t_nxt_code ) := utl_raw.concat( t_lzw_dict( t_old_code )
                                                        , utl_raw.substr( t_lzw_dict( t_new_code ), 1, 1 )
                                                        );
              t_nxt_code := t_nxt_code + 1;
            end if;
          end if;
          if     bitand( t_nxt_code, powers( g_lzw_bits ) - 1 ) = 0
             and g_lzw_bits < 12
          then
            g_lzw_bits := g_lzw_bits + 1;
          end if;
      end case;
      t_old_code := t_new_code;
      t_new_code := get_lzw_code( );
    end loop;
    t_lzw_dict.delete;
--
    return t_blob;
  end;
--
  function parse_gif( p_img_blob blob )
  return tp_img
  is
    img tp_img;
    buf raw(4000);
    ind integer;
    t_len pls_integer;
  begin
    if dbms_lob.substr( p_img_blob, 3, 1 ) != utl_raw.cast_to_raw( 'GIF' )
    then
      return null;
    end if;
    ind := 7;
    buf := dbms_lob.substr( p_img_blob, 7, 7 );  --  Logical Screen Descriptor
    ind := ind + 7;
    img.color_res := raw2num( utl_raw.bit_and( utl_raw.substr( buf, 5, 1 ), hextoraw( '70' ) ) ) / 16 + 1;
    img.color_res := 8;
    if raw2num( buf, 5, 1 ) > 127
    then
      t_len := 3 * power( 2, raw2num( utl_raw.bit_and( utl_raw.substr( buf, 5, 1 ), hextoraw( '07' ) ) ) + 1 );
      img.color_tab := dbms_lob.substr( p_img_blob, t_len, ind  ); -- Global Color Table
      ind := ind + t_len;
    end if;
--
    loop
      case dbms_lob.substr( p_img_blob, 1, ind )
        when hextoraw( '3B' ) -- trailer
        then
          exit;
        when hextoraw( '21' ) -- extension
        then
          if dbms_lob.substr( p_img_blob, 1, ind + 1 ) = hextoraw( 'F9' )
          then -- Graphic Control Extension
            if utl_raw.bit_and( dbms_lob.substr( p_img_blob, 1, ind + 3 ), hextoraw( '01' ) ) = hextoraw( '01' )
            then -- Transparent Color Flag set
              img.transparancy_index := blob2num( p_img_blob, 1, ind + 6 );
            end if;
          end if;
          ind := ind + 2; -- skip sentinel + label
          loop
            t_len := blob2num( p_img_blob, 1, ind ); -- Block Size
            exit when t_len = 0;
            ind := ind + 1 + t_len; -- skip Block Size + Data Sub-block
          end loop;
          ind := ind + 1;           -- skip last Block Size
        when hextoraw( '2C' )       -- image
        then
          declare
            img_blob blob;
            min_code_size pls_integer;
            code_size pls_integer;
            flags raw(1);
          begin
            img.width := utl_raw.cast_to_binary_integer( dbms_lob.substr( p_img_blob, 2, ind + 5 )
                                                       , utl_raw.little_endian
                                                       );
            img.height := utl_raw.cast_to_binary_integer( dbms_lob.substr( p_img_blob, 2, ind + 7 )
                                                        , utl_raw.little_endian
                                                        );
            img.greyscale := false;
            ind := ind + 1 + 8;                   -- skip sentinel + img sizes
            flags := dbms_lob.substr( p_img_blob, 1, ind );
            if utl_raw.bit_and( flags, hextoraw( '80' ) ) = hextoraw( '80' )
            then
              t_len := 3 * power( 2, raw2num( utl_raw.bit_and( flags, hextoraw( '07' ) ) ) + 1 );
              img.color_tab := dbms_lob.substr( p_img_blob, t_len, ind + 1 );          -- Local Color Table
            end if;
            ind := ind + 1;                                -- skip image Flags
            min_code_size := blob2num( p_img_blob, 1, ind );
            ind := ind + 1;                      -- skip LZW Minimum Code Size
            dbms_lob.createtemporary( img_blob, true );
            loop
              t_len := blob2num( p_img_blob, 1, ind ); -- Block Size
              exit when t_len = 0;
              dbms_lob.append( img_blob, dbms_lob.substr( p_img_blob, t_len, ind + 1 ) ); -- Data Sub-block
              ind := ind + 1 + t_len;      -- skip Block Size + Data Sub-block
            end loop;
            ind := ind + 1;                            -- skip last Block Size
            img.pixels := lzw_decompress( img_blob, min_code_size + 1 );
--
            if utl_raw.bit_and( flags, hextoraw( '40' ) ) = hextoraw( '40' )
            then                                        --  interlaced
              declare
                pass pls_integer;
                pass_ind tp_pls_tab;
              begin
                dbms_lob.createtemporary( img_blob, true );
                pass_ind( 1 ) := 1;
                pass_ind( 2 ) := trunc( ( img.height - 1 ) / 8 ) + 1;
                pass_ind( 3 ) := pass_ind( 2 ) + trunc( ( img.height + 3 ) / 8 );
                pass_ind( 4 ) := pass_ind( 3 ) + trunc( ( img.height + 1 ) / 4 );
                pass_ind( 2 ) := pass_ind( 2 ) * img.width + 1;
                pass_ind( 3 ) := pass_ind( 3 ) * img.width + 1;
                pass_ind( 4 ) := pass_ind( 4 ) * img.width + 1;
                for i in 0 .. img.height - 1
                loop
                  pass := case mod( i, 8 )
                            when 0 then 1
                            when 4 then 2
                            when 2 then 3
                            when 6 then 3
                            else 4
                          end;
                  dbms_lob.append( img_blob, dbms_lob.substr( img.pixels, img.width, pass_ind( pass ) ) );
                  pass_ind( pass ) := pass_ind( pass ) + img.width;
                end loop;
                img.pixels := img_blob;
              end;
            end if;
--
            dbms_lob.freetemporary( img_blob );
          end;
        else
          exit;
      end case;
    end loop;
--
    img.type := 'gif';
    return img;
  end;
--
  function parse_img
    ( p_blob in blob
    , p_adler32 in varchar2 := null
    , p_type in varchar2 := null
    )
  return tp_img
  is
    t_img tp_img;
  begin
    t_img.type := p_type;
    if t_img.type is null
    then
      if rawtohex( dbms_lob.substr( p_blob, 8, 1 ) ) = '89504E470D0A1A0A'
      then
        t_img.type := 'png';
      elsif dbms_lob.substr( p_blob , 3, 1 ) = utl_raw.cast_to_raw( 'GIF' )
      then
        t_img.type := 'gif';
      else
        t_img.type := 'jpg';
      end if;
    end if;
--
    t_img := case lower( t_img.type )
               when 'gif' then parse_gif( p_blob )
               when 'png' then parse_png( p_blob )
               when 'jpg' then parse_jpg( p_blob )
               else null
             end;
--
    if t_img.type is not null
    then
      t_img.adler32 := coalesce( p_adler32, adler32( p_blob ) );
    end if;
    return t_img;
  end;
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
  )
  is
    t_x number;
    t_y number;
    t_width  number;
    t_height number;
    t_widthRatio  number;
    t_heightRatio number;
    t_img tp_img;
    t_ind pls_integer;
    t_adler32 varchar2(8) := p_adler32;
  begin
    if p_img is null then
      return;
    end if;
    if t_adler32 is null then
      t_adler32 := adler32( p_img );
    end if;
    t_ind := g_images.first;
    while t_ind is not null
    loop
      exit when g_images( t_ind ).adler32 = t_adler32;
      t_ind := g_images.next( t_ind );
    end loop;
--
    if t_ind is null then
      t_img := parse_img( p_img, t_adler32 );
      if t_img.adler32 is null then
        return;
      end if;
      t_ind := g_images.count( ) + 1;
      g_images( t_ind ) := t_img;
    end if;
--

    t_x := conv2uu(p_x,p_um);
    t_y := conv2uu(p_y,p_um);

    CASE NVL(p_width,0)
      WHEN -1 THEN -- Proportions unchanged uses t_height
        t_width := 0;
        t_widthRatio :=-1;
      WHEN 0  THEN -- Measure unchanged
        t_width := 0;
        t_widthRatio :=g_images( t_ind ).width;
      ELSE    -- Rescale
        t_width:=conv2uu(p_width,p_um);
        t_widthRatio :=least(t_width , g_images(t_ind).width );
    END CASE;
    CASE NVL(p_height,0)
      WHEN -1 THEN -- Proportions unchanged uses t_width
        t_height := 0;
        t_heightRatio :=-1;
      WHEN 0  THEN -- Measure unchanged
        t_height := 0;
        t_heightRatio:=g_images(t_ind).height;
      ELSE    -- Rescale
        t_height := conv2uu(p_height,p_um);
        t_heightRatio:=least(t_height, g_images(t_ind).height);
    END CASE;
    CASE
      WHEN t_widthRatio=-1 AND t_heightRatio=-1 THEN
      -- keep because i can't rescale
        t_widthRatio :=g_images(t_ind).width;
        t_heightRatio:=g_images(t_ind).height;
      WHEN t_widthRatio=-1 THEN
        t_widthRatio := g_images(t_ind).width/g_images(t_ind).height*t_heightRatio;
      ELSE
        t_heightRatio:= g_images(t_ind).height/g_images(t_ind).width*t_widthRatio;
    END CASE;

    t_x :=
      case translate(Upper1(p_align),'LSJRE','LLLRR')
        when 'C' then -- center
          t_x + (coalesce(p_cellWidth, t_width, 0) - t_widthRatio) / 2
        when 'R' then -- Right or End
          t_x +  coalesce(p_cellWidth, t_width, 0) - t_widthRatio
        else          -- Left , Start or Justified
          t_x




      end;
    t_y :=
      case translate(Upper1(p_valign),'CM','CC')
        when 'C' then -- Center or Middle
          t_y - (coalesce(p_cellHeight, t_height, 0) - t_heightRatio) / 2

        when 'B' then -- bottom
          t_y - coalesce(p_cellHeight, t_height, 0) - t_heightRatio
        else          -- Top
          t_y

      end;
    if nvl(p_cellHeight,0)>=0 then
      t_y:=t_y-t_heightRatio;
    end if;

--
    txt2page( 'q '     || to_char_round(t_widthRatio)
            || ' 0 0 ' || to_char_round(t_heightRatio)
            || ' ' || to_char_round( t_x ) || ' ' || to_char_round( t_y )
            || ' cm /I' || to_char( t_ind ) || ' Do Q'
            );
  end;
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
  )
  is
    t_blob blob;
  begin
    t_blob := file2blob( p_dir, p_file_name );
    put_image( t_blob
             , p_x, p_y, p_width, p_height
             , p_align, p_valign, p_um
             , p_cellWidth, p_cellHeight
             , p_adler32
             );
    dbms_lob.freetemporary( t_blob );
  end;
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
    )
  is
    t_blob blob;
  begin
    t_blob := httpuritype( p_url ).getblob( );
    put_image( t_blob
             , p_x, p_y, p_width, p_height
             , p_align, p_valign, p_um
             , p_cellWidth, p_cellHeight
             , p_adler32
             );
    dbms_lob.freetemporary( t_blob );
  end;


  Function BorderType(p_vBorder in varchar2) return number is
    v_nBorder number:=0;
    v_vBorder varchar2(4);
  begin
    v_vBorder:=substr(ltrim(rtrim(upper(p_vBorder))),1,4);
    if instr(v_vBorder, 'T')>0 then
      v_nBorder := v_nBorder + 1;
    end if;
    if instr(v_vBorder, 'B')>0 then
      v_nBorder := v_nBorder + 2;
    end if;
    if instr(v_vBorder, 'L')>0 then
      v_nBorder := v_nBorder + 4;
    end if;
    if instr(v_vBorder, 'R')>0 then
      v_nBorder := v_nBorder + 8;
    end if;
    return v_nBorder;
  end;

--
  procedure set_page_proc( p_src clob )
  is
  begin
    g_page_prcs( g_page_prcs.count ) := p_src;
  end;
  procedure set_page_proc( p_src VARCHAR2 )
  is
  begin
    g_page_prcs( g_page_prcs.count ) := TO_CLOB(p_src);
  end;
--
  procedure cursor2table
    ( p_c          INTEGER
    , p_formats    tp_columns := NULL -- Colums formats
    , p_colors     tp_colors  := NULL
    , p_hRowHeight NUMBER     := NULL -- Header Row height
    , p_tRowHeight NUMBER     := NULL -- Table  Row height (-Min Value, +Exact Value)
    , p_um         VARCHAR2   :='pt'  --
    , p_startX     number     := 0    --
    , p_BreakField number     := 0    --
    , p_Interline  number     := 1.2
    , p_startY     number     := 0    --
    , p_Frame      varchar2   :=null -- Border Around format
    , p_bulk_size  pls_integer:= 200
    )
  is
    t_col_cnt   integer;
    t_col_start integer;

$IF DBMS_DB_VERSION.VER_LE_10 $THEN
    t_desc_tab dbms_sql.desc_tab2;
$ELSE
    t_desc_tab dbms_sql.desc_tab3;
$END
    d_tab dbms_sql.date_table;
    n_tab dbms_sql.number_table;
    v_tab dbms_sql.varchar2_table;
    b_tab dbms_sql.blob_table;
    t_r integer;
    TYPE       tp_integer_tab is table of integer;
    t_chars    tp_integer_tab := tp_integer_tab( 1, 8, 9, 96, 112 );
    t_dates    tp_integer_tab := tp_integer_tab( 12, 178, 179, 180, 181 , 231 );
    t_numerics tp_integer_tab := tp_integer_tab( 2, 100, 101 );
    t_blobs    tp_integer_tab := tp_integer_tab( 113 );

    t_formats  tp_columns;         -- Verified Columns Formats
    t_colors   tp_colors;
    t_hRowHeight    NUMBER;        -- Verified Header Row Height
    t_tRowHeight    NUMBER;        -- Verified Table  Row Height

    t_tmp           number;
    t_n             NUMBER;        -- Temporary numeric variable
    t_x             number;
    t_y             number;
    t_yBegin        number;        -- Start Y position for each page
    t_Frame_y       number;        -- Start Y position for Border Around
    t_Frame_width   number;        -- Width of Border Around
    t_Frame_Line    number;        -- Line width of Border Around frame
    t_Frame_color   varchar2(6);   -- Line color of Border Around frame
    t_txt           varchar2(32767);
    t_blob          blob;
    t_start_x       number;        -- Initial X position (Paper margin + p_StartX)
    t_lineheight    number;        -- row height

    n_oddLine       number(1):=0;  -- 0 o 3
    v_nC_rf         number := 0.2; -- Text distance from bottom border of the cell
    t_Cells         tp_Cells;      -- Array with all cells of one data row

  -- Default
    k_nMargin       CONSTANT NUMBER       := 2;
    k_nLineSize     CONSTANT NUMBER       := .5;
    k_vNumberFormat CONSTANT VARCHAR2(10) := 'TM9';
    k_vDateFormat   CONSTANT VARCHAR2(10) := 'dd.mm.yyyy';
    k_vAlignment    CONSTANT VARCHAR2(1)  := 'L';
    k_vAlignVert    CONSTANT VARCHAR2(1)  := 'M';
    v_Interline     NUMBER:= p_Interline;

  -- Precalculated
    v_hRowHeight    NUMBER:=p_hRowHeight;

    type tp_hcell_table is record
      ( x      number,
        y      number,
        w      number,
        h      number,
        tx     number,
        ty     number,
        testo  varchar2(200)
      );
    type tp_hcells is table of tp_hcell_table index by pls_integer;

    type tp_hrow_table is record
      ( height number
      );
    type tp_hrows  is table of tp_hrow_table index by pls_integer;

  -- HEADER
    t_hcells tp_hcells;
    t_hrows tp_hrows;
    v_nHeaderHeight number;
  -- BREAK
    t_bcells tp_cells;
    t_brows  tp_hrows;
    v_nBreakHeight number;
  -- RECORD
    v_nRecordHeight number;
    t_rrows  tp_hrows;

    w_BlockHeight number; -- Printing Blocok Height

    v_vBreakOld varchar2(1000):='?';
    v_vBreakNew varchar2(1000);

 -- Set font only if it's different from actual
    PROCEDURE setCellFont(p_nIndex        in NUMBER,
                          p_output_to_doc in BOOLEAN DEFAULT TRUE,
                          p_vMode         in varchar2 default 'T') IS
      v_vFontName   VARCHAR2(100);
      v_vFontStyle  VARCHAR2(2);
      v_nFontSize   NUMBER;
    BEGIN
      IF upper1(p_vMode)='T' THEN -- BugFix suggerito da Giuseppe Polo
        v_vFontName:=nvl(t_formats(p_nIndex).tFontName,g_fonts(g_current_font).family) ;
        v_vFontStyle:=upper(substr(nvl(t_formats(p_nIndex).tFontStyle, g_fonts(g_current_font).style),1,1));
        v_nFontSize:=nvl(t_formats(p_nIndex).tFontSize,g_fonts(g_current_font).fontsize);
      ELSE
        v_vFontName:=nvl(t_formats(p_nIndex).hFontName,g_fonts(g_current_font).family) ;
        v_vFontStyle:=upper(substr(nvl(t_formats(p_nIndex).hFontStyle, g_fonts(g_current_font).style),1,1));
        v_nFontSize:=nvl(t_formats(p_nIndex).hFontSize,g_fonts(g_current_font).fontsize);
      END IF;
      -- v_vFontName:=nvl(t_formats(p_nIndex).tFontName,g_fonts(g_current_font).family) ;
      -- v_vFontStyle:=upper(substr(nvl(t_formats(p_nIndex).tFontStyle, g_fonts(g_current_font).style),1,1));
      -- v_nFontSize:=nvl(t_formats(p_nIndex).tFontSize,g_fonts(g_current_font).fontsize);

      IF g_bForce=TRUE OR
         v_vFontName !=g_fonts(g_current_font).family OR
         v_vFontStyle!=g_fonts(g_current_font).style  OR
         v_nFontSize !=g_fonts(g_current_font).fontsize
      THEN
        -- Change font if is not equal to current font
        set_font(v_vFontName,  v_vFontStyle, v_nFontSize, p_output_to_doc);
        Log('set_font('||
            v_vFontName||', '||
            v_vFontStyle||', '||
            v_nFontSize ||', '||
            case when p_output_to_doc then 'True' else 'False' end ||')'
           , true);
      END IF;
    END;

    PROCEDURE setCellColor(p_nIndex IN NUMBER, p_nOdd in pls_integer:=null) IS
      v_vColor VARCHAR2(6);
      v_nOdd   pls_integer;
    BEGIN
    -- Change FontColor if necessary
      v_nOdd:=coalesce(p_nOdd,n_oddLine,0);
      v_vColor:=NVL(t_formats(p_nIndex).tFontColor, t_Colors(4+v_nOdd));
      IF (g_current_fcolor != v_vColor) or g_bForce=TRUE  THEN
        set_color(v_vColor);
      END IF;

    END;

    FUNCTION getValue(c in pls_integer, r in pls_integer,
                      p_vMode in varchar2 default 'TYPE') RETURN Varchar2 is
    begin
      CASE                       -- Add N rows of text, formatted and aligned
        WHEN t_desc_tab(c).col_type member of t_numerics THEN
          n_tab.delete;
          dbms_sql.column_value( p_c, c, n_tab );
          t_txt:=to_char(n_tab(r + n_tab.first() ), t_formats(c).tNumFormat);
          if p_vMode ='TYPE' then
            return 'NUMERIC';
          else
            return t_txt;
          end if;
        WHEN t_desc_tab(c).col_type member of t_dates  THEN
          d_tab.delete;
          dbms_sql.column_value( p_c, c, d_tab );
          t_txt:=to_char(d_tab(r + d_tab.first() ), t_formats(c).tNumFormat);
          if p_vMode ='TYPE' then
            return 'DATE';
          else
            return t_txt;
          end if;
        WHEN t_desc_tab(c).col_type member of t_blobs  THEN
          b_tab.delete;
          dbms_sql.column_value( p_c, c, b_tab );
          t_txt:='#IMAGE#'||t_formats(c).tNumFormat;
          t_blob:=b_tab(r + b_tab.first());

          if p_vMode ='TYPE' then
            return 'CLOB';
          else
            return t_txt;
          end if;
        ELSE
          v_tab.delete;
          dbms_sql.column_value( p_c, c, v_tab );
          t_txt:=v_tab( r + v_tab.first() );
          if p_vMode ='TYPE' then
            return 'TEXT';
          else
            return t_txt;
          end if;
      END CASE;
    end;

 -- Assign default values
    PROCEDURE SetDefaults IS

      PROCEDURE Test_Alignment(p_vAlignment IN OUT VARCHAR2,
                               p_vNVL IN VARCHAR2 DEFAULT NULL) IS
      BEGIN
        p_vAlignment:= upper(nvl(p_vAlignment, p_vNVL));
        IF nvl(p_vAlignment,'X') NOT IN ('X','L','C','R') THEN -- Not valid
          p_vAlignment:=k_vAlignment;
        END IF;
      END;

      PROCEDURE Test_AlignVert(p_vAlignVert IN OUT VARCHAR2,
                               p_vNVL IN VARCHAR2 DEFAULT NULL) IS
      -- Check parameter consistency and assign default if null or invalid
      BEGIN
        p_vAlignVert:= upper(NVL(p_vAlignVert,p_vNVL));
        IF nvl(p_vAlignVert,'X') NOT IN ('X','T','C','B','M') THEN -- Not valid
          p_vAlignVert:=k_vAlignVert;
        END IF;
        IF nvl(p_vAlignVert,'X') ='M' then -- Middle are synonym of Center
          p_vAlignVert:='C';
        end if;
      END;

      Procedure Calc_Interline(p_nI in integer, p_vMode in varchar2) is
        v_vSpacing     VARCHAR2(10);
        v_vInterline   VARCHAR2(10);
        v_nSpacingPT   NUMBER;
        v_nInterlinePT NUMBER;

        v_nFontSize    NUMBER;
      BEGIN
        if upper1(p_vMode)='T' then
          v_vSpacing  :=lower(ltrim(rtrim(t_formats(p_nI).vSpacing)));   -- change for table spacing
          v_vInterline:=lower(ltrim(rtrim(t_formats(p_nI).vInterline))); -- change for table interline
          v_nFontSize :=t_formats(p_nI).tFontSize;
        else
          v_vSpacing  :=lower(ltrim(rtrim(t_formats(p_nI).hSpacing)));   -- change for header spacing
          v_vInterline:=lower(ltrim(rtrim(t_formats(p_nI).hInterline))); -- change for header interline
          v_nFontSize :=t_formats(p_nI).hFontSize;
        end if;


      -- detect spacing value
        CASE
          WHEN substr(v_vSpacing,-2,1) = '%' THEN
            v_nSpacingPT:= v_nFontSize*get_ParamNumber(v_vSpacing)/100;
          WHEN substr(v_vSpacing,-2,1) = 'pt' THEN
            v_nSpacingPT:= get_ParamNumber(v_vSpacing);
          WHEN substr(v_vSpacing,-2,1) = 'mm' THEN
            v_nSpacingPT:= conv2uu(get_ParamNumber(v_vSpacing),'mm');
          ELSE
            v_nSpacingPT:=NULL;
        END CASE;

        CASE
          WHEN substr(v_vInterline,-2,1) = '%' THEN
            v_nInterlinePT:= v_nFontSize*get_ParamNumber(v_vInterline)/100;
          WHEN substr(v_vSpacing,-2,1) = 'pt' THEN
            v_nInterlinePT:= get_ParamNumber(v_vInterline);
          WHEN substr(v_vSpacing,-2,1) = 'mm' THEN
            v_nInterlinePT:= conv2uu(get_ParamNumber(v_vInterline),'mm');
          ELSE
            v_nInterlinePT:= v_nFontSize+NVL(v_nSpacingPT,0);
        END CASE;

        IF v_nFontSize > v_nInterlinePT THEN
        -- Prevent Interline too small
          v_nInterlinePT := v_nFontSize+NVL(v_nSpacingPT,0);
        END IF;
        -- Recalculate v_nSpacingPT
        v_nSpacingPT:=v_nInterlinePT - v_nFontSize;

        if upper1(p_vMode)='T' then
        -- only for compatibility
          t_formats(p_nI).cSpacing   := v_nSpacingPT;
          t_formats(p_nI).cInterline := v_nInterlinePT;

          t_formats(p_nI).ctSpacing   := v_nSpacingPT;   -- change for table spacing
          t_formats(p_nI).ctInterline := v_nInterlinePT; -- change for table interline
        else
          t_formats(p_nI).chSpacing   := v_nSpacingPT;   -- change for header spacing
          t_formats(p_nI).chInterline := v_nInterlinePT; -- change for header interline
        end if;
      end;

    BEGIN

    -- Assign standard column width if specified
      t_tmp := get( c_get_page_width ) - get( c_get_margin_left ) - get( c_get_margin_right );
      IF p_formats is NULL OR p_formats.count=0 THEN
        -- Not all columns are defined
        t_formats := tp_columns();
        t_formats.extend(t_col_cnt);
        FOR c IN 1 .. t_col_cnt    -- Assign standard width equal for all columns
        LOOP
          t_formats(c).colWidth := round( t_tmp / t_col_cnt, 1 );
        END LOOP;
      ELSE
        t_formats := p_formats;
        IF lower(p_um) !='pt' THEN
          for c in 1 .. p_formats.count
          LOOP
            if c=t_col_start then -- Per la prima colonna della tabella dati offsetX=0 se non specificato
              t_formats(c).offsetX:=nvl(t_formats(c).offsetX, 0);
            end if;
            if nvl(t_formats(c).offsetX,-1)>=0 then -- New X position are specified
            -- Calc remaining widht on right side
              t_tmp := get( c_get_page_width ) - get( c_get_margin_left ) - get( c_get_margin_right );
              t_tmp := t_tmp - conv2uu(t_formats(c).offsetX, p_um) ;
            end if;
            -- Check if outside right border
            t_formats(c).colWidth := conv2uu(t_formats(c).colWidth, p_um);
            t_tmp:=t_tmp-t_formats(c).colWidth;

            IF t_tmp < 0 THEN
              RaiseError(-20100);

            END IF;
          end LOOP;
        END IF;


        t_n:= t_col_cnt-p_formats.count;
        IF t_n > 0 THEN
        -- Some format are missing, add using remaining space
          t_formats.extend( t_n );
          FOR c IN p_formats.count+1 .. t_col_cnt
          LOOP
            t_formats(c).colWidth := round( t_tmp / t_n, 1 );
          END LOOP;
        END IF;
      END IF;
    --  Set Default font and size
      IF get( c_get_current_font ) is NULL THEN
        set_font( 'helvetica', 12 );
      END IF;

    -- Assign Default color triplet
      BEGIN
      /* 1-3 Header      Font/Background/Line Color
         4-6 TableRow    Font/Background/Line Color
         7-9 TableOddRow Font/Background/Line Color  */
        t_colors:=p_colors;  -- Table with 9 Default colors
        IF p_colors is null OR p_colors.count < 9 THEN
          t_colors.extend(9-p_colors.count);
          FOR i IN p_colors.count+1..9 LOOP
            CASE
              WHEN i >6 THEN
                t_colors(i):=t_colors(i-3);
              WHEN i IN (2,5) THEN
                t_colors(i):='ffffff'; --White
              ELSE
                t_colors(i):='000000'; --Black
            END CASE;
          END LOOP;
        END IF;
      END;


    -- Verify formats
      DECLARE
        v_nI         INTEGER;
      BEGIN
        FOR v_nI IN t_formats.first .. t_formats.last
        LOOP
        -- HEADER --
          t_formats(v_nI).hFontName  := nvl(t_formats(v_nI).hFontName , g_fonts(g_current_font).family);
          t_formats(v_nI).hFontStyle := nvl(t_formats(v_nI).hFontStyle, g_fonts(g_current_font).style);
          t_formats(v_nI).hFontSize  := nvl(t_formats(v_nI).hFontSize , g_fonts(g_current_font).fontsize); -- pt !
          t_formats(v_nI).hFontColor := NVL(t_formats(v_nI).hFontColor, t_colors(1));
          t_formats(v_nI).hBackColor := NVL(t_formats(v_nI).hBackColor, t_colors(2));
          t_formats(v_nI).hLineColor := NVL(t_formats(v_nI).hLineColor, t_colors(3));
          Test_Alignment(t_formats(v_nI).hAlignment,'@'); --Use default defined into function

        -- DATA TABLE --
        -- If colors are null, use t_colors selectde by row type (even or odd)
        -- t_formats(v_nI).tFontColor
        -- t_formats(v_nI).tBackColor
        -- t_formats(v_nI).tLineColor

          Test_Alignment(t_formats(v_nI).hAlignment,'@'); --Use default defined into function
          Test_AlignVert(t_formats(v_nI).hAlignVert,'@'); --Use default defined into function
        -- DATA TABLE --
        -- tAlignment  default is data type (DATE/NUMERIC/TEXT) dependent
          Test_AlignVert(t_formats(v_nI).tAlignVert,'@'); --Use default defined into function
          IF v_nI = 1 THEN
          -- For first column, initialize null parameter with default
          -- HEADER
            t_formats(v_nI).hLineSize:= nvl(t_formats(v_nI).hLineSize , k_nLineSize); -- pt !
            t_formats(v_nI).hBorder  := nvl(t_formats(v_nI).hBorder, 15);
            t_formats(v_nI).hTMargin := nvl(conv2uu(t_formats(v_nI).hTMargin,p_um), k_nMargin);
            t_formats(v_nI).hBMargin := nvl(conv2uu(t_formats(v_nI).hBMargin,p_um), k_nMargin);
            t_formats(v_nI).hLMargin := nvl(conv2uu(t_formats(v_nI).hLMargin,p_um), k_nMargin);
            t_formats(v_nI).hRMargin := nvl(conv2uu(t_formats(v_nI).hRMargin,p_um), k_nMargin);
            Test_AlignVert(t_formats(v_nI).hAlignVert,'@');
          -- TABLE
            t_formats(v_nI).tLineSize:= nvl(t_formats(v_nI).tLineSize, k_nLineSize);  -- pt !
            t_formats(v_nI).tBorder  := nvl(t_formats(v_nI).tBorder, 15);
            t_formats(v_nI).tTMargin := nvl(conv2uu(t_formats(v_nI).tTMargin,p_um), k_nMargin);
            t_formats(v_nI).tBMargin := nvl(conv2uu(t_formats(v_nI).tBMargin,p_um), k_nMargin);
            t_formats(v_nI).tLMargin := nvl(conv2uu(t_formats(v_nI).tLMargin,p_um), k_nMargin);
            t_formats(v_nI).tRMargin := nvl(conv2uu(t_formats(v_nI).tRMargin,p_um), k_nMargin);
            t_formats(v_nI).tFontName  := nvl(t_formats(v_nI).tFontName , g_fonts(g_current_font).family);
            t_formats(v_nI).tFontStyle := nvl(t_formats(v_nI).tFontStyle, g_fonts(g_current_font).style);
            t_formats(v_nI).tFontSize  := nvl(t_formats(v_nI).tFontSize , g_fonts(g_current_font).fontsize); -- pt !
            t_formats(v_nI).cellRow:=nvl(t_formats(v_nI).cellRow, 0); -- Start with row 0

          ELSE
          -- For other columns, initialize null parameters with preceding columns
            t_formats(v_nI).hLineSize:= nvl(t_formats(v_nI).hLineSize, t_formats(v_nI-1).hLineSize);
            t_formats(v_nI).hBorder  := nvl(t_formats(v_nI).hBorder  , t_formats(v_nI-1).hBorder);
            t_formats(v_nI).hTMargin := nvl(conv2uu(t_formats(v_nI).hTMargin,p_um), t_formats(v_nI-1).hTMargin);
            t_formats(v_nI).hBMargin := nvl(conv2uu(t_formats(v_nI).hBMargin,p_um), t_formats(v_nI-1).hBMargin);
            t_formats(v_nI).hLMargin := nvl(conv2uu(t_formats(v_nI).hLMargin,p_um), t_formats(v_nI-1).hLMargin);
            t_formats(v_nI).hRMargin := nvl(conv2uu(t_formats(v_nI).hRMargin,p_um), t_formats(v_nI-1).hRMargin);
            t_formats(v_nI).hCHeight := nvl(conv2uu(t_formats(v_nI).hCHeight,p_um), t_formats(v_nI-1).hCHeight);
            Test_AlignVert(t_formats(v_nI).hAlignVert,t_formats(v_nI-1).hAlignVert);

            t_formats(v_nI).tLineSize:= nvl(t_formats(v_nI).tLineSize, t_formats(v_nI-1).tLineSize); -- pt!
            t_formats(v_nI).tBorder  := nvl(t_formats(v_nI).tBorder  , t_formats(v_nI-1).tBorder);
            t_formats(v_nI).tTMargin := nvl(conv2uu(t_formats(v_nI).tTMargin,p_um), t_formats(v_nI-1).tTMargin);
            t_formats(v_nI).tBMargin := nvl(conv2uu(t_formats(v_nI).tBMargin,p_um), t_formats(v_nI-1).tBMargin);
            t_formats(v_nI).tLMargin := nvl(conv2uu(t_formats(v_nI).tLMargin,p_um), t_formats(v_nI-1).tLMargin);
            t_formats(v_nI).tRMargin := nvl(conv2uu(t_formats(v_nI).tRMargin,p_um), t_formats(v_nI-1).tRMargin);
            Test_AlignVert(t_formats(v_nI).tAlignVert,t_formats(v_nI-1).tAlignVert);
            t_formats(v_nI).tFontName  := coalesce(t_formats(v_nI).tFontName , t_formats(v_nI-1).tFontName , g_fonts(g_current_font).family);
            t_formats(v_nI).tFontStyle := coalesce(t_formats(v_nI).tFontStyle, t_formats(v_nI-1).tFontStyle, g_fonts(g_current_font).style);
            t_formats(v_nI).tFontSize  := coalesce(t_formats(v_nI).tFontSize , t_formats(v_nI-1).tFontSize , g_fonts(g_current_font).fontsize); -- pt !
            t_formats(v_nI).cellRow:=nvl(t_formats(v_nI).cellRow, t_formats(v_nI-1).cellRow);

          END IF;

        END LOOP;

      -- For all columns
        FOR v_nI IN t_formats.first .. t_formats.last LOOP
          -- Number format and alignment depend of data type
          CASE
            WHEN t_desc_tab(v_nI).col_type member of t_numerics THEN
              t_formats(v_nI).tNumFormat := nvl(t_formats(v_nI).tNumFormat, k_vNumberFormat);
              Test_Alignment(t_formats(v_nI).tAlignment,'R');
            WHEN t_desc_tab(v_nI).col_type member of t_dates    THEN
              t_formats(v_nI).tNumFormat := nvl(t_formats(v_nI).tNumFormat, k_vDateFormat);
              Test_Alignment(t_formats(v_nI).tAlignment,'R');
            ELSE
              t_formats(v_nI).tNumFormat := NULL;
              Test_Alignment(t_formats(v_nI).tAlignment,'L');
          END CASE;
          t_formats(v_nI).cTextArea := t_formats(v_nI).colWidth-t_formats(v_nI).tLMargin-t_formats(v_nI).tRMargin;


          Calc_Interline(v_nI,'T');
          Calc_Interline(v_nI,'H');

          -- CellHeight use Parameter or Font+TopMargin+BottomMargin
          t_formats(v_nI).tCHeight :=
            coalesce(conv2uu(t_formats(v_nI).tCHeight,p_um),
                      t_formats(v_nI).tTMargin
                     +t_formats(v_nI).tBMargin
                     +t_formats(v_nI).chInterline);

          t_formats(v_nI).hCHeight :=
            coalesce(conv2uu(t_formats(v_nI).hCHeight,p_um),
                      t_formats(v_nI).hTMargin
                     +t_formats(v_nI).hBMargin
                     +t_formats(v_nI).ctInterline);
        END LOOP;
      END;
    END;

    -- Offset X  of the text from the left edge of the cell
    function get_tx(c       in pls_integer,
                    p_vMode in varchar2,
                    p_nLen  in pls_integer) return number
    is
      v_vMode   VARCHAR2(1);
      v_vHalign VARCHAR2(1);
      v_nLeft   NUMBER;
      v_nRight  NUMBER;
      v_nWidth  NUMBER;

      v_nTx     NUMBER;
    BEGIN
      v_vMode:=Upper1(p_vMode,'t');
      if v_vMode='H' then
        v_vHalign:=Upper1(t_formats(c).hAlignment,'L');
        v_nLeft  :=t_formats(c).hLMargin;
        v_nRight :=t_formats(c).hRMargin;
      else
        v_vHalign:=Upper1(t_formats(c).tAlignment,'L');
        v_nLeft  :=t_formats(c).tLMargin;
        v_nRight :=t_formats(c).tRMargin;
      end if;
      v_nWidth := t_formats(c).colWidth;

      CASE v_vHalign
        WHEN 'C' THEN -- center into column
          v_nTx:=v_nLeft + (v_nWidth-v_nLeft-v_nRight-p_nLen)/2;
        WHEN 'R' THEN -- Right align
          v_nTx:=v_nWidth-v_nRight-p_nLen;
        ELSE          -- Left align (Default)
          v_nTx:=v_nLeft;
      END CASE;
      return v_nTx;
    end;
    -- Override of preceding function with text instead of len
    function get_tx(c       in pls_integer,
                    p_vMode in varchar2,
                    p_vText in varchar2) return number is
    begin
      return get_tx(c, p_vMode, str_len(p_vText));
    end;

    -- Offset Y of the text from the top edge of the cell
    function get_ty(c        in pls_integer,        -- Index of cell
                    p_vMode  in varchar2,           -- Mode H o T (Default)
                    p_nRowH  in number,             -- Row Height (cell row)
                    p_nTextH in number default null -- Text Height (multirow) Default is FontSize
                    ) return number is
      v_vMode   VARCHAR2(1);
      v_vValign VARCHAR2(1);
      v_nTop    NUMBER;
      v_nBottom NUMBER;
      v_nFontH  NUMBER;
      v_nTextH  NUMBER;
      v_nILine  NUMBER; -- Interline
      v_nTy     NUMBER;
    BEGIN
      v_vMode:=Upper1(p_vMode,'t');
      if v_vMode='H' then
        v_vValign:=Upper1(t_formats(c).hAlignVert,'M');
        v_nTop   :=t_formats(c).hTMargin;
        v_nBottom:=t_formats(c).hBMargin;
        v_nFontH :=t_formats(c).hFontSize;
        v_nILine :=t_formats(c).cInterline;

        v_nTextH:=nvl(p_nTextH, v_nFontH);
        CASE v_vValign
        WHEN 'T' THEN -- align Top
          v_nTy:= -(v_nTop+v_nTextH);
        WHEN 'B' THEN -- align Bottom
          v_nTy:= -p_nRowH+v_nBottom;
        ELSE          -- align Middle
          v_nTy:=(p_nRowH-v_nTop-v_nBottom-v_nTextH);
          if v_nTy>0 then
            v_nTy:= -(v_nTop + v_nTextH + round(v_nTy/2,0));
          else -- Text Height + Top Margin + Bottom Margin is greather than cell Height
            v_nTy:= -(v_nTop+v_nTextH);
          end if;
        END CASE;
      else
        v_vValign:=Upper1(t_formats(c).tAlignVert,'M');
        v_nTop   :=t_formats(c).tTMargin;
        v_nBottom:=t_formats(c).tBMargin;
        v_nFontH :=t_formats(c).tFontSize;
        v_nILine :=t_formats(c).cInterline;

        v_nTextH:=nvl(p_nTextH, v_nFontH);
        CASE v_vValign
        WHEN 'T' THEN -- align Top
          v_nTy:= -(v_nTop+v_nILine);
        WHEN 'B' THEN -- align Bottom
          v_nTy:= -p_nRowH+v_nBottom;
        ELSE          -- align Middle
          v_nTy:=(p_nRowH-v_nTop-v_nBottom-v_nTextH);
          if v_nTy>0 then
            v_nTy:= -(v_nTop + round(v_nTy/2,0) + v_nILine);
          else -- Text Height + Top Margin + Bottom Margin is greather than cell Height
            v_nTy:= -(v_nTop+v_nILine);
          end if;
        END CASE;
      end if;
      return v_nTy;
    end;

    procedure AddImage(p_blob in blob, c in number,
                       p_vMode in varchar2 default 'DATA') IS
    BEGIN
      if p_vMode='BREAK' then
        t_bcells(c).cImage := p_blob;
      else
        t_Cells(c).cImage := p_blob;
      end if;
    END;

 -- Add Text row to cell
    PROCEDURE AddRow(p_vRow IN VARCHAR2,
                     c IN NUMBER,
                     p_bSpacing IN BOOLEAN:=FALSE,
                     p_vMode in varchar2 default 'DATA',
                     v_nTextArea   in number:=0 ,
                     v_nSpaceWidth in number:=0) IS
      v_nTextWidth  NUMBER;
      v_nTextHeight NUMBER;
      v_nLast       NUMBER;
    BEGIN

      if p_vMode='BREAK' then
        v_nLast:=nvl(t_bcells(c).cRowText.Count,0)+1;
        t_bcells(c).cRowText(v_nLast) := Justify(p_vRow, v_nTextArea, v_nSpaceWidth, v_nTextWidth);

        t_bcells(c).cRowTextWidth(v_nLast) := v_nTextWidth;
        t_bcells(c).cRowTextX(v_nLast) := t_bcells(c).cX + get_tx(c,'T', v_nTextWidth);
      -- Total text height (of the cell)
        t_bcells(c).cTextHeight :=
                 nvl(t_bcells(c).cTextHeight,0)
                 + t_formats(c).cInterline
                 - CASE WHEN p_bSpacing=FALSE THEN t_formats(c).cSpacing ELSE 0 END;
        t_bcells(c).cRowsCount:=v_nLast;
        t_bcells(c).cRowTextY(v_nLast):=-(v_nLast-1)*t_bcells(c).cTextHeight;
      else
        v_nLast:=nvl(t_Cells(c).cRowText.Count,0)+1;
        t_Cells(c).cRowText(v_nLast) := Justify(p_vRow, v_nTextArea, v_nSpaceWidth, v_nTextWidth);

        t_Cells(c).cRowTextWidth(v_nLast) := v_nTextWidth;
        t_Cells(c).cRowTextX(v_nLast) := t_Cells(c).cX + get_tx(c,'T', v_nTextWidth);
      -- Total text height (of the cell)
        v_nTextHeight:= t_formats(c).cInterline
                 - CASE WHEN p_bSpacing=FALSE THEN t_formats(c).cSpacing ELSE 0 END;
        t_Cells(c).cTextHeight :=
                 nvl(t_Cells(c).cTextHeight,0) -- Altezza Attuale
                 + v_nTextHeight;
        t_Cells(c).cRowsCount:=v_nLast;
        t_Cells(c).cRowTextY(v_nLast):=-(v_nLast-1)*v_nTextHeight;
      end if;
    END;

    function singleWord(p_vWord in varchar2, c in number, p_vMode in varchar2, v_nTextArea in number, v_nSpaceWidth in number) return varchar2 is
      v_vWord varchar2(200);
      wc      integer;
    begin
      IF str_len(p_vWord) > v_nTextArea THEN
      -- The single word is too long
        v_vWord:=p_vWord;
        FOR wc IN 1..length(v_vWord)
        LOOP          -- proceed letter by letter
          IF str_len(substr(v_vWord,1,wc)) > v_nTextArea THEN
          -- reached the limit length, add break and go
          -- ##ALERT!## do I justify it ? if yes add    v_nSpaceWidth, v_nTextArea
            AddRow(substr(v_vWord,1,wc-1), c, FALSE, p_vMode, v_nTextArea, v_nSpaceWidth);

            v_vWord:=substr(v_vWord,wc);
          END IF;
        END LOOP;
        return(v_vWord); -- start the line with the remaining part
      ELSE
        return(p_vWord);
      END IF;

    end;

    PROCEDURE WordWrap2(p_vFieldText IN VARCHAR2, c IN NUMBER,
                        p_vMode in varchar2 default 'DATA') IS
      t_row         VARCHAR2(200):='';
      v_nTextArea   NUMBER;
      v_vWord       VARCHAR2(200);
      v_vFieldText  VARCHAR2(4000);
      v_nBreakLine  INTEGER;
      v_nSpaceWidth NUMBER:=0;
    BEGIN
      v_nTextArea:=t_formats(c).cTextArea;  -- Retrieve max Width of text
      if t_formats(c).tAlignment='J' then
        v_nSpaceWidth:=str_len(' ');
      else
        v_nSpaceWidth:=0;
      end if;

      -- ##TODO## Retrieve Space width in pt
      v_vFieldText:=p_vFieldText;
      v_nBreakLine:=instr(v_vFieldText, '\n');   -- Find presenze of NewLine in string
      if v_nBreakLine >0 then
        v_vFieldText:=regexp_replace(v_vFieldText,'( +)\\n','\\n'); --Remove space folloowed by NewLine
      end if;
      IF (v_nBreakLine>0) or ((trunc(str_len(v_vFieldText)/v_nTextArea,0)+1) > 1) THEN
        FOR r IN (select regexp_substr(v_vFieldText,'[^ ]+', 1, level) Word
                    from dual
                 connect by regexp_substr(v_vFieldText, '[^ ]+', 1, level) is not null )
        LOOP
          IF t_row IS NOT NULL THEN
            t_row:=t_row||' '; -- Append a space if isn't the first word of row
          END IF;
          if (v_nBreakLine>0) and (instr(r.word, '\n')>0) then
            v_vWord:=substr(r.word,1,instr(r.word, '\n'));
            IF str_len(t_row || v_vWord) > t_formats(c).cTextArea THEN
            -- Add one line to collection.

              AddRow(t_row, c, TRUE, p_vMode, v_nTextArea, v_nSpaceWidth);
            -- Create bnew line whit only one word.

              t_row:=singleWord(v_vWord, c, p_vMode, 0, 0);
            -- Add new line

              AddRow(t_row, c, TRUE, p_vMode, 0, 0);
            ELSE
              t_row:=t_row||r.word;
              AddRow(t_row, c, TRUE, p_vMode, 0, 0);
            END IF;
            v_vWord:=substr(r.word,instr(r.word, '\n')+2);
            -- creo una nuova riga con la parte restante dopo \n
            t_row:=singleWord(v_vWord, c, p_vMode, 0, 0);
          else
            IF str_len(t_row || r.word) > t_formats(c).cTextArea THEN
            -- Excessive Lenght, store the row and continue
              AddRow(t_row, c, TRUE, p_vMode, v_nTextArea, v_nSpaceWidth);
              t_row:=singleWord(r.word, c, p_vMode, v_nTextArea, v_nSpaceWidth);
            ELSE
              t_row:=t_row||r.word;
            END IF;
          end if;
        END LOOP;
      ELSE
        t_row := p_vFieldText;
      END IF;

      -- Add Last Row, it's never justified
      AddRow(t_row, c, FALSE, p_vMode);
    END;

 -- Calculate cell rows in Header
 -- Detect height of each cell row
 -- Detect total height
    procedure PrepareHeader is
      c      pls_integer;    -- Column Index
      r      pls_integer:=0; -- Row    Index
      rr     pls_integer:=0; -- Current Row
      x      number:=0;      -- x position
      y      number:=0;      -- y position
      w      number:=0;      -- width
      h      number:=0;      -- height
      hh     number:=0;      -- Header heigth
    begin

      g_bForce:=TRUE;
      for c in t_col_start .. t_col_cnt       -- for each column (esclude breaking columns)
      loop
        setCellFont(c, FALSE,'H');            -- Detect font from parameter and activate for calculation
        r:= coalesce(t_formats(c).cellRow,0); -- Detect row number
      -- Detect max row height
        if t_hrows.exists(r) = False then
          t_hrows(r).height:=0;
        end if;
        t_hrows(r).height:=
          greatest(t_hrows(r).height,
                   t_formats(c).hTMargin+t_formats(c).hBMargin+t_formats(c).hFontSize,
                   t_formats(c).hCHeight);
      end loop;
    -- Detect total Header height (sum of each row height)
      r := t_hrows.FIRST;
      while r IS NOT NULL LOOP
        hh := hh + t_hrows(r).height;
        r := t_hrows.NEXT(r);
      END LOOP;
    -- repeat column loop, detect x,y for each Text row
    -- x,y are offset from startX e StartY
    -- do not verify width

      rr:=coalesce(t_formats(t_col_start).cellRow, 0); -- Riga della prima cella da trattare
      x:=0;
      for c in t_col_start .. t_col_cnt
      loop
        r:=coalesce(t_formats(c).cellRow, 0);
        if r > rr then -- row changed
          rr:=r;       -- Update row number
          x:=0;        -- reset x
          y:=y-h;      -- reduce y with preceding row height
        end if;
        x:=coalesce(t_formats(c).offsetX, x);   -- Update x with parameter if specified
        w:=t_formats(c).colWidth;               -- cell width
        h:=t_hrows(r).height;                   -- cell heght

        t_hcells(c).x:=x;
        t_hcells(c).y:=y;
        t_hcells(c).w:=w;
        t_hcells(c).h:=h;
        t_hcells(c).tx:=get_tx(c,'H',t_formats(c).colLabel);
        t_hcells(c).ty:=get_ty(c,'H', h);
        t_hcells(c).testo:=t_formats(c).colLabel;

        x:=x+w; -- Detect next cell position
      end loop;
      case
        when coalesce(p_hRowHeight,-1) = 0 then
        -- Zero: no header
          hh:=0;
          v_nHeaderHeight:=hh;
        when coalesce(p_hRowHeight,-1) = -1 then
        -- null: detect automatically
          v_nHeaderHeight:=hh;
        else
        -- Force: Use specified value. WARNING ! check it before use
          v_nHeaderHeight:=p_hRowHeight;
      end case;
    end;
    procedure DrawBorderAround(p_nY1 in number,
                               p_nY2 in number,
                               p_nW  in number)
    is
    begin
      -- Draw Border Around Frame only if Line size > 0
      if t_Frame_Line>0 then
        rect(t_start_x,
             p_nY2,
             p_nW, p_nY1-p_nY2,
             t_Frame_Color, null, t_Frame_Line);
      end if;
    end;

    procedure DrawBorder(c       in pls_integer,
                         p_vMode in varchar2,
                         p_nY    in number,
                         p_nOdd  in pls_integer default null)
    is
      v_vMode       varchar2(1);
      v_nLineSize   NUMBER;
      v_vFontColor  VARCHAR2(6);
      v_vBackColor  VARCHAR2(6);
      v_vLineColor  VARCHAR2(6);
      t_start_y     number;
      v_nOdd        pls_integer;
      x      number:=0;      -- x  position
      y      number:=0;      -- y position
      w      number:=0;      -- width
      h      number:=0;      -- heinht
      b      number(2);      -- Border type
    begin

      v_vMode:=Upper1(p_vMode,'t');
      t_x:=nvl(t_x,0);
      case v_vMode
      when 'H' then
        v_nLineSize:=nvl(t_Formats(c).hLineSize,k_nLineSize);
        --v_vFontColor:=nvl(t_formats(c).hFontColor, t_colors(1));
        v_vBackColor:=nvl(t_formats(c).hBackColor, t_colors(2));
        v_vLineColor:=nvl(t_formats(c).hLineColor, t_colors(3));
        w:=t_hcells(c).w;
        h:=t_hcells(c).h;
        b:=t_formats(c).hBorder;
        x:=t_x+t_hcells(c).x;
        y:=t_hcells(c).y-h;
      When 'B' then
        v_nOdd := 0;
        v_nLineSize:=nvl(t_Formats(c).tLineSize,k_nLineSize);
        --v_vFontColor:=nvl(t_formats(c).tFontColor, t_colors(4+v_nOdd));
        v_vBackColor:=nvl(t_formats(c).tBackColor, t_colors(5+v_nOdd));
        v_vLineColor:=nvl(t_formats(c).tLineColor, t_colors(6+v_nOdd));
        w:=t_formats(c).colWidth;
        h:=t_bCells(c).cHeight;
        b:=t_formats(c).tBorder;
        x:=t_x+t_bCells(c).cX;
        y:=t_bCells(c).cY-h;

      else
        v_nOdd := coalesce(p_nOdd, n_oddLine);
        v_nLineSize:=nvl(t_Formats(c).tLineSize,k_nLineSize);
        --v_vFontColor:=nvl(t_formats(c).tFontColor, t_colors(4+v_nOdd));
        v_vBackColor:=nvl(t_formats(c).tBackColor, t_colors(5+v_nOdd));
        v_vLineColor:=nvl(t_formats(c).tLineColor, t_colors(6+v_nOdd));
        w:=t_formats(c).colWidth;
        h:=t_Cells(c).cHeight;
        b:=t_formats(c).tBorder;
        x:=t_x+t_Cells(c).cX;
        y:=t_Cells(c).cY-h;
      end case;
      t_start_y:=p_nY;


      IF v_nLineSize = 0 THEN
      -- Cell without border
        IF v_vBackColor != 'ffffff' THEN  -- Draw only background if not white
          rect(t_start_x + x,
               t_start_y + y,
               w, h,
               v_vBackColor, v_vBackColor, v_nLineSize);
        END IF;

      else
        IF b = 15 THEN -- Full border
          rect(t_start_x + x ,
               t_start_y + y ,
               w, h,
               v_vLineColor, v_vBackColor, v_nLineSize);
        ELSE
        -- Draw Background color without border
          rect(t_start_x + x + v_nLineSize,
               t_start_y + y + v_nLineSize,
               w -2*v_nLineSize, h-2*v_nLineSize,
               v_vBackColor, v_vBackColor, 0);

        -- Draw only required border
          if BITAND(b,1) = 1 then --Top
            horizontal_line(
              t_start_x + x,
              t_start_y + y + h,
              w,
              v_nLineSize, v_vLineColor);
          end if;

          if BITAND(t_formats(c).tBorder,2) = 2 then --Bottom
            horizontal_line(
              t_start_x + x,
              t_start_y + y,
              w,
              v_nLineSize, v_vLineColor);
          end if;

          if BITAND(t_formats(c).tBorder,4) = 4 then --Left
            vertical_line(
              t_start_x + x,
              t_start_y + y,
              h,
              v_nLineSize, v_vLineColor);
          end if;

          if BITAND(t_formats(c).tBorder,8) = 8 then --Right
            vertical_line(
              t_start_x + x + w,
              t_start_y + y,
              h,
              v_nLineSize, v_vLineColor);
          end if;

        end if;

      end if;
    end;

    procedure PrepareBreak(p_row in pls_integer) is
      c      pls_integer;    -- Column Index
      r      pls_integer:=0; -- Row    Index
      rr     pls_integer:=0; -- Current Row
      x      number:=0;      -- x position
      y      number:=0;      -- y position
      w      number:=0;      -- width
      h      number:=0;      -- height
      hh     number:=0;      -- Break Block total height
      t      number;
      b      number;
    begin

      t_bcells.delete;                          -- clean array
      t_brows.delete;                           -- clean array
      if t_col_start > 1 then                   -- Proceed only if break are required
        g_bForce:=TRUE;
        setCellFont(1, FALSE,'T');
        for c in 1 .. t_col_start -1            -- for each column in break block
        loop
          if t_bCells.exists(c) = false then
            t_bCells(c).cTextHeight:=0;
          end if;
          setCellFont(c, FALSE,'T');            -- Detect font from parameter and activate it
          r:= coalesce(t_formats(c).cellRow,0); -- Detect row number
          if r > rr then -- Row changed
            rr:=r;       -- Update row numebr
            x:=0;        -- reset x
            y:=y-h;      -- reduce y with preceding row height
          end if;
          x:=coalesce(t_formats(c).offsetX, x);   -- Apdate x if StartX is specified
          t_bCells(c).cX:=x;
          t_bCells(c).cY:=y;
          w:=t_formats(c).colWidth;               -- cell width
          t_bCells(c).cWidth:=w;

          if getValue(c, p_row)='TEXT' then       -- Append text rows
            WordWrap2(t_txt, c, 'BREAK');
          else
            AddRow(t_txt,c, FALSE,'BREAK');
          end if;
          -- Detect max row height
          t:=t_formats(c).tTMargin;
          b:=t_formats(c).tBMargin;
          if t_brows.exists(r)=false then
            t_brows(r).Height:=0;
          end if;
          h:= greatest(nvl(t_brows(r).Height,0),
                     t+b+t_bCells(c).cTextHeight,
                     t+b+t_formats(c).hFontSize,
                     t_formats(c).tCHeight);
          t_brows(r).Height:=h;
          t_bCells(c).cHeight:=h;

          x:=x+w; -- Detect next cell position
        end loop;
        -- Repeat loop for verticola alignment
        -- I can't made it before because there isn't row Height
        for c in 1 .. t_col_start -1
        loop
          r:=coalesce(t_formats(c).cellRow, 0);
          h:=t_brows(r).Height;
          t_bCells(c).cHeight:=h;
          t_bCells(c).cTy := get_ty(c, 'T', h, t_bCells(c).cTextHeight);
        end loop;
        -- Calculate Record Block height (sum of cell row height)
        hh:=0;

        for r in t_brows.FIRST .. t_brows.LAST
        LOOP
          hh := hh +  t_brows(r).Height;
        END LOOP;
        v_nBreakHeight:=hh;


      else
        hh:=0;    -- No Break required, reset height
      end if;
      v_nBreakHeight:=hh;
    end;

    -- Detect new break key
    -- TRUE if is differente form preceding row
    -- Load array of values to print
    function VerifyBreak(p_row in pls_integer) return boolean is
      v_bFlag BOOLEAN := FALSE;
    begin
      v_vBreakNew:='|';
      v_nBreakHeight:=0;                      -- reset Height
      if t_col_start > 1 then                 -- Break non required, exit
        for c in 1 .. t_col_start -1          -- for each break columns
        loop
          v_vBreakNew:=v_vBreakNew||
            getValue(c, p_row,'VALUE')||'|';  -- compose the break key
        end loop;
        if v_vBreakNew!=v_vBreakOld then      -- break key is changed
          v_vBreakOld:=v_vBreakNew;
          PrepareBreak(p_row);

          v_bFlag:=TRUE;
        end if;
      end if;
      return v_bFlag;
    end;

    function RecordWidth return number is
      c      pls_integer;    -- Column Index
      w      number:=0;
      x      number:=0;
    begin
      x := p_startX;
      for c in t_col_start .. t_col_cnt
      loop
        if t_Formats.exists(c) then
          if t_Formats(c).offsetX is not null then
            x := p_startX+t_Formats(c).offsetX;
          end if;
          w := greatest(w, x + t_Formats(c).colWidth);
        end if;
      end loop;
      return w;
    end;

    procedure PrepareRecord(p_row pls_integer) is
      c      pls_integer;    -- Column Index
      r      pls_integer:=0; -- Row associated to cell
      rr     pls_integer:=0; -- Row associated to last cell
      x      number:=0;      -- x position
      y      number:=0;      -- y position
      w      number:=0;      -- width
      h      number:=0;      -- height
      hh     number:=0;      -- Record height
      t      number;
      b      number;
    begin
    -- don't check if cell is outside right margin
      rr:=coalesce(t_formats(t_col_start).cellRow, 0); -- Cell row of first cell
      x:=0;

      if t_rrows.exists(r)=false then
        t_rrows(r).Height:=0;
  -- VALR 0.3.5.07 reset rowheight if g_settings.tRowHeightMin is defined
      elsif nvl(g_settings.tRowHeightMin,0)!=0 then
        t_rrows(r).Height:=g_settings.tRowHeightMin;
      elsif nvl(g_settings.tRowHeightExact,0)!=0 then
        t_rrows(r).Height:=g_settings.tRowHeightExact;
      end if;

      t_Cells.delete;
      g_bForce:=TRUE;
      for c in t_col_start .. t_col_cnt
      loop
        if t_Cells.exists(c) = false then
          t_Cells(c).cTextHeight:=0;
        end if;
        setCellFont(c, FALSE,'T');              -- Detect font and activate it for calculations
        r:=coalesce(t_formats(c).cellRow, 0);
        if t_rrows.exists(r)=false then         -- 20151214 Added to prevent error
         t_rrows(r).Height:=0;
        end if;
        if r > rr then -- Row changed
          rr:=r;       -- update row number
          x:=0;        -- Reset x
          y:=y-h;      -- reduce y with preceding row height

          if t_rrows.exists(r)=false then
            t_rrows(r).Height:=0;
  -- VALR 0.3.5.07 reset rowheight if g_settings.tRowHeightMin is defined
          elsif nvl(g_settings.tRowHeightMin,0)!=0 then
            t_rrows(r).Height:=g_settings.tRowHeightMin;
          elsif nvl(g_settings.tRowHeightExact,0)!=0 then
            t_rrows(r).Height:=g_settings.tRowHeightExact;
          end if;
        end if;
        x:=coalesce(t_formats(c).offsetX, x);     -- Update x if OffsetX is specified
        y:=coalesce(-t_formats(c).offsetY, y);    -- Update y if OffsetY is specified ##CHECK# sign
        t_Cells(c).cX:=x;
        t_Cells(c).cY:=y;

        w:=t_formats(c).colWidth;                 -- cell width
        t_Cells(c).cWidth:=w;

        case getValue(c, p_row)
          when 'TEXT' then                        -- Append text rows
            WordWrap2(t_txt, c);                  -- t_txt is aligned from getValue
          when 'CLOB' then                        -- Append cLob Image
            t_Cells(c).cImage:=t_blob;
          else
            AddRow(t_txt, c);                     -- t_txt is aligned from getValue
        end case;
        -- Detect max cell row height
        t:=t_formats(c).tTMargin;
        b:=t_formats(c).tBMargin;









        h:= greatest(nvl(t_rrows(r).Height,0),
                     t+b+t_Cells(c).cTextHeight,
                     t+b+t_formats(c).hFontSize,
                     t_formats(c).tCHeight);
        t_rrows(r).Height:=h;
        t_Cells(c).cHeight:=h;

        x:=x+w; -- Detect next cell position
      end loop;
      -- Repeat loop for vertical alignment
      for c in t_col_start .. t_col_cnt
      loop
        r:=coalesce(t_formats(c).cellRow, 0);
        h:=t_rrows(r).Height;
        t_Cells(c).cHeight:=h;
        t_Cells(c).cTy := get_ty(c, 'T', h, t_Cells(c).cTextHeight);
      end loop;

      -- Calculate total Record Block Height
      hh:=0;
      for r in t_rrows.FIRST .. t_rrows.LAST
      LOOP
        hh := hh +  t_rrows(r).Height;
      END LOOP;
      -- Use tRowHeightExact if defied
      if nvl(g_settings.tRowHeightExact,0)>0 then
        v_nRecordHeight:=g_settings.tRowHeightExact;
      else
        v_nRecordHeight:=greatest(hh, g_settings.tRowHeightMin);
      end if;

    end;

    PROCEDURE show_header IS
      c pls_integer;
      r pls_integer;
      v_vColor       varchar2(6);
    begin
      log('Header',true);
      if coalesce(p_hRowHeight,1) > 0 then     -- Not printed if Height = 0
        g_bForce:=TRUE;                        -- Force font changing on firts change
        for c in t_col_start .. t_col_cnt      -- for each columns (exclude break columns)
        loop
          r:=coalesce(t_formats(c).cellRow,0); -- Detect row number
          DrawBorder(c,'H',t_y);
          setCellFont(c, TRUE,'H');            -- Detect font and activate it for calculation
          v_vColor:=NVL(t_formats(c).hFontColor, t_Colors(1)); -- Change color if required
          IF g_current_fcolor != v_vColor or g_bForce=TRUE THEN
            set_color(v_vColor);
          END IF;
          g_bForce:=FALSE;
        -- Print text
          put_txt(t_start_x+ t_hcells(c).x + t_hcells(c).tx,
                  t_y + t_hcells(c).y + t_hcells(c).ty, t_hcells(c).testo);
        end loop;
        set_font_style('N');                   -- Reset font style
        t_y:=t_y-v_nHeaderHeight;              -- Move down y position
      else
        v_nHeaderHeight:=0;                    -- NO Header required;
      end if;
    end;

    procedure show_break is
      c pls_integer;
      r pls_integer;
      v_vColor       varchar2(6);
      v_nX     number;
      v_nY     number;
    begin
      if t_col_start > 1 then                  -- Not printed if Height = 0
        log('Break',true);
        g_bForce:=TRUE;                        -- force font changing on first change
        for c in 1 .. t_col_start-1            -- for each columns (exclude break columns)
        loop
          r:=coalesce(t_formats(c).cellRow,0); -- Detect row number
          DrawBorder(c,'B',t_y,0);             -- Draw border, ingore odd/eve difference
          setCellFont(c, TRUE,'T');            -- Detect font and activate it for calculation
          setCellColor(c,0);                   -- Change color if required
          g_bForce:=FALSE;
        -- Print Text
          v_nX:=t_start_x + t_bCells(c).cRowTextX(r);
          v_nY:=t_y + t_bCells(c).cY + t_bCells(c).cTy - t_bCells(c).cRowTextY(r);
          put_txt(v_nX, v_nY, t_bCells(c).cRowText(r) );
        end loop;
        set_font_style('N');                   -- Reset font style
        t_y:=t_y-v_nBreakHeight;               -- Move down y position
      end if;
    end;

    procedure show_record is
      r        pls_integer;
      v_vColor varchar2(6);
      v_nX     number;
      v_nY     number;
    begin
      log('Record', true);
      for c in t_col_start .. t_col_cnt        -- for each columns (exclude break columns)
      loop
        DrawBorder(c,'T',t_y);                 -- Draw border, ignore odd/even difference
        setCellFont(c, TRUE,'T');              -- Detect font and activate it
        setCellColor(c);                       -- Change color if required
        g_bForce:=FALSE;                       -- Disable Force Format after first set
      -- Print text
        if nvl(dbms_lob.getlength(t_Cells(c).cImage),0) = 0 then
          for r in t_Cells(c).cRowText.FIRST .. t_Cells(c).cRowText.LAST
          LOOP                                   -- for each text row in the cell
            v_nX:=t_x + t_start_x + t_Cells(c).cRowTextX(r);
            v_nY:=t_y + t_Cells(c).cY + t_Cells(c).cTy + t_Cells(c).cRowTextY(r);
            put_txt(v_nX, v_nY, t_Cells(c).cRowText(r) );
          END LOOP;
        else
          v_nX:=t_x + t_start_x;
          v_nY:=t_y + t_Cells(c).cY;

        -- Use clob as image and tNumFormat as special format string for image
        -- example of tNumFormat: 'w=100pt,h=50mm,a=L,v=M'
          declare
            v_vFmt   varchar2(100);
            p varchar2(100);
            w number:=0;
            h number:=0;
            hAlign varchar2(1);
            vAlign varchar2(1);

            -- Parse String value with um and return w or h ratio
            function get_ImageRatio(p_nRef in number) return number is
              v_vDummy  varchar2(100);
              v_vReturn number;
            begin
              v_vDummy:=parseString(v_vFmt);
              if v_vDummy='-1' then
                if p_nRef=-1 then
                  v_vReturn:=0;
                else
                  v_vReturn:=-1;
                end if;
              else
                v_vReturn:=get_ParamPT(v_vDummy);
              end if;
              return v_vReturn;
            end;
          begin
            v_vFmt:=replace(replace(trim(p_formats(c).tNumFormat),' ',','),';',',');
          -- Initialize Defualt Values
            h:=0;
            w:=0;
            hAlign:='C';
            vAlign:='C';

            while nvl(v_vFmt,' ') != ' '
            loop
              p:=upper1(parseString(v_vFmt,'='));
              case p
                when 'W' then
                  w:=get_ImageRatio(h);
                when 'H' then
                  h:=get_ImageRatio(w);
                when 'A' then  -- ## I can use tAlignment ##
                  hAlign:=upper1(parseString(v_vFmt)||'C');
                when 'V' then  -- ## I can use  tAlignVert ##
                  vAlign:=upper1(parseString(v_vFmt)||'C');
                else
                  null;
              end case;
            end loop;
         -- Added 2 optional parameters Cell Width & Height
            put_image(t_Cells(c).cImage, v_nX, v_nY, w, h, hAlign, vAlign, 'pt',
                      t_formats(c).colWidth,
                      t_formats(c).tCHeight );

          end;

        end if;
      end loop;
      t_y:=t_y-v_nRecordHeight;                -- Move down y position
      set_font_style('N'); -- Reset font style
    end;

----------------------------------------------------------------------------------------------
-- BEGIN OF MAIN
--------------------------------------------------------------------------------------------
  BEGIN
$IF DBMS_DB_VERSION.VER_LE_10 $THEN
    dbms_sql.describe_columns2( p_c, t_col_cnt, t_desc_tab );
$ELSE
    dbms_sql.describe_columns3( p_c, t_col_cnt, t_desc_tab );
$END
    set_rowHeight(p_hRowHeight, p_tRowHeight, p_um);

--  -- Convert pt RowHeight parameters, if not defined use the Defaults
--    t_hRowHeight := coalesce(conv2uu(p_hRowHeight, p_um), g_settings.hRowHeight) ;
--    t_tRowHeight := coalesce(conv2uu(p_tRowHeight, p_um), g_settings.tRowHeight) ;
    t_col_start  := p_BreakField+1;

    SetDefaults;
    g_Log:=false;

--  Assign data type to columns
    for c in 1 .. t_col_cnt
    loop
      case
        when t_desc_tab( c ).col_type member of t_numerics then
          dbms_sql.define_array( p_c, c, n_tab, p_bulk_size, 1 );
        when t_desc_tab( c ).col_type member of t_dates    then
          dbms_sql.define_array( p_c, c, d_tab, p_bulk_size, 1 );
        when t_desc_tab( c ).col_type member of t_chars    then
          dbms_sql.define_array( p_c, c, v_tab, p_bulk_size, 1 );
        when t_desc_tab( c ).col_type member of t_blobs    then
          dbms_sql.define_array( p_c, c, b_tab, p_bulk_size, 1 );
        else
          null;
      end case;
    end loop;

    t_start_x    := get( c_get_margin_left ) + nvl(conv2uu(p_startX, p_um),0);
    t_lineheight := get( c_get_fontsize )*v_Interline;       --Min hight are FontSize + 20%
    t_lineheight := nvl( g_settings.tRowHeightExact,
                         greatest(g_settings.tRowHeightMin,
                                  t_lineheight));            --Use parameter if greather

    t_y := coalesce(get(c_get_y)-t_lineheight,
                    get(c_get_page_height)-get(c_get_margin_top)/*ValR -t_lineheight*/);

    -- t_yBegin:=get(c_get_page_height)-get(c_get_margin_top); /*#Valr 2014.07.08 BugFix Stat point of new page */
    t_yBegin:=get(c_get_page_height)-get(c_get_margin_top)-nvl(conv2uu(p_startY, p_um),0); /*#Valr 2014.09.18 add p_startY parameter */

    --g_Log:=TRUE;
    PrepareHeader;              -- Load Header array and detect v_nHeaderHeight

    n_oddLine:=0;               -- Initialize row evidentiation (odd/even)
    t_r := dbms_sql.fetch_rows( p_c );
    g_bForce:=TRUE;

    -- Border Around Frame, detect LineSize and color
    declare
      v_vFrame varchar2(100);
      p        varchar2(100);
    begin
      v_vFrame:=replace(replace(trim(p_Frame),' ',','),';',',');
    -- Initialize Defaults
      t_Frame_color :='000000';
      t_Frame_Line  :=0;
    -- Scan parametrs string
      while nvl(v_vFrame,' ') != ' '
      loop
        p:=upper1(parseString(v_vFrame,'='));
        case p
          when 'L' then --Line Size
            t_Frame_Line  :=get_ParamPT(parseString(v_vFrame));
          when 'C' then --Color
            t_Frame_color :=lpad(ltrim(rtrim(parseString(v_vFrame))),6,'0');
            if to_char(to_number(t_Frame_color,'xxxxxx'), 'xxxxxx') != t_Frame_color then
              t_Frame_color:='000000';
            end if;
          else
            null;
        end case;
      end loop;

    end;


    if g_settings.LabelMode then      -- Label Mode:
    -- Check parameters
      g_labeldef.hDistance:=nvl(g_labeldef.hDistance,0);
      g_labeldef.vDistance:=nvl(g_labeldef.vDistance,0);

      if nvl(g_labeldef.Width,0)=0 then
        -- At least 1 column
        if nvl(g_labeldef.MaxColumns,0)=0 then
          g_labeldef.MaxColumns:=1;
        end if;
        -- Calc column width
        g_labeldef.Width := trunc(
          (  g_settings.page_width
           - g_settings.margin_left - g_settings.margin_right
           + g_labeldef.hDistance) / g_labeldef.MaxColumns )
           - g_labeldef.hDistance;
        if g_labeldef.Width < 1 then
          RaiseError(-20001);


        end if;
      else
        if nvl(g_labeldef.MaxColumns,0)=0 then
        -- calc MaxColumns
          g_labeldef.MaxColumns := trunc(
          (  g_settings.page_width
           - g_settings.margin_left - g_settings.margin_right
           + g_labeldef.hDistance) /
          (g_labeldef.Width + g_labeldef.hDistance));
          if g_labeldef.MaxColumns <=0 then
            RaiseError(-20002);


          end if;
        else
        -- or check if exits page width
          if (g_labeldef.MaxColumns *g_labeldef.Width
             +(g_labeldef.MaxColumns-1)*g_labeldef.hDistance
             +g_settings.margin_left
             +g_settings.margin_right) > g_settings.page_width
          then
            RaiseError(-20003);


          end if;
        end if;
      end if;

      if nvl(g_labeldef.Height,0)=0 then
        if nvl(g_labeldef.MaxRows,0)=0 then
          g_labeldef.MaxRows:=1;         -- At least 1 row
        end if;
      -- Calc column height
        g_labeldef.Height := trunc(
          (  g_settings.page_height
           - g_settings.margin_top - g_settings.margin_bottom
           + g_labeldef.vDistance) / g_labeldef.MaxRows)
           - g_labeldef.vDistance;
        if g_labeldef.Height < 1 then
          RaiseError(-20011);


        end if;
      else
        if nvl(g_labeldef.MaxRows,0)=0 then
        -- Calculate MaxRows
          g_labeldef.MaxRows := trunc(
          (  g_settings.page_height
           - g_settings.margin_top - g_settings.margin_bottom
           + g_labeldef.vDistance) /
          ( g_labeldef.Height + g_labeldef.vDistance));
          if g_labeldef.MaxRows <=0 then
            RaiseError(-20012);


          end if;
        else
        -- or check if it exits page height
          if (g_labeldef.MaxRows    *g_labeldef.Height
             +(g_labeldef.MaxRows-1)*g_labeldef.vDistance
             +g_settings.margin_top
             +g_settings.margin_bottom) > g_settings.page_height
          then
            RaiseError(-20013);


          end if;
        end if;
      end if;

      declare -- Label mode Block
        v_iCol          pls_integer;   -- Column index in Label mode
        v_iRow          pls_integer;   -- Row index in Label mode
        x number;
        y number;
      begin
        v_iCol:=0;
        v_iRow:=1;
        FOR i IN 0 .. t_r - 1
        LOOP                        -- ** FOR EACH ROW IN THE DATA TABLE ** --
          -- Calculate next col, row
          v_iCol:=v_iCol+1;
          if v_icol > g_labeldef.MaxColumns then
            v_icol:=1;
            v_iRow:=v_iRow+1;
            if v_iRow > g_labeldef.MaxRows then
              v_iRow:=1;
              new_page;
              t_y:=t_yBegin;           -- Reset Y position
              g_bForce :=true;         -- force font changing
            end if;
          end if;
          if v_iCol > 1 then
            t_x := (v_iCol-1)*(g_labeldef.width + g_labeldef.hDistance);
          else
            t_x := 0;


          end if;
          if v_iRow > 1 then
            t_y := t_yBegin - (v_iRow-1)*(g_labeldef.height + g_labeldef.vDistance);
          else
            t_y := t_yBegin;


          end if;
          PrepareRecord(i); -- :IT: credo vada gia bene
          Show_record;      -- :IT: deve gestire offset x e y
          n_oddLine:=0;     -- OddEven switch disabled for Labeling
        END LOOP;
      END;

    else
    -- Normal mode
      t_Frame_width:= RecordWidth;

      FOR i IN 0 .. t_r - 1
      LOOP                         -- ** FOR EACH ROW IN THE DATA TABLE ** --
        PrepareRecord(i);          -- Load Record array
        if VerifyBreak(i) then     -- check break block, load Break array and detect BreakHeight
          w_BlockHeight:=v_nBreakHeight+v_nHeaderHeight+v_nRecordHeight;
        else                       -- Break not required or Break not detected
          if i=0 then              -- Only for First Row: sub Header Height
            w_BlockHeight:=v_nHeaderHeight+v_nRecordHeight;
          else
            w_BlockHeight:=v_nRecordHeight;
          end if;
        end if;

        IF t_y-w_BlockHeight < get(c_get_margin_bottom)
        THEN                       -- outside bottom margin
        -- Drawing Around border
          DrawBorderAround(t_Frame_y, t_y, t_Frame_width);

          new_page;                -- New Page
          t_y:=t_yBegin;           -- Reset Y position
          IF v_nBreakHeight>0 THEN -- BreakBlock required
            show_Break;            -- Print BreakBlock
          END IF;
          show_header;             -- Print Header at beginning of alla pages
          t_Frame_y:=t_y;
          g_bForce :=true;
        ELSE
          IF v_nBreakHeight>0 THEN
            show_break;
            show_header;           -- Print Header after each BreakBlock
            t_Frame_y:=coalesce(t_Frame_y,t_y);
          ELSIF i=0 THEN
            show_header;           -- Print Header before first row
            t_Frame_y:=t_y;
          END IF;
          g_bForce:=true;
        END IF;
        show_record;
        n_oddLine:= case when n_oddLine=0 then 3 else 0 end; -- swap Odd-Even
      END LOOP;
      -- Draw Last Around Border
      DrawBorderAround(t_Frame_y, t_y, t_Frame_width);
    end if;
    g_y := t_y;
  end;

  -- Get N elemento from csv string
  function getNelemFromCSVString(v_vString in varchar2, v_nElem in number) return varchar2 is
    v_nStart number;
    v_nEnd   number;
  BEGIN
    v_nStart := nvl(instr(v_vString,',',1,v_nElem),0)+1; -- Firts char of elem
    v_nEnd := nvl(instr(v_vString,',',1,v_nElem+1),0);     -- Next comma 
    if v_nEnd=0 then                                     -- Retrieve length of Element
      v_nEnd:=length(v_vString)-v_nStart+1 ;
    else
      v_nEnd:=v_nEnd-v_nStart ;
    end if;  
    return(substr(v_vString,v_nStart, v_nEnd)) ;
  END;
    
  -- Trasform string with rgb color comma separated into table of varchar2
  -- 2015-05-10 Add defualt null
  function colorTable(p_vColors in varchar2 default null) return tp_colors is
    t_colors    tp_colors;
    i           pls_integer;
    v_vColors   varchar2(100);
    v_vColor    varchar2(6);
    v_vColorDef varchar2(6);
  BEGIN
    t_colors:=tp_colors('000000');
    t_colors.extend(9-t_colors.count);
    v_vColors:=replace(p_vColors,' ',''); -- Remove spaces

    for i in 1..9 loop
      case
        when i in (2,5) then
          v_vColorDef:='ffffff';
        when i>6 then
          v_vColorDef:=t_colors(i-3);
        else
          v_vColorDef:='000000';
      end case;
      v_vColor:=parseString(v_vColors,',');
      -- If isn't valid colour definition set v_vColor:='';
      if length(v_vColor) > 6 then -- Max 6 Char
        v_vColor:=v_vColorDef;
      else
      -- Only Hex char are allowed 
        if nvl(length(trim(translate(lower(v_vColor),'1234567890abcdef','                '))),0) >0 then
          v_vColor:=v_vColorDef;
        end if;
      end if;      
      --v_vColor:=nvl(v_vColor, getNelemFromCSVString(c_dft_colours,i) ); 
      
      t_colors(i):=coalesce(v_vColor, v_vColorDef);
    end loop;
    return t_colors;
  end;

-- 2015-05-10 Add nvl(p_colors, colorTable(null)) that set default colours when null
  PROCEDURE query2table
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
    )
  IS
    v_cx    INTEGER;
    v_dummy INTEGER;
    t_bulk_size  pls_integer;
  BEGIN
    v_cx := dbms_sql.open_cursor;
    dbms_sql.parse(v_cx, p_query, dbms_sql.native);
    v_dummy := dbms_sql.execute(v_cx);
    t_bulk_size:=p_bulk_size;
    if t_bulk_size=0 then
    -- Autodetect Buffer Size. Execute query 2 times
      execute immediate 'Select count(*) from ('||p_query||')' into t_bulk_size;
    end if;

    cursor2table(v_cx, p_formats, nvl(p_colors, colorTable(null)),
                 p_hRowheight, p_tRowheight, p_um, p_startX,
                 p_BreakField,  p_Interline, p_startY, p_Frame, t_bulk_size);
    dbms_sql.close_cursor(v_cx);
  END;

-- 2015-05-10 Add colorTable(nvl(p_colors, c_dft_colours)) that set default colours when null
  PROCEDURE query2table
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
    )
  IS
  BEGIN
    query2table(p_query, p_formats, colorTable(nvl(p_colors, c_dft_colours)),
                p_hRowHeight, p_tRowHeight, p_um,
                p_startX, p_BreakField, p_Interline, p_startY, p_Frame, p_bulk_size);
  END;

  procedure query2table
    ( p_query   varchar2
    , p_widths  tp_col_widths := null
    , p_headers tp_headers    := null
    )
  is
    i integer;
    t_columns tp_columns;
    t_widths_count  integer := 0;
    t_headers_count integer := 0;
  begin
    if p_widths is not null then
      t_widths_count := p_widths.count;
    end if;
    if p_headers is not null then
      t_headers_count := p_headers.count;
    end if;
        
    t_columns := tp_columns();
    t_columns.extend(greatest(t_widths_count, t_headers_count));
    
    if p_widths is not null then
      i := p_widths.first;
      while i is not null 
      loop
        t_columns(i).colWidth := p_widths(i);
        i := p_widths.next(i);
      end loop;
    end if;
    if p_headers is not null then
      i := p_headers.first;
      while i is not null 
      loop
        t_columns(i).colLabel := p_headers(i);
        i := p_headers.next(i);
      end loop;
    end if;
    
    query2table(p_query, t_columns, c_dft_colours);
  end;

-- 2015-05-10 Add nvl(p_colors, colorTable(null)) that set default colours when null
  PROCEDURE query2Labels
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
    )
  IS
    v_cx    INTEGER;
    v_dummy INTEGER;
  BEGIN
    v_cx := dbms_sql.open_cursor;
    dbms_sql.parse(v_cx, p_query, dbms_sql.native);
    v_dummy := dbms_sql.execute(v_cx);
  -- set global Record variable with Label definitions
    g_labeldef := p_labelDef;
    g_settings.LabelMode:=true;
    cursor2table(v_cx, p_formats, nvl(p_colors, colorTable(null)),
                 p_hRowheight, p_tRowheight, p_um,
                 p_startX, 0, p_Interline, p_startY, p_Frame, p_bulk_size);
    g_settings.LabelMode:=false;
    dbms_sql.close_cursor(v_cx);
  END;

-- 2015-05-10 Add colorTable(nvl(p_colors, c_dft_colours)) that set default colours when null
  PROCEDURE query2Labels
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
    )
  IS
  BEGIN
    query2Labels(p_query, p_formats, colorTable(nvl(p_colors, c_dft_colours)),
                 p_hRowHeight, p_tRowHeight, p_um,
                 p_startX, p_labelDef, p_Interline, p_startY, p_Frame, p_bulk_size);
  END;

-- Defined starting from ORACLE 11
$IF not DBMS_DB_VERSION.ver_le_10 $THEN
  PROCEDURE refcursor2table
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
    )
  IS
    v_cx INTEGER;
    v_rc SYS_REFCURSOR;
  BEGIN
    v_rc := p_rc;
    v_cx := dbms_sql.to_cursor_number(v_rc);
    cursor2table(v_cx, p_formats, p_colors, p_hRowHeight, p_tRowHeight, p_um,
                 p_startX, p_BreakField, p_Interline, p_startY, p_Frame, p_bulk_size);
    dbms_sql.close_cursor(v_cx);
  END;

  PROCEDURE refcursor2table
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
    )
  IS
  BEGIN
    refcursor2table(p_rc, p_formats, colorTable(nvl(p_colors, c_dft_colours)),
                    p_hRowHeight, p_tRowHeight, p_um,
                    p_startX, p_BreakField, p_Interline, p_startY, p_Frame, p_bulk_size);
  END;
  
  procedure refcursor2table
    ( p_rc      sys_refcursor
    , p_widths  tp_col_widths := null
    , p_headers tp_headers    := null
    )
  is
    i integer;
    t_columns tp_columns;
    t_widths_count  integer := 0;
    t_headers_count integer := 0;
  begin
    if p_widths is not null then
      t_widths_count := p_widths.count;
    end if;
    if p_headers is not null then
      t_headers_count := p_headers.count;
    end if;
        
    t_columns := tp_columns();
    t_columns.extend(greatest(t_widths_count, t_headers_count));
    
    if p_widths is not null then
      i := p_widths.first;
      while i is not null 
      loop
        t_columns(i).colWidth := p_widths(i);
        i := p_widths.next(i);
      end loop;
    end if;
    if p_headers is not null then
      i := p_headers.first;
      while i is not null 
      loop
        t_columns(i).colLabel := p_headers(i);
        i := p_headers.next(i);
      end loop;
    end if;
    
    refcursor2table(p_rc, t_columns, c_dft_colours);
  end;

  PROCEDURE refcursor2label
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
    )
  IS
    v_cx INTEGER;
    v_rc SYS_REFCURSOR;
  BEGIN
    v_rc := p_rc;
    v_cx := dbms_sql.to_cursor_number(v_rc);
    g_labeldef := p_labelDef;
    g_settings.LabelMode:=true;
    cursor2table(v_cx, p_formats, p_colors, p_hRowHeight, p_tRowHeight, p_um, p_startX, 0, p_Interline, p_startY, p_Frame, p_bulk_size);
    g_settings.LabelMode:=false;
    dbms_sql.close_cursor(v_cx);
  END;
  
  PROCEDURE refcursor2label
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
    )
  IS
  BEGIN
    refcursor2label(p_rc, p_formats, colorTable(nvl(p_colors, c_dft_colours)),
                    p_hRowHeight, p_tRowHeight, p_um,
                    p_startX, p_labelDef, p_Interline, p_startY, p_Frame, p_bulk_size);
  END;
$END
--
  PROCEDURE PR_GOTO_PAGE(i_nPage IN NUMBER) IS
  BEGIN
    IF i_nPage<=g_pages.count THEN
      g_page_nr:=i_nPage-1;
    END IF;
  END;

  PROCEDURE PR_GOTO_CURRENT_PAGE IS
  BEGIN
    g_page_nr:=NULL;
  END;

  PROCEDURE PR_LINE(i_nX1         IN NUMBER,
                    i_nY1         IN NUMBER,
                    i_nX2         IN NUMBER,
                    i_nY2         IN NUMBER,
                    i_vcLineColor IN VARCHAR2 DEFAULT NULL,
                    i_nLineWidth  IN NUMBER DEFAULT 0.5,
                    i_vcStroke    IN VARCHAR2 DEFAULT NULL
                   ) IS
  BEGIN
    txt2page('q ' );
    txt2page(to_char_round(i_nLineWidth, 5 ) || ' w' );
    IF SUBSTR(i_vcLineColor, -6 ) != '000000' THEN
      set_bk_color(i_vcLineColor);
    ELSE
      txt2page( '0 g' );
    END IF;

    txt2page('n ');
    IF i_vcStroke IS NOT NULL THEN
      txt2page(i_vcStroke || ' d ');
    END IF;
    txt2page(to_char_round(i_nX1, 5) || ' ' || to_char_round(i_nY1, 5) || ' m ');
    txt2page(to_char_round(i_nX2, 5) || ' ' || to_char_round(i_nY2, 5) || ' l S Q');
  END;

  PROCEDURE PR_POLYGON(i_lXs         IN tVertices,
                       i_lYs         IN tVertices,
                       i_vcLineColor IN VARCHAR2 DEFAULT NULL,
                       i_vcFillColor IN VARCHAR2 DEFAULT NULL,
                       i_nLineWidth  IN NUMBER DEFAULT 0.5
                      ) IS
    vcBuffer VARCHAR2(32767);
  BEGIN
    IF i_lXs.COUNT>0 AND i_lXs.COUNT=i_lYs.COUNT THEN
      txt2page('q ' );
      IF SUBSTR(i_vcLineColor, -6 ) != SUBSTR(i_vcFillColor, -6 ) THEN
        txt2page( to_char_round(i_nLineWidth, 5 ) || ' w' );
      END IF;
      IF SUBSTR(i_vcLineColor, -6 ) != '000000' THEN
        set_bk_color(i_vcLineColor);
      ELSE
        txt2page( '0 g' );
      END IF;
      IF i_vcFillColor IS NOT NULL THEN
        set_color(i_vcFillColor);
      END IF;
      txt2page(' 2.00000 M ');
      txt2page('n ');

      vcBuffer:=to_char_round(i_lXs(1), 5) || ' ' || to_char_round(i_lYs(1), 5) || ' m ';
      FOR i IN 2..i_lXs.COUNT LOOP
        vcBuffer:=vcBuffer || to_char_round(i_lXs(i), 5) || ' ' || to_char_round(i_lYs(i), 5) || ' l ';
      END LOOP;
      vcBuffer:=vcBuffer || to_char_round(i_lXs(1), 5) || ' ' || to_char_round(i_lYs(1), 5) || ' l ';
      vcBuffer:=vcBuffer || CASE WHEN i_vcFillColor IS NULL THEN
                               'S'
                            ELSE CASE WHEN i_vcLineColor IS NULL THEN
                                   'f'
                                 ELSE
                                   'b'
                                 END
                            END;

      txt2page( vcBuffer || ' Q' );
    END IF;
  END;

  PROCEDURE PR_PATH(i_lPath       IN tPath,
                    i_vcLineColor IN VARCHAR2 DEFAULT NULL,
                    i_vcFillColor IN VARCHAR2 DEFAULT NULL,
                    i_nLineWidth  IN NUMBER DEFAULT 0.5
                   ) IS
    vcBuffer VARCHAR2(32767);
  BEGIN
    txt2page('q ' );

    IF SUBSTR(i_vcLineColor, -6) != SUBSTR(i_vcFillColor, -6) THEN
      txt2page(to_char_round(i_nLineWidth, 5) || ' w' );
    END IF;
    IF SUBSTR(i_vcLineColor, -6) != '000000' THEN
      set_bk_color(i_vcLineColor);
    ELSE
      txt2page('0 g');
    END IF;
    IF i_vcFillColor IS NOT NULL THEN
      set_color(i_vcFillColor);
    END IF;

    txt2page('n ');
    FOR i IN 1..i_lPath.COUNT LOOP
      IF i_lPath(i).nType=PATH_MOVE_TO THEN
        vcBuffer:=vcBuffer|| to_char_round( i_lPath(i).nVal1, 5 ) || ' ' ||
                             to_char_round( i_lPath(i).nVal2, 5 ) || ' m ';
      ELSIF i_lPath(i).nType=PATH_LINE_TO THEN
        vcBuffer:=vcBuffer || to_char_round( i_lPath(i).nVal1, 5 ) || ' ' ||
                              to_char_round( i_lPath(i).nVal2, 5 ) || ' l ';
      ELSIF i_lPath(i).nType=PATH_CURVE_TO THEN
        vcBuffer:=vcBuffer || to_char_round( i_lPath(i).nVal1,5)  || ' ' ||
                              to_char_round( i_lPath(i).nVal2,5)  || ' ' ||
                              to_char_round( i_lPath(i).nVal3,5)  || ' ' ||
                              to_char_round( i_lPath(i).nVal4,5)  || ' ' ||
                              to_char_round( i_lPath(i).nVal5,5)  || ' ' ||
                              to_char_round( i_lPath(i).nVal6,5)  || ' c ';
      ELSIF i_lPath(i).nType=PATH_CLOSE THEN
        vcBuffer:=vcBuffer || CASE WHEN i_vcFillColor IS NULL THEN
                                'S'
                               ELSE CASE WHEN i_vcLineColor IS NULL THEN
                                      'f'
                                    ELSE
                                      'b'
                                    END
                               END;
      END IF;
    END LOOP;

    txt2page( vcBuffer || ' Q' );
  END;
--
begin
  for i in 0..255 loop
    lHex(TO_CHAR(i, 'FM0X')):=i;
  end loop;
end;
/
