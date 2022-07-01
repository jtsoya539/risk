PL/SQL Developer Test script 3.0
5
BEGIN
  -- Call the function
  :RESULT := k_cadena.f_valor_posicion(i_cadena   => :i_cadena,
                                       i_posicion => :i_posicion);
END;
3
result
1
hola-que-tal-como-estas-chau
5
i_cadena
1
hola-que-tal-como-estas-chau
5
i_posicion
1
3
4
0
