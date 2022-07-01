PL/SQL Developer Test script 3.0
6
BEGIN
  -- Call the function
  :RESULT := k_cadena.f_valor_posicion(i_cadena    => :i_cadena,
                                       i_posicion  => :i_posicion,
                                       i_separador => :i_separador);
END;
4
result
1
tal
5
i_cadena
1
hola-que-tal-como-estas-chau
5
i_posicion
1
3
4
i_separador
1
-
5
0
