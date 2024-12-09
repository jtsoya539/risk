CREATE OR REPLACE PACKAGE test_k_html IS

  --%suite(Tests unitarios del paquete k_html)
  --%tags(package)

  --%context(Tests unitarios de f_html)
  --%name(f_html)

  --%test()
  PROCEDURE f_html;
  --%endcontext

END;
/
CREATE OR REPLACE PACKAGE BODY test_k_html IS

  PROCEDURE f_html IS
    l_html CLOB;
  BEGIN
    -- Arrange
    k_html.p_inicializar;
    htp.htmlopen; -- generates <HTML>
    htp.headopen; -- generates <HEAD>
    htp.title('Hello'); -- generates <TITLE>Hello</TITLE>
    htp.headclose; -- generates </HEAD>
    htp.bodyopen; -- generates <BODY>
    htp.header(1, 'Hello'); -- generates <H1>Hello</H1>
    htp.bodyclose; -- generates </BODY>
    htp.htmlclose; -- generates </HTML>
    -- Act
    l_html := k_html.f_html;
    -- Assert
    ut.expect(l_html).to_be_like('%<html>%<title>Hello</title>%<h1>Hello</h1>%</html>%');
  END;

END;
/
