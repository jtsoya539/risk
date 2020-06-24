FUNCTION &nombre_servicio(i_parametros IN y_parametros) RETURN y_respuesta IS
  l_rsp  y_respuesta;
  l_dato y_dato;
BEGIN
  -- Inicializa respuesta
  l_rsp  := NEW y_respuesta();
  l_dato := NEW y_dato();

  l_rsp.lugar := 'Validando parámetros';
  /* TODO: text="Implementar validación de parámetros" */
  k_servicio.p_validar_parametro(l_rsp,
                                 anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                     'nombre_parametro')) IS NOT NULL,
                                 'Debe ingresar nombre_parametro');

  l_rsp.lugar := 'Procesando servicio';
  /* TODO: text="Implementar proceso del servicio" */
  [ # ]
  
  k_servicio.p_respuesta_ok(l_rsp, l_dato);
  RETURN l_rsp;
EXCEPTION
  WHEN k_servicio.ex_error_parametro THEN
    RETURN l_rsp;
  WHEN k_servicio.ex_error_general THEN
    RETURN l_rsp;
  WHEN OTHERS THEN
    k_servicio.p_respuesta_excepcion(l_rsp,
                                     utl_call_stack.error_number(1),
                                     utl_call_stack.error_msg(1),
                                     dbms_utility.format_error_stack);
    RETURN l_rsp;
END;
