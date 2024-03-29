PL/SQL Developer Test script 3.0
22
DECLARE
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
  IF l_html LIKE '%<html>%<title>Hello</title>%<h1>Hello</h1>%</html>%' THEN
    :RESULT := 'OK';
  END IF;

  ROLLBACK;
END;
1
result
1
OK
5
0
