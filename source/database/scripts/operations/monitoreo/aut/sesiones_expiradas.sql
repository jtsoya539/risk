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

  l_varchar2(1) :=q'!502!';
  l_clob(2) :=q'!M!';
  l_clob(3) :=q'!SESIONES_EXPIRADAS!';
  l_clob(4) :=q'!AUT!';
  l_clob(5) :=q'!S!';
  l_clob(6) :=q'!Sesiones expiradas!';
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

  l_varchar2(1) :=q'!502!';
  l_clob(2) :=q'!ID_USUARIO!';
  l_clob(3) :=q'!0.1.0!';
  l_varchar2(4) :=q'!1!';
  l_clob(5) :=q'!S!';
  l_clob(6) :=q'!N!';
  l_clob(7) :=q'!!';
  l_varchar2(8) :=q'!!';
  l_clob(9) :=q'!S!';
  l_clob(10) :=q'!!';
  l_clob(11) :=q'!!';
  l_clob(12) :=q'!!';
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

  l_varchar2(1) :=q'!502!';
  l_clob(2) :=q'!La sesión queda en Activo a menos que haya un intento y detecte que ya expiró.!';
  l_clob(3) :=q'!SELECT se.id_usuario, us.alias, COUNT(se.access_token) sesiones
  FROM t_sesiones se, t_usuarios us
 WHERE se.id_usuario = us.id_usuario
   AND se.fecha_expiracion_access_token < SYSDATE
   AND se.estado = 'A'
 GROUP BY se.id_usuario, us.alias
 ORDER BY se.id_usuario!';
  l_clob(4) :=q'!!';
  l_varchar2(5) :=q'!5!';
  l_varchar2(6) :=q'!1!';
  l_varchar2(7) :=q'!!';
  l_varchar2(8) :=q'!0!';
  l_clob(9) :=q'!D!';
  l_clob(10) :=q'!!';

  insert into t_monitoreos
  (
     "ID_MONITOREO"
    ,"CAUSA"
    ,"CONSULTA_SQL"
    ,"PLAN_ACCION"
    ,"PRIORIDAD"
    ,"ID_ROL_RESPONSABLE"
    ,"ID_USUARIO_RESPONSABLE"
    ,"NIVEL_AVISO"
    ,"FRECUENCIA"
    ,"COMENTARIOS"
  )
  values
  (
     to_number(l_varchar2(1))
    ,to_char(l_clob(2))
    ,l_clob(3)
    ,to_char(l_clob(4))
    ,to_number(l_varchar2(5))
    ,to_number(l_varchar2(6))
    ,to_number(l_varchar2(7))
    ,to_number(l_varchar2(8))
    ,to_char(l_clob(9))
    ,to_char(l_clob(10))
  );

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
