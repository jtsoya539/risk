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

  l_varchar2(1) :=q'!501!';
  l_clob(2) :=q'!M!';
  l_clob(3) :=q'!SESIONES_FINALIZADAS!';
  l_clob(4) :=q'!AUT!';
  l_clob(5) :=q'!S!';
  l_clob(6) :=q'!Sesiones finalizadas!';
  l_clob(7) :=q'!0.1.0!';
  l_varchar2(8) :=q'!1!';
  l_clob(9) :=q'!!';
  l_clob(10) :=q'!B!';

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

  l_varchar2(1) :=q'!501!';
  l_clob(2) :=q'!ACCESS_TOKEN!';
  l_clob(3) :=q'!0.1.0!';
  l_varchar2(4) :=q'!1!';
  l_clob(5) :=q'!S!';
  l_clob(6) :=q'!S!';
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

  l_varchar2(1) :=q'!501!';
  l_clob(2) :=q'!La sesión queda en Activo posiblemente por un crash o por una finalización tratada incorrectamente.!';
  l_clob(3) :=q'!SELECT se.id_usuario,
       us.alias,
       se.id_dispositivo,
       se.access_token
  FROM t_sesiones se, t_usuarios us
 WHERE se.id_usuario = us.id_usuario
   AND se.estado = 'A'
   AND se.id_dispositivo IS NOT NULL
   AND se.id_sesion <
       (SELECT MAX(ses.id_sesion)
          FROM t_sesiones ses
         WHERE ses.id_usuario = se.id_usuario
           AND ses.estado = 'A'
           AND ses.id_dispositivo = se.id_dispositivo)
 ORDER BY se.id_usuario!';
  l_clob(4) :=q'!!';
  l_varchar2(5) :=q'!3!';
  l_varchar2(6) :=q'!1!';
  l_varchar2(7) :=q'!!';
  l_varchar2(8) :=q'!0!';
  l_clob(9) :=q'!D!';
  l_clob(10) :=q'!!';
  l_clob(11) :=q'!DECLARE
  l_access_token t_sesiones.access_token%TYPE;
BEGIN
  l_rsp.lugar    := 'Obteniendo parámetros';
  l_access_token := k_operacion.f_valor_parametro_string(l_parametros,
                                                         'access_token');

  l_rsp.lugar := 'Validando parámetros';
  k_operacion.p_validar_parametro(l_rsp,
                                  l_access_token IS NOT NULL,
                                  'Debe ingresar access_token');

  l_rsp.lugar := 'Finalizando sesiones de usuario';
  k_sesion.p_cambiar_estado(i_access_token => l_access_token,
                            i_estado       => 'F');

  k_operacion.p_respuesta_ok(l_rsp);
EXCEPTION
  WHEN k_operacion.ex_error_parametro THEN
    NULL;
  WHEN k_operacion.ex_error_general THEN
    NULL;
  WHEN OTHERS THEN
    k_operacion.p_respuesta_excepcion(l_rsp,
                                      utl_call_stack.error_number(1),
                                      utl_call_stack.error_msg(1),
                                      dbms_utility.format_error_stack);
END;!';

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
    ,"BLOQUE_PLSQL"
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
    ,l_clob(11)
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
