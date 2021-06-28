/* ==================== T_OPERACIONES ==================== */
set define off
declare
  type   t_clob is table of clob index by binary_integer;
  l_clob t_clob;
  type   t_varchar2 is table of varchar2(64) index by binary_integer;
  l_varchar2 t_varchar2;
begin

  null;
  -- start generation of records
  -----------------------------------

  l_varchar2(1) :=q'!1000!';
  l_clob(2) :=q'!P!';
  l_clob(3) :=q'!PARAMETROS_AUTOMATICOS!';
  l_clob(4) :=q'!!';
  l_clob(5) :=q'!S!';
  l_clob(6) :=q'!Parámetros automáticos!';
  l_clob(7) :=q'!0.1.0!';
  l_varchar2(8) :=q'!0!';
  l_clob(9) :=q'!!';

  insert into t_operaciones
  (
     "ID_OPERACION"
    ,"TIPO"
    ,"NOMBRE"
    ,"DOMINIO"
    ,"ACTIVO"
    ,"DETALLE"
    ,"VERSION_ACTUAL"
    ,"NIVEL_LOG"
    ,"PARAMETROS_AUTOMATICOS"
  )
  values
  (
     to_number(l_varchar2(1))
    ,to_char(l_clob(2))
    ,to_char(l_clob(3))
    ,to_char(l_clob(4))
    ,to_char(l_clob(5))
    ,to_char(l_clob(6))
    ,to_char(l_clob(7))
    ,to_number(l_varchar2(8))
    ,to_char(l_clob(9))
  );

end;
/
/* ==================== T_OPERACION_PARAMETROS ==================== */
set define off
declare
  type   t_clob is table of clob index by binary_integer;
  l_clob t_clob;
  type   t_varchar2 is table of varchar2(64) index by binary_integer;
  l_varchar2 t_varchar2;
begin

  null;
  -- start generation of records
  -----------------------------------

  l_varchar2(1) :=q'!1000!';
  l_clob(2) :=q'!PAGINA_PARAMETROS!';
  l_clob(3) :=q'!0.1.0!';
  l_varchar2(4) :=q'!100!';
  l_clob(5) :=q'!S!';
  l_clob(6) :=q'!O!';
  l_clob(7) :=q'!Y_PAGINA_PARAMETROS!';
  l_varchar2(8) :=q'!!';
  l_clob(9) :=q'!N!';
  l_clob(10) :=q'!{}!';
  l_clob(11) :=q'!!';
  l_clob(12) :=q'!Parámetros para paginación de elementos!';
  l_clob(13) :=q'!!';

  insert into t_operacion_parametros
  (
     "ID_OPERACION"
    ,"NOMBRE"
    ,"VERSION"
    ,"ORDEN"
    ,"ACTIVO"
    ,"TIPO_DATO"
    ,"FORMATO"
    ,"LONGITUD_MAXIMA"
    ,"OBLIGATORIO"
    ,"VALOR_DEFECTO"
    ,"ETIQUETA"
    ,"DETALLE"
    ,"VALORES_POSIBLES"
  )
  values
  (
     to_number(l_varchar2(1))
    ,to_char(l_clob(2))
    ,to_char(l_clob(3))
    ,to_number(l_varchar2(4))
    ,to_char(l_clob(5))
    ,to_char(l_clob(6))
    ,to_char(l_clob(7))
    ,to_number(l_varchar2(8))
    ,to_char(l_clob(9))
    ,to_char(l_clob(10))
    ,to_char(l_clob(11))
    ,to_char(l_clob(12))
    ,to_char(l_clob(13))
  );

  l_varchar2(1) :=q'!1000!';
  l_clob(2) :=q'!FORMATO!';
  l_clob(3) :=q'!0.1.0!';
  l_varchar2(4) :=q'!101!';
  l_clob(5) :=q'!S!';
  l_clob(6) :=q'!S!';
  l_clob(7) :=q'!!';
  l_varchar2(8) :=q'!4!';
  l_clob(9) :=q'!N!';
  l_clob(10) :=q'!PDF!';
  l_clob(11) :=q'!!';
  l_clob(12) :=q'!Formato de salida de reporte!';
  l_clob(13) :=q'!!';

  insert into t_operacion_parametros
  (
     "ID_OPERACION"
    ,"NOMBRE"
    ,"VERSION"
    ,"ORDEN"
    ,"ACTIVO"
    ,"TIPO_DATO"
    ,"FORMATO"
    ,"LONGITUD_MAXIMA"
    ,"OBLIGATORIO"
    ,"VALOR_DEFECTO"
    ,"ETIQUETA"
    ,"DETALLE"
    ,"VALORES_POSIBLES"
  )
  values
  (
     to_number(l_varchar2(1))
    ,to_char(l_clob(2))
    ,to_char(l_clob(3))
    ,to_number(l_varchar2(4))
    ,to_char(l_clob(5))
    ,to_char(l_clob(6))
    ,to_char(l_clob(7))
    ,to_number(l_varchar2(8))
    ,to_char(l_clob(9))
    ,to_char(l_clob(10))
    ,to_char(l_clob(11))
    ,to_char(l_clob(12))
    ,to_char(l_clob(13))
  );

end;
/
/* ==================== T_SERVICIOS ==================== */
set define off
declare
  type   t_clob is table of clob index by binary_integer;
  l_clob t_clob;
  type   t_varchar2 is table of varchar2(64) index by binary_integer;
  l_varchar2 t_varchar2;
begin

  null;
  -- start generation of records
  -----------------------------------

end;
/
/* ==================== T_REPORTES ==================== */
set define off
declare
  type   t_clob is table of clob index by binary_integer;
  l_clob t_clob;
  type   t_varchar2 is table of varchar2(64) index by binary_integer;
  l_varchar2 t_varchar2;
begin

  null;
  -- start generation of records
  -----------------------------------

end;
/
/* ==================== T_TRABAJOS ==================== */
set define off
declare
  type   t_clob is table of clob index by binary_integer;
  l_clob t_clob;
  type   t_varchar2 is table of varchar2(64) index by binary_integer;
  l_varchar2 t_varchar2;
begin

  null;
  -- start generation of records
  -----------------------------------

end;
/
/* ==================== T_ROL_PERMISOS ==================== */
set define off
declare
  type   t_clob is table of clob index by binary_integer;
  l_clob t_clob;
  type   t_varchar2 is table of varchar2(64) index by binary_integer;
  l_varchar2 t_varchar2;
begin

  null;
  -- start generation of records
  -----------------------------------

end;
/
