CREATE OR REPLACE PACKAGE k_html IS

  /*
  --------------------------------- MIT License ---------------------------------
  Copyright (c) 2019 jtsoya539
  
  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:
  
  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.
  
  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
  -------------------------------------------------------------------------------
  */

  -- Agrupa operaciones relacionadas con la generacion de HTML.
  -- %author jtsoya539

  FUNCTION f_documento RETURN CLOB;

  FUNCTION f_escapar_texto(i_texto IN VARCHAR2) RETURN VARCHAR2;

  PROCEDURE p_inicializar(i_contenido IN VARCHAR2 DEFAULT NULL);

  PROCEDURE p_reemplazar(i_de IN VARCHAR2,
                         i_a  IN VARCHAR2);

  PROCEDURE p_escapar;

  PROCEDURE p_agregar(i_contenido IN VARCHAR2);

  PROCEDURE p_agregar_linea(i_contenido IN VARCHAR2);

  PROCEDURE p_agregar_css(i_href IN VARCHAR2);

  PROCEDURE p_agregar_js(i_src IN VARCHAR2);

  PROCEDURE p_agregar_comentario(i_comentario IN VARCHAR2);

  FUNCTION f_a(i_contenido IN VARCHAR2,
               i_href      IN VARCHAR2,
               i_target    IN VARCHAR2 DEFAULT NULL,
               i_title     IN VARCHAR2 DEFAULT NULL,
               i_download  IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2;

  FUNCTION f_em(i_contenido IN VARCHAR2) RETURN VARCHAR2;

  FUNCTION f_strong(i_contenido IN VARCHAR2) RETURN VARCHAR2;

  FUNCTION f_b(i_contenido IN VARCHAR2) RETURN VARCHAR2;

  FUNCTION f_i(i_contenido IN VARCHAR2) RETURN VARCHAR2;

  FUNCTION f_u(i_contenido IN VARCHAR2) RETURN VARCHAR2;

  FUNCTION f_br RETURN VARCHAR2;

  PROCEDURE p_br;

  PROCEDURE p_hr;

  PROCEDURE p_title(i_contenido IN VARCHAR2);

  PROCEDURE p_h1(i_contenido IN VARCHAR2);

  PROCEDURE p_h2(i_contenido IN VARCHAR2);

  PROCEDURE p_h3(i_contenido IN VARCHAR2);

  PROCEDURE p_h4(i_contenido IN VARCHAR2);

  PROCEDURE p_h5(i_contenido IN VARCHAR2);

  PROCEDURE p_h6(i_contenido IN VARCHAR2);

  PROCEDURE p_p(i_contenido IN VARCHAR2);

  PROCEDURE p_a(i_contenido IN VARCHAR2,
                i_href      IN VARCHAR2,
                i_target    IN VARCHAR2 DEFAULT NULL,
                i_title     IN VARCHAR2 DEFAULT NULL,
                i_download  IN VARCHAR2 DEFAULT NULL);

  PROCEDURE p_span(i_contenido IN VARCHAR2);

  PROCEDURE p_script(i_contenido  IN VARCHAR2,
                     i_comentario IN VARCHAR2 DEFAULT NULL);

  PROCEDURE p_html_abrir(i_lang IN VARCHAR2 DEFAULT NULL);

  PROCEDURE p_html_cerrar;

  PROCEDURE p_head_abrir(i_title       IN VARCHAR2 DEFAULT NULL,
                         i_author      IN VARCHAR2 DEFAULT NULL,
                         i_description IN VARCHAR2 DEFAULT NULL);

  PROCEDURE p_head_cerrar;

  PROCEDURE p_body_abrir;

  PROCEDURE p_body_cerrar;

  PROCEDURE p_main_abrir;

  PROCEDURE p_main_cerrar;

  PROCEDURE p_header_abrir;

  PROCEDURE p_header_cerrar;

  PROCEDURE p_footer_abrir;

  PROCEDURE p_footer_cerrar;

  PROCEDURE p_article_abrir;

  PROCEDURE p_article_cerrar;

  PROCEDURE p_section_abrir;

  PROCEDURE p_section_cerrar;

  PROCEDURE p_nav_abrir;

  PROCEDURE p_nav_cerrar;

  PROCEDURE p_aside_abrir;

  PROCEDURE p_aside_cerrar;

  PROCEDURE p_div_abrir;

  PROCEDURE p_div_cerrar;

END;
/
CREATE OR REPLACE PACKAGE BODY k_html IS

  g_documento CLOB;

  c_crlf CONSTANT VARCHAR2(2) := unistr('\000D\000A');

  FUNCTION f_documento RETURN CLOB IS
  BEGIN
    RETURN g_documento;
  END;

  FUNCTION f_escapar_texto(i_texto IN VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(i_texto,
                                                   '&',
                                                   '&' || 'amp;'),
                                           '''',
                                           '&' || 'apos;'),
                                   '"',
                                   '&' || 'quot;'),
                           '>',
                           '&' || 'gt;'),
                   '<',
                   '&' || 'lt;');
  END;

  PROCEDURE p_inicializar(i_contenido IN VARCHAR2 DEFAULT NULL) IS
  BEGIN
    g_documento := nvl(i_contenido, '');
  END;

  PROCEDURE p_reemplazar(i_de IN VARCHAR2,
                         i_a  IN VARCHAR2) IS
  BEGIN
    g_documento := REPLACE(g_documento, i_de, i_a);
  END;

  PROCEDURE p_escapar IS
  BEGIN
    p_reemplazar('Á', '&' || 'Aacute;');
    p_reemplazar('É', '&' || 'Eacute;');
    p_reemplazar('Í', '&' || 'Iacute;');
    p_reemplazar('Ó', '&' || 'Oacute;');
    p_reemplazar('Ú', '&' || 'Uacute;');
    p_reemplazar('Ñ', '&' || 'Ntilde;');
    p_reemplazar('á', '&' || 'aacute;');
    p_reemplazar('é', '&' || 'eacute;');
    p_reemplazar('í', '&' || 'iacute;');
    p_reemplazar('ó', '&' || 'oacute;');
    p_reemplazar('ú', '&' || 'uacute;');
    p_reemplazar('ñ', '&' || 'ntilde;');
  END;

  PROCEDURE p_agregar(i_contenido IN VARCHAR2) IS
  BEGIN
    g_documento := g_documento || i_contenido;
  END;

  PROCEDURE p_agregar_linea(i_contenido IN VARCHAR2) IS
  BEGIN
    g_documento := g_documento || i_contenido || c_crlf;
  END;

  PROCEDURE p_agregar_css(i_href IN VARCHAR2) IS
  BEGIN
    p_agregar_linea('<link rel="stylesheet" href="' ||
                    utl_url.escape(i_href) || '">');
  END;

  PROCEDURE p_agregar_js(i_src IN VARCHAR2) IS
  BEGIN
    p_agregar_linea('<script src="' || utl_url.escape(i_src) ||
                    '"></script>');
  END;

  PROCEDURE p_agregar_comentario(i_comentario IN VARCHAR2) IS
  BEGIN
    p_agregar_linea('<!-- ' || i_comentario || ' -->');
  END;

  FUNCTION f_a(i_contenido IN VARCHAR2,
               i_href      IN VARCHAR2,
               i_target    IN VARCHAR2 DEFAULT NULL,
               i_title     IN VARCHAR2 DEFAULT NULL,
               i_download  IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2 IS
  BEGIN
    RETURN '<a href="' || utl_url.escape(i_href) || '"' || CASE WHEN i_target IS NOT NULL THEN ' target="' || i_target || '"' ELSE '' END || CASE WHEN i_title IS NOT NULL THEN ' title="' || i_title || '"' ELSE '' END || CASE WHEN i_download IS NOT NULL THEN ' download="' || i_download || '"' ELSE '' END || '>' || i_contenido || '</a>';
  END;

  FUNCTION f_em(i_contenido IN VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN '<em>' || i_contenido || '</em>';
  END;

  FUNCTION f_strong(i_contenido IN VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN '<strong>' || i_contenido || '</strong>';
  END;

  FUNCTION f_b(i_contenido IN VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN '<b>' || i_contenido || '</b>';
  END;

  FUNCTION f_i(i_contenido IN VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN '<i>' || i_contenido || '</i>';
  END;

  FUNCTION f_u(i_contenido IN VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN '<u>' || i_contenido || '</u>';
  END;

  FUNCTION f_br RETURN VARCHAR2 IS
  BEGIN
    RETURN '<br>';
  END;

  PROCEDURE p_br IS
  BEGIN
    p_agregar_linea('<br>');
  END;

  PROCEDURE p_hr IS
  BEGIN
    p_agregar_linea('<hr>');
  END;

  PROCEDURE p_title(i_contenido IN VARCHAR2) IS
  BEGIN
    p_agregar_linea('<title>' || i_contenido || '</title>');
  END;

  PROCEDURE p_h1(i_contenido IN VARCHAR2) IS
  BEGIN
    p_agregar_linea('<h1>' || i_contenido || '</h1>');
  END;

  PROCEDURE p_h2(i_contenido IN VARCHAR2) IS
  BEGIN
    p_agregar_linea('<h2>' || i_contenido || '</h2>');
  END;

  PROCEDURE p_h3(i_contenido IN VARCHAR2) IS
  BEGIN
    p_agregar_linea('<h3>' || i_contenido || '</h3>');
  END;

  PROCEDURE p_h4(i_contenido IN VARCHAR2) IS
  BEGIN
    p_agregar_linea('<h4>' || i_contenido || '</h4>');
  END;

  PROCEDURE p_h5(i_contenido IN VARCHAR2) IS
  BEGIN
    p_agregar_linea('<h5>' || i_contenido || '</h5>');
  END;

  PROCEDURE p_h6(i_contenido IN VARCHAR2) IS
  BEGIN
    p_agregar_linea('<h6>' || i_contenido || '</h6>');
  END;

  PROCEDURE p_p(i_contenido IN VARCHAR2) IS
  BEGIN
    p_agregar_linea('<p>' || i_contenido || '</p>');
  END;

  PROCEDURE p_a(i_contenido IN VARCHAR2,
                i_href      IN VARCHAR2,
                i_target    IN VARCHAR2 DEFAULT NULL,
                i_title     IN VARCHAR2 DEFAULT NULL,
                i_download  IN VARCHAR2 DEFAULT NULL) IS
  BEGIN
    p_agregar_linea(f_a(i_contenido, i_href, i_target, i_title, i_download));
  END;

  PROCEDURE p_span(i_contenido IN VARCHAR2) IS
  BEGIN
    p_agregar_linea('<span>' || i_contenido || '</span>');
  END;

  PROCEDURE p_script(i_contenido  IN VARCHAR2,
                     i_comentario IN VARCHAR2 DEFAULT NULL) IS
  BEGIN
    IF i_comentario IS NOT NULL THEN
      p_agregar_comentario(i_comentario);
    END IF;
    p_agregar_linea('<script>');
    p_agregar_linea(i_contenido);
    p_agregar_linea('</script>');
  END;

  PROCEDURE p_html_abrir(i_lang IN VARCHAR2 DEFAULT NULL) IS
  BEGIN
    p_agregar_linea('<!DOCTYPE html>');
    p_agregar_linea('<html lang="' || nvl(i_lang, 'es') || '">');
  END;

  PROCEDURE p_html_cerrar IS
  BEGIN
    p_agregar_linea('</html>');
  END;

  PROCEDURE p_head_abrir(i_title       IN VARCHAR2 DEFAULT NULL,
                         i_author      IN VARCHAR2 DEFAULT NULL,
                         i_description IN VARCHAR2 DEFAULT NULL) IS
  BEGIN
    p_agregar_linea('<head>');
    p_agregar_linea('<meta charset="utf-8">');
    IF i_author IS NOT NULL THEN
      p_agregar_linea('<meta name="author" content="' || i_author || '">');
    END IF;
    IF i_description IS NOT NULL THEN
      p_agregar_linea('<meta name="description" content="' ||
                      i_description || '">');
    END IF;
    IF i_title IS NOT NULL THEN
      p_title(i_title);
    END IF;
  END;

  PROCEDURE p_head_cerrar IS
  BEGIN
    p_agregar_linea('</head>');
  END;

  PROCEDURE p_body_abrir IS
  BEGIN
    p_agregar_linea('<body>');
  END;

  PROCEDURE p_body_cerrar IS
  BEGIN
    p_agregar_linea('</body>');
  END;

  PROCEDURE p_main_abrir IS
  BEGIN
    p_agregar_linea('<main>');
  END;

  PROCEDURE p_main_cerrar IS
  BEGIN
    p_agregar_linea('</main>');
  END;

  PROCEDURE p_header_abrir IS
  BEGIN
    p_agregar_linea('<header>');
  END;

  PROCEDURE p_header_cerrar IS
  BEGIN
    p_agregar_linea('</header>');
  END;

  PROCEDURE p_footer_abrir IS
  BEGIN
    p_agregar_linea('<footer>');
  END;

  PROCEDURE p_footer_cerrar IS
  BEGIN
    p_agregar_linea('</footer>');
  END;

  PROCEDURE p_article_abrir IS
  BEGIN
    p_agregar_linea('<article>');
  END;

  PROCEDURE p_article_cerrar IS
  BEGIN
    p_agregar_linea('</article>');
  END;

  PROCEDURE p_section_abrir IS
  BEGIN
    p_agregar_linea('<section>');
  END;

  PROCEDURE p_section_cerrar IS
  BEGIN
    p_agregar_linea('</section>');
  END;

  PROCEDURE p_nav_abrir IS
  BEGIN
    p_agregar_linea('<nav>');
  END;

  PROCEDURE p_nav_cerrar IS
  BEGIN
    p_agregar_linea('</nav>');
  END;

  PROCEDURE p_aside_abrir IS
  BEGIN
    p_agregar_linea('<aside>');
  END;

  PROCEDURE p_aside_cerrar IS
  BEGIN
    p_agregar_linea('</aside>');
  END;

  PROCEDURE p_div_abrir IS
  BEGIN
    p_agregar_linea('<div>');
  END;

  PROCEDURE p_div_cerrar IS
  BEGIN
    p_agregar_linea('</div>');
  END;

END;
/
