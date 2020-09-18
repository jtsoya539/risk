UPDATE t_sistemas
   SET fecha_actual = trunc(SYSDATE)
 WHERE id_sistema = 'RISK';
