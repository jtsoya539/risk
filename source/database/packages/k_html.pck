CREATE OR REPLACE PACKAGE k_html IS

  -- Agrupa operaciones relacionadas con la generacion de HTML.
  -- %author jtsoya539

  l_salto VARCHAR2(2) := chr(10);

  PROCEDURE p_inicializa(p_contenido IN VARCHAR2 DEFAULT l_salto);

  PROCEDURE p_inicializa(p_contenido IN CLOB DEFAULT l_salto);

  PROCEDURE p_agrega(p_contenido IN VARCHAR2);

  PROCEDURE p_agrega(p_contenido IN CLOB);

  PROCEDURE p_reemplaza(p_de IN VARCHAR2,
                        p_a  IN VARCHAR2);

  PROCEDURE p_formatea;

  PROCEDURE p_convierte_string;

  FUNCTION f_resultado RETURN CLOB;

  PROCEDURE p_agrega_comentario(p_comentario IN VARCHAR2);

  PROCEDURE p_agrega_script(p_contenido  IN VARCHAR2,
                            p_comentario IN VARCHAR2 DEFAULT NULL);

END;
/

CREATE OR REPLACE PACKAGE BODY k_html IS

  l_resultado          CLOB;
  l_resultado_anterior CLOB;

  PROCEDURE p_inicializa(p_contenido IN VARCHAR2 DEFAULT l_salto) IS
  BEGIN
    l_resultado          := p_contenido;
    l_resultado_anterior := '';
  END;

  PROCEDURE p_inicializa(p_contenido IN CLOB DEFAULT l_salto) IS
  BEGIN
    l_resultado          := p_contenido;
    l_resultado_anterior := '';
  END;

  PROCEDURE p_agrega(p_contenido IN VARCHAR2) IS
  BEGIN
    IF length(l_resultado) > 30000 THEN
      l_resultado_anterior := l_resultado_anterior || l_resultado;
      l_resultado          := '';
    END IF;
    l_resultado := l_resultado || p_contenido || l_salto;
  END;

  PROCEDURE p_agrega(p_contenido IN CLOB) IS
  BEGIN
    IF length(l_resultado) > 30000 THEN
      l_resultado_anterior := l_resultado_anterior || l_resultado;
      l_resultado          := '';
    END IF;
    l_resultado := l_resultado || p_contenido || l_salto;
  END;

  PROCEDURE p_reemplaza(p_de IN VARCHAR2,
                        p_a  IN VARCHAR2) IS
  BEGIN
    l_resultado := REPLACE(l_resultado_anterior || l_resultado, p_de, p_a);
  END;

  PROCEDURE p_formatea IS
  BEGIN
    p_reemplaza('Á', '&' || 'Aacute;');
    p_reemplaza('É', '&' || 'Eacute;');
    p_reemplaza('Í', '&' || 'Iacute;');
    p_reemplaza('Ó', '&' || 'Oacute;');
    p_reemplaza('Ú', '&' || 'Uacute;');
    p_reemplaza('Ñ', '&' || 'Ntilde;');
    p_reemplaza('á', '&' || 'aacute;');
    p_reemplaza('é', '&' || 'eacute;');
    p_reemplaza('í', '&' || 'iacute;');
    p_reemplaza('ó', '&' || 'oacute;');
    p_reemplaza('ú', '&' || 'uacute;');
    p_reemplaza('ñ', '&' || 'ntilde;');
  END;

  PROCEDURE p_convierte_string IS
  BEGIN
    p_reemplaza('"', '\"');
    p_reemplaza(chr(10), '\n" + "');
  END;

  FUNCTION f_resultado RETURN CLOB IS
  BEGIN
    RETURN l_resultado_anterior || l_resultado;
  END;

  PROCEDURE p_agrega_comentario(p_comentario IN VARCHAR2) IS
  BEGIN
    p_agrega('<!-- ' || p_comentario || ' -->');
  END;

  PROCEDURE p_agrega_script(p_contenido  IN VARCHAR2,
                            p_comentario IN VARCHAR2 DEFAULT NULL) IS
  BEGIN
    IF p_comentario IS NOT NULL THEN
      p_agrega_comentario(p_comentario);
    END IF;
    p_agrega('<script>');
    p_agrega(p_contenido);
    p_agrega('</script>');
  END;

END;
/

