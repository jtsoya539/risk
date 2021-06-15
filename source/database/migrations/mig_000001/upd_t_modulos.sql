UPDATE t_modulos
   SET fecha_actual = trunc(SYSDATE)
 WHERE id_modulo = 'RISK';
