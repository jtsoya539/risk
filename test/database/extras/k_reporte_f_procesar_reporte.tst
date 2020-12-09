PL/SQL Developer Test script 3.0
22
DECLARE
  l_rsp_clob CLOB;
  l_rsp_json json_object_t;
  l_archivo  y_archivo;
BEGIN
  l_rsp_clob  := k_reporte.f_procesar_reporte(i_id_reporte => :i_id_reporte,
                                              i_parametros => :i_parametros,
                                              i_contexto   => :i_contexto);
  :o_rsp_clob := l_rsp_clob;

  l_rsp_json    := json_object_t.parse(l_rsp_clob);
  :o_codigo     := l_rsp_json.get_string('codigo');
  :o_mensaje    := l_rsp_json.get_string('mensaje');
  :o_mensaje_bd := l_rsp_json.get_string('mensaje_bd');
  :o_lugar      := l_rsp_json.get_string('lugar');

  IF NOT l_rsp_json.get('datos').is_null THEN
    l_archivo    := treat(y_archivo.parse_json(l_rsp_json.get_object('datos').to_clob) AS
                          y_archivo);
    :o_contenido := l_archivo.contenido;
  END IF;
END;
9
i_id_reporte
1
20
4
i_parametros
1
{"formato":"PDF"}
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
o_contenido
1
<BLOB>
4209
0
