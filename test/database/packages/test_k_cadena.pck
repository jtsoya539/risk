CREATE OR REPLACE PACKAGE test_k_cadena IS

  --%suite(Tests unitarios del paquete k_cadena)
  --%tags(package)

  --%context(Tests unitarios de f_valor_posicion)
  --%name(f_valor_posicion)

  --%test()
  PROCEDURE f_valor_posicion_separador_por_defecto;
  --%test()
  PROCEDURE f_valor_posicion_separador_un_caracter;
  --%test()
  PROCEDURE f_valor_posicion_separador_varios_caracteres;
  --%test()
  PROCEDURE f_valor_posicion_fuera_de_rango_mayor;
  --%test()
  PROCEDURE f_valor_posicion_fuera_de_rango_menor;
  --%endcontext

  --%context(Tests unitarios de f_reemplazar_acentos)
  --%name(f_reemplazar_acentos)

  --%test()
  PROCEDURE f_reemplazar_acentos_uso_basico;
  --%endcontext

  --%context(Tests unitarios de f_formatear_titulo)
  --%name(f_formatear_titulo)

  --%test(Formateo básico de título)
  PROCEDURE f_formatear_titulo_uso_basico;
  --%endcontext

END;
/
CREATE OR REPLACE PACKAGE BODY test_k_cadena IS

  PROCEDURE f_valor_posicion_separador_por_defecto IS
  BEGIN
    ut.expect(k_cadena.f_valor_posicion('hola-que-tal-como-estas-chau', 3)).to_equal('hola-que-tal-como-estas-chau');
  END;

  PROCEDURE f_valor_posicion_separador_un_caracter IS
  BEGIN
    ut.expect(k_cadena.f_valor_posicion('hola-que-tal-como-estas-chau',
                                        3,
                                        '-')).to_equal('tal');
  END;

  PROCEDURE f_valor_posicion_separador_varios_caracteres IS
  BEGIN
    ut.expect(k_cadena.f_valor_posicion('hola/*/que/*/tal/*/como/*/estas/*/chau',
                                        3,
                                        '/*/')).to_equal('tal');
  END;

  PROCEDURE f_valor_posicion_fuera_de_rango_mayor IS
  BEGIN
    ut.expect(k_cadena.f_valor_posicion('hola-que-tal-como-estas-chau',
                                        100,
                                        '-')).to_equal('chau');
  END;

  PROCEDURE f_valor_posicion_fuera_de_rango_menor IS
  BEGIN
    ut.expect(k_cadena.f_valor_posicion('hola-que-tal-como-estas-chau',
                                        0,
                                        '-')).to_equal('hola');
  END;

  PROCEDURE f_reemplazar_acentos_uso_basico IS
  BEGIN
    ut.expect(k_cadena.f_reemplazar_acentos('La cigüeña tocaba el saxofón detrás del palenque de paja')).to_equal('La cigueña tocaba el saxofon detras del palenque de paja');
  END;

  PROCEDURE f_formatear_titulo_uso_basico IS
  BEGIN
    ut.expect(k_cadena.f_formatear_titulo('ESte eS UN títULO DE pruEba srl')).to_equal('Este Es Un Título de Prueba SRL');
  END;

END;
/
