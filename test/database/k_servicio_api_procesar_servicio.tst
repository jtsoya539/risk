PL/SQL Developer Test script 3.0
12
DECLARE
  l_rsp_clob CLOB;
  l_rsp_json json_object_t;
BEGIN
  l_rsp_clob    := k_servicio.api_procesar_servicio(i_id_servicio => :i_id_servicio,
                                                    i_parametros  => :i_parametros);
  l_rsp_json    := json_object_t.parse(l_rsp_clob);
  :o_codigo     := l_rsp_json.get_string('codigo');
  :o_mensaje    := l_rsp_json.get_string('mensaje');
  :o_mensaje_bd := l_rsp_json.get_string('mensaje_bd');
  :o_lugar      := l_rsp_json.get_string('lugar');
END;
6
i_id_servicio
1
4
4
i_parametros
1
{"usuario":"jmeza","clave":"123456"}
5
o_codigo
1
999
5
o_mensaje
1
Usuario ya existe
5
o_mensaje_bd
1
ORA-20000: Usuario ya existe
5
o_lugar
1
Registrando usuario
5
0
