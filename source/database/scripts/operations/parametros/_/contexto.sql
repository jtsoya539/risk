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

  l_varchar2(1) :=q'!1001!';
  l_clob(2) :=q'!P!';
  l_clob(3) :=q'!CONTEXTO!';
  l_clob(4) :=q'!!';
  l_clob(5) :=q'!S!';
  l_clob(6) :=q'!Par�metros de contexto de la ejecuci�n!';
  l_clob(7) :=q'!0.1.0!';
  l_varchar2(8) :=q'!0!';
  l_clob(9) :=q'!!';
  l_clob(10) :=q'!K!';

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
    ,"TIPO_IMPLEMENTACION"
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
    ,to_char(l_clob(10))
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

  l_varchar2(1) :=q'!1001!';
  l_clob(2) :=q'!DIRECCION_IP!';
  l_clob(3) :=q'!0.1.0!';
  l_varchar2(4) :=q'!1!';
  l_clob(5) :=q'!S!';
  l_clob(6) :=q'!S!';
  l_clob(7) :=q'!!';
  l_varchar2(8) :=q'!!';
  l_clob(9) :=q'!N!';
  l_clob(10) :=q'!!';
  l_clob(11) :=q'!!';
  l_clob(12) :=q'!Direcci�n IP del origen de la ejecuci�n!';
  l_clob(13) :=q'!!';
  l_clob(14) :=q'!N!';

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
    ,"ENCRIPTADO"
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
    ,to_char(l_clob(14))
  );

  l_varchar2(1) :=q'!1001!';
  l_clob(2) :=q'!CLAVE_APLICACION!';
  l_clob(3) :=q'!0.1.0!';
  l_varchar2(4) :=q'!2!';
  l_clob(5) :=q'!S!';
  l_clob(6) :=q'!S!';
  l_clob(7) :=q'!!';
  l_varchar2(8) :=q'!!';
  l_clob(9) :=q'!N!';
  l_clob(10) :=q'!!';
  l_clob(11) :=q'!!';
  l_clob(12) :=q'!Clave de la aplicaci�n origen de la ejecuci�n!';
  l_clob(13) :=q'!!';
  l_clob(14) :=q'!N!';

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
    ,"ENCRIPTADO"
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
    ,to_char(l_clob(14))
  );

  l_varchar2(1) :=q'!1001!';
  l_clob(2) :=q'!ACCESS_TOKEN!';
  l_clob(3) :=q'!0.1.0!';
  l_varchar2(4) :=q'!3!';
  l_clob(5) :=q'!S!';
  l_clob(6) :=q'!S!';
  l_clob(7) :=q'!!';
  l_varchar2(8) :=q'!!';
  l_clob(9) :=q'!N!';
  l_clob(10) :=q'!!';
  l_clob(11) :=q'!!';
  l_clob(12) :=q'!Access Token de la sesi�n!';
  l_clob(13) :=q'!!';
  l_clob(14) :=q'!N!';

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
    ,"ENCRIPTADO"
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
    ,to_char(l_clob(14))
  );

  l_varchar2(1) :=q'!1001!';
  l_clob(2) :=q'!USUARIO!';
  l_clob(3) :=q'!0.1.0!';
  l_varchar2(4) :=q'!4!';
  l_clob(5) :=q'!S!';
  l_clob(6) :=q'!S!';
  l_clob(7) :=q'!!';
  l_varchar2(8) :=q'!!';
  l_clob(9) :=q'!N!';
  l_clob(10) :=q'!!';
  l_clob(11) :=q'!!';
  l_clob(12) :=q'!Usuario de la sesi�n!';
  l_clob(13) :=q'!!';
  l_clob(14) :=q'!N!';

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
    ,"ENCRIPTADO"
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
    ,to_char(l_clob(14))
  );

  l_varchar2(1) :=q'!1001!';
  l_clob(2) :=q'!TOKEN_DISPOSITIVO!';
  l_clob(3) :=q'!0.1.0!';
  l_varchar2(4) :=q'!5!';
  l_clob(5) :=q'!S!';
  l_clob(6) :=q'!S!';
  l_clob(7) :=q'!!';
  l_varchar2(8) :=q'!!';
  l_clob(9) :=q'!N!';
  l_clob(10) :=q'!!';
  l_clob(11) :=q'!!';
  l_clob(12) :=q'!Token del dispositivo origen de la ejecuci�n!';
  l_clob(13) :=q'!!';
  l_clob(14) :=q'!N!';

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
    ,"ENCRIPTADO"
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
    ,to_char(l_clob(14))
  );

  l_varchar2(1) :=q'!1001!';
  l_clob(2) :=q'!ID_EJECUCION!';
  l_clob(3) :=q'!0.1.0!';
  l_varchar2(4) :=q'!6!';
  l_clob(5) :=q'!S!';
  l_clob(6) :=q'!S!';
  l_clob(7) :=q'!!';
  l_varchar2(8) :=q'!!';
  l_clob(9) :=q'!N!';
  l_clob(10) :=q'!!';
  l_clob(11) :=q'!!';
  l_clob(12) :=q'!Identificador de la ejecuci�n!';
  l_clob(13) :=q'!!';
  l_clob(14) :=q'!N!';

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
    ,"ENCRIPTADO"
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
    ,to_char(l_clob(14))
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
/* ==================== T_MONITOREOS ==================== */
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
