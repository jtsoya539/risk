set define off
declare
  type   t_clob is table of clob index by binary_integer;
  l_clob t_clob;
  type   t_varchar2 is table of varchar2(64) index by binary_integer;
  l_varchar2 t_varchar2;
  l_blob     blob;
  FUNCTION base64decode(p_clob CLOB)
    RETURN BLOB
  -- -----------------------------------------------------------------------------------
  -- File Name    : https://oracle-base.com/dba/miscellaneous/base64decode.sql
  -- Author       : Tim Hall
  -- Description  : Decodes a Base64 CLOB into a BLOB
  -- Last Modified: 09/11/2011
  -- -----------------------------------------------------------------------------------
  IS
    l_blob    BLOB;
    l_raw     RAW(32767);
    l_amt     NUMBER := 7700;
    l_offset  NUMBER := 1;
    l_temp    VARCHAR2(32767);
  BEGIN
    BEGIN
      DBMS_LOB.createtemporary (l_blob, FALSE, DBMS_LOB.CALL);
      LOOP
        DBMS_LOB.read(p_clob, l_amt, l_offset, l_temp);
        l_offset := l_offset + l_amt;
        l_raw    := UTL_ENCODE.base64_decode(UTL_RAW.cast_to_raw(l_temp));
        DBMS_LOB.append (l_blob, TO_BLOB(l_raw));
      END LOOP;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        NULL;
    END;
    RETURN l_blob;
  END;
begin

  null;
  -- start generation of records
  -----------------------------------

  l_clob(1) :=q'!T_USUARIOS!';
  l_clob(2) :=q'!AVATAR!';
  l_clob(3) :=q'!demouser!';
  l_clob(4) :=q'!!';
  l_blob :=empty_blob();
  l_clob(4) :=l_clob(4) || q'!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!';
  l_blob :=utl_compress.lz_uncompress(base64decode(l_clob(4)));
  l_clob(5) :=q'!!';
  l_clob(6) :=q'!36B77A4CBB148A934845EA569155CD023083FD77!';
  l_varchar2(7) :=q'!5192!';
  l_clob(8) :=q'!avatar!';
  l_clob(9) :=q'!png!';
  l_varchar2(10) :=q'!!';


  insert into t_archivos
  (
     "TABLA"
    ,"CAMPO"
    ,"REFERENCIA"
    ,"CONTENIDO"
    ,"URL"
    ,"CHECKSUM"
    ,"TAMANO"
    ,"NOMBRE"
    ,"EXTENSION"
    ,"VERSION_ACTUAL"
  )
  values
  (
     to_char(l_clob(1))
    ,to_char(l_clob(2))
    ,to_char(l_clob(3))
    ,l_blob
    ,to_char(l_clob(5))
    ,to_char(l_clob(6))
    ,to_number(l_varchar2(7))
    ,to_char(l_clob(8))
    ,to_char(l_clob(9))
    ,to_number(l_varchar2(10))
  );

end;
/
