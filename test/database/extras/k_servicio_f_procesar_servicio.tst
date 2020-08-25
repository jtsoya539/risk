PL/SQL Developer Test script 3.0
15
DECLARE
  l_rsp_clob CLOB;
  l_rsp_json json_object_t;
BEGIN
  l_rsp_clob  := k_servicio.f_procesar_servicio(i_id_servicio => :i_id_servicio,
                                                i_parametros  => :i_parametros,
                                                i_contexto    => :i_contexto);
  :o_rsp_clob := l_rsp_clob;

  l_rsp_json    := json_object_t.parse(l_rsp_clob);
  :o_codigo     := l_rsp_json.get_string('codigo');
  :o_mensaje    := l_rsp_json.get_string('mensaje');
  :o_mensaje_bd := l_rsp_json.get_string('mensaje_bd');
  :o_lugar      := l_rsp_json.get_string('lugar');
END;
8
i_id_servicio
1
13
4
i_parametros
1
{}
5
i_contexto
1
{}
5
o_rsp_clob
1
<CLOB>
4208
o_codigo
1
0
5
o_mensaje
1
OK
5
o_mensaje_bd
0
5
o_lugar
0
5
0
