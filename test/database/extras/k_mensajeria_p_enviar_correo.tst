PL/SQL Developer Test script 3.0
48
DECLARE
  -- Non-scalar parameters require additional processing 
  i_adjuntos y_archivos;
  l_archivo  y_archivo;
BEGIN
  i_adjuntos := NEW y_archivos();

  l_archivo           := NEW y_archivo();
  l_archivo.contenido := k_util.clob_to_blob('Este es un archivo de texto 1');
  l_archivo.nombre    := 'prueba1';
  l_archivo.extension := 'txt';
  k_archivo.p_calcular_propiedades(l_archivo.contenido,
                                   l_archivo.checksum,
                                   l_archivo.tamano);
  i_adjuntos.extend;
  i_adjuntos(i_adjuntos.count) := l_archivo;
  --
  l_archivo           := NEW y_archivo();
  l_archivo.contenido := k_util.clob_to_blob('Este es un archivo de texto 2');
  l_archivo.nombre    := 'prueba2';
  l_archivo.extension := 'txt';
  k_archivo.p_calcular_propiedades(l_archivo.contenido,
                                   l_archivo.checksum,
                                   l_archivo.tamano);
  i_adjuntos.extend;
  i_adjuntos(i_adjuntos.count) := l_archivo;
  --
  l_archivo           := NEW y_archivo();
  l_archivo.contenido := k_util.clob_to_blob('Este es un archivo de texto 3');
  l_archivo.nombre    := 'prueba3';
  l_archivo.extension := 'txt';
  k_archivo.p_calcular_propiedades(l_archivo.contenido,
                                   l_archivo.checksum,
                                   l_archivo.tamano);
  i_adjuntos.extend;
  i_adjuntos(i_adjuntos.count) := l_archivo;

  -- Call the procedure
  k_mensajeria.p_enviar_correo(i_subject         => :i_subject,
                               i_body            => :i_body,
                               i_id_usuario      => :i_id_usuario,
                               i_to              => :i_to,
                               i_reply_to        => :i_reply_to,
                               i_cc              => :i_cc,
                               i_bcc             => :i_bcc,
                               i_adjuntos        => i_adjuntos,
                               i_prioridad_envio => :i_prioridad_envio);
END;
8
i_subject
1
Asunto de prueba
5
i_body
1
Mensaje de prueba
5
i_id_usuario
0
4
i_to
1
demouser@risk.com
5
i_reply_to
0
5
i_cc
0
5
i_bcc
0
5
i_prioridad_envio
1
3
4
0
