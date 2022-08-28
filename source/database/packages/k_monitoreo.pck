CREATE OR REPLACE PACKAGE k_monitoreo IS

  /**
  Agrupa operaciones relacionadas con los Monitoreos de Conflictos del sistema
  
  %author dmezac 24/5/2022 10:42:26
  */

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

  -- Constantes
  c_id_ejecucion CONSTANT VARCHAR2(50) := 'ID_EJECUCION';

  -- Excepciones
  ex_frecuencia_no_existe EXCEPTION;

  PROCEDURE p_limpiar_historial;

  PROCEDURE p_aviso_resumido(i_id_ejecucion IN NUMBER);

  PROCEDURE p_aviso_detallado(i_id_ejecucion IN NUMBER,
                              i_id_monitoreo IN NUMBER);

  FUNCTION f_pagina_parametros(i_parametros IN y_parametros)
    RETURN y_pagina_parametros;

  FUNCTION f_paginar_elementos(i_elementos           IN y_objetos,
                               i_numero_pagina       IN INTEGER DEFAULT NULL,
                               i_cantidad_por_pagina IN INTEGER DEFAULT NULL,
                               i_no_paginar          IN VARCHAR2 DEFAULT NULL)
    RETURN y_pagina;

  FUNCTION f_paginar_elementos(i_elementos         IN y_objetos,
                               i_pagina_parametros IN y_pagina_parametros)
    RETURN y_pagina;

  FUNCTION f_monitoreo_sql(i_id_monitoreo    IN NUMBER,
                           i_version         IN VARCHAR2 DEFAULT NULL,
                           o_tiene_conflicto OUT BOOLEAN) RETURN y_respuesta;

  FUNCTION f_monitoreo_columnas_sql(i_id_monitoreo IN NUMBER) RETURN CLOB;

  FUNCTION f_procesar_monitoreo(i_id_monitoreo IN NUMBER,
                                i_version      IN VARCHAR2 DEFAULT NULL)
    RETURN CLOB;

  FUNCTION f_procesar_monitoreo(i_nombre  IN VARCHAR2,
                                i_dominio IN VARCHAR2,
                                i_version IN VARCHAR2 DEFAULT NULL)
    RETURN CLOB;

  PROCEDURE p_procesar_monitoreos(i_frecuencia IN VARCHAR2 DEFAULT NULL);

END;
/
CREATE OR REPLACE PACKAGE BODY k_monitoreo IS

  c_table_template CONSTANT VARCHAR2(4000) := '<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html"/>
<xsl:template match="/">
<table style="border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%;" width="100%">
 <tr>
  <xsl:for-each select="/ROWSET/ROW[1]/*">
   <th style="font-family: sans-serif; font-size: 14px; vertical-align: top; text-align: left; padding: 8px;" valign="top" align="left"><xsl:if test="name() != ''PRIORIDAD''"><xsl:value-of select="name()"/></xsl:if></th>
  </xsl:for-each>
 </tr>
 <xsl:for-each select="/ROWSET/*">
 <xsl:variable name="var_size" select="2" />
  <tr>
   <xsl:variable name="var_pos" select="position()" />
   <xsl:variable name="var_mod" select="$var_pos mod($var_size)" />
   <xsl:if test="$var_mod = 1"><xsl:attribute name="bgcolor">#dddddd</xsl:attribute><xsl:attribute name="style">background-color: #dddddd;</xsl:attribute></xsl:if>
   <xsl:for-each select="./PRIORIDAD">
    <xsl:if test="text() = 1"><td><xsl:attribute name="bgcolor">#ee0000</xsl:attribute><xsl:attribute name="style">background-color: #ee0000; padding: 0px; width: 1px;</xsl:attribute><xsl:attribute name="width">1</xsl:attribute></td></xsl:if>
    <xsl:if test="text() = 2"><td><xsl:attribute name="bgcolor">#ff9900</xsl:attribute><xsl:attribute name="style">background-color: #ff9900; padding: 0px; width: 1px;</xsl:attribute><xsl:attribute name="width">1</xsl:attribute></td></xsl:if>
    <xsl:if test="text() = 3"><td><xsl:attribute name="bgcolor">#ffeb03</xsl:attribute><xsl:attribute name="style">background-color: #ffeb03; padding: 0px; width: 1px;</xsl:attribute><xsl:attribute name="width">1</xsl:attribute></td></xsl:if>
    <xsl:if test="text() = 4"><td><xsl:attribute name="bgcolor">#7bd849</xsl:attribute><xsl:attribute name="style">background-color: #7bd849; padding: 0px; width: 1px;</xsl:attribute><xsl:attribute name="width">1</xsl:attribute></td></xsl:if>
    <xsl:if test="text() = 5"><td><xsl:attribute name="bgcolor">#009900</xsl:attribute><xsl:attribute name="style">background-color: #009900; padding: 0px; width: 1px;</xsl:attribute><xsl:attribute name="width">1</xsl:attribute></td></xsl:if>
   </xsl:for-each>
   <xsl:for-each select="./*">
    <xsl:if test="name() != ''PRIORIDAD''"><td style="font-family: sans-serif; font-size: 14px; vertical-align: top; text-align: left; padding: 8px;" valign="top" align="left"><xsl:value-of select="text()"/></td></xsl:if>
   </xsl:for-each>
  </tr>
 </xsl:for-each>
</table>
  </xsl:template>
</xsl:stylesheet>';

  PROCEDURE lp_reservar_id_ejecucion IS
  BEGIN
    k_sistema.p_definir_parametro_number(c_id_ejecucion,
                                         s_id_monitoreo_ejecucion.nextval);
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  PROCEDURE lp_registrar_ejecucion(i_id_monitoreo IN NUMBER,
                                   i_datos        IN CLOB,
                                   i_conflicto    IN BOOLEAN) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    l_timestamp t_monitoreo_ejecuciones.fecha_ejecucion%TYPE := current_timestamp;
  BEGIN
    INSERT INTO t_monitoreo_ejecuciones
      (id_monitoreo_ejecucion, id_monitoreo, fecha_ejecucion, datos)
    VALUES
      (k_sistema.f_valor_parametro_number(c_id_ejecucion),
       i_id_monitoreo,
       l_timestamp,
       i_datos);
  
    IF i_conflicto THEN
      UPDATE t_monitoreos
         SET cantidad_ejecuciones             = nvl(cantidad_ejecuciones, 0) + 1,
             fecha_ultima_ejecucion           = l_timestamp,
             cantidad_ejecuciones_conflicto   = nvl(cantidad_ejecuciones_conflicto,
                                                    0) + 1,
             fecha_ultima_ejecucion_conflicto = l_timestamp
       WHERE id_monitoreo = i_id_monitoreo;
    ELSE
      UPDATE t_monitoreos
         SET cantidad_ejecuciones   = nvl(cantidad_ejecuciones, 0) + 1,
             fecha_ultima_ejecucion = l_timestamp
       WHERE id_monitoreo = i_id_monitoreo;
    END IF;
  
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      dbms_output.put_line('Error: ' || SQLERRM);
      ROLLBACK;
  END;

  FUNCTION lf_procesar_monitoreo(i_id_monitoreo    IN NUMBER,
                                 i_version         IN VARCHAR2 DEFAULT NULL,
                                 o_tiene_conflicto OUT BOOLEAN)
    RETURN y_respuesta IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    l_rsp               y_respuesta;
    l_nombre_monitoreo  t_operaciones.nombre%TYPE;
    l_dominio_monitoreo t_operaciones.dominio%TYPE;
    l_version_actual    t_operaciones.version_actual%TYPE;
  BEGIN
    -- Inicializa respuesta
    l_rsp := NEW y_respuesta();
  
    l_rsp.lugar := 'Buscando datos del monitoreo';
    BEGIN
      SELECT upper(o.nombre), upper(o.dominio), o.version_actual
        INTO l_nombre_monitoreo, l_dominio_monitoreo, l_version_actual
        FROM t_monitoreos m, t_operaciones o
       WHERE o.id_operacion = m.id_monitoreo
         AND o.activo = 'S'
         AND m.id_monitoreo = i_id_monitoreo;
    EXCEPTION
      WHEN no_data_found THEN
        k_operacion.p_respuesta_error(l_rsp,
                                      k_operacion.c_servicio_no_implementado,
                                      'Monitoreo inexistente o inactivo');
        RAISE k_operacion.ex_error_parametro;
    END;
  
    -- CONSULTA
    l_rsp := f_monitoreo_sql(i_id_monitoreo, i_version, o_tiene_conflicto);
  
    IF l_rsp.codigo = k_operacion.c_ok THEN
      COMMIT;
    ELSE
      RAISE k_operacion.ex_error_general;
    END IF;
  
    k_operacion.p_respuesta_ok(l_rsp, l_rsp.datos);
    RETURN l_rsp;
  EXCEPTION
    WHEN k_operacion.ex_error_parametro THEN
      RETURN l_rsp;
    WHEN k_operacion.ex_error_general THEN
      ROLLBACK;
      RETURN l_rsp;
    WHEN OTHERS THEN
      ROLLBACK;
      k_operacion.p_respuesta_excepcion(l_rsp,
                                        utl_call_stack.error_number(1),
                                        utl_call_stack.error_msg(1),
                                        dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  PROCEDURE p_limpiar_historial IS
  BEGIN
    UPDATE t_monitoreos
       SET cantidad_ejecuciones             = NULL,
           fecha_ultima_ejecucion           = NULL,
           cantidad_ejecuciones_conflicto   = NULL,
           fecha_ultima_ejecucion_conflicto = NULL;
  END;

  PROCEDURE p_aviso_resumido(i_id_ejecucion IN NUMBER) IS
    l_envia VARCHAR2(1) := 'N';
    l_body  CLOB;
    l_tabla CLOB;
  
    l_query VARCHAR2(2000) := 'WITH v_datos AS
 (SELECT d.id_monitoreo_ejecucion, d.id_monitoreo, d.mitigado
    FROM v_monitoreo_datos d, t_monitoreos m
   WHERE d.id_monitoreo = m.id_monitoreo
     AND m.nivel_aviso = 1
     AND d.id_monitoreo_ejecucion = &id_ejecucion
     AND d.cantidad_elementos > 0)
SELECT n.prioridad,
       m.id_monitoreo "Id",
       p.detalle "Descripcion",
       nvl(COUNT(m.mitigado), 0) "C.T.",
       SUM(CASE m.mitigado
             WHEN ''true'' THEN
              1
             ELSE
              0
           END) "C.M.",
       nvl(COUNT(m.mitigado), 0) - SUM(CASE m.mitigado
                                         WHEN ''true'' THEN
                                          1
                                         ELSE
                                          0
                                       END) "C.P."
  FROM v_datos m, t_monitoreos n, t_operaciones p
 WHERE m.id_monitoreo = n.id_monitoreo
   AND n.id_monitoreo = p.id_operacion
 GROUP BY n.prioridad, m.id_monitoreo, p.detalle, m.id_monitoreo_ejecucion';
  
  BEGIN
    --Verifica si hay datos a enviar
    BEGIN
      SELECT decode(nvl(COUNT(1), 0), 0, 'N', 'S') envia
        INTO l_envia
        FROM v_monitoreo_datos d, t_monitoreos m
       WHERE d.id_monitoreo = m.id_monitoreo
         AND m.nivel_aviso = 1
         AND d.id_monitoreo_ejecucion = i_id_ejecucion
         AND d.cantidad_elementos > 0;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    $if k_modulo.c_instalado_msj $then
    -- Arma el cuerpo de la tabla
    IF l_envia = 'S' THEN
      l_tabla := k_html.f_query2table(i_query    => REPLACE(l_query,
                                                            '&id_ejecucion',
                                                            i_id_ejecucion),
                                      i_template => c_table_template);
      -- Envía correo de monitoreo
      l_body := k_mensajeria.f_correo_tabla_html(i_tabla      => l_tabla,
                                                 i_titulo     => 'Monitoreo de Conflictos',
                                                 i_encabezado => 'Monitoreo de Conflictos',
                                                 i_pie        => '<b>C.T.</b> conflictos totales, <b>C.M.</b> conflictos mitigados, <b>C.P.</b> conflictos pendientes');
    
      IF k_mensajeria.f_enviar_correo('Monitoreo de Conflictos ' || '#' ||
                                      i_id_ejecucion,
                                      l_body,
                                      NULL,
                                      k_util.f_valor_parametro('DIRECCION_CORREO_MONITOREOS'),
                                      NULL,
                                      NULL,
                                      NULL,
                                      NULL,
                                      k_mensajeria.c_prioridad_importante) <>
         k_mensajeria.c_ok THEN
        dbms_output.put_line('Error en envio de monitoreo de conflictos resumido');
      END IF;
    END IF;
    $end
  
  END;

  PROCEDURE p_aviso_detallado(i_id_ejecucion IN NUMBER,
                              i_id_monitoreo IN NUMBER) IS
    l_envia        VARCHAR2(1) := 'N';
    l_body         CLOB;
    l_tabla        CLOB;
    l_tabla_causa  CLOB;
    l_tabla_accion CLOB;
  
    l_detalle t_operaciones.detalle%TYPE;
    l_query   VARCHAR2(2000) := 'SELECT j.*
  FROM t_monitoreo_ejecuciones d,
       json_table(d.datos,
                  ''$'' columns(NESTED path ''$.datos.elementos[*]''
                          columns(&columnas))) j
 WHERE d.id_monitoreo_ejecucion = &id_ejecucion
   AND d.id_monitoreo = &id_monitoreo';
  
    l_query_causa  VARCHAR2(2000) := 'SELECT nvl(REPLACE(a.causa, chr(10), ''*=*''), ''No definido'') "Causa"
  FROM t_monitoreos a
 WHERE a.id_monitoreo = &id_monitoreo';
    l_query_accion VARCHAR2(2000) := 'SELECT nvl(REPLACE(a.plan_accion, chr(10), ''*=*''), ''No definido'') "Plan de Acción"
  FROM t_monitoreos a
 WHERE a.id_monitoreo = &id_monitoreo';
  
  BEGIN
    --Verifica si hay datos a enviar
    BEGIN
      SELECT decode(nvl(COUNT(1), 0), 0, 'N', 'S') envia
        INTO l_envia
        FROM v_monitoreo_datos d, t_monitoreos m
       WHERE d.id_monitoreo = m.id_monitoreo
         AND m.nivel_aviso = 2
         AND d.id_monitoreo_ejecucion = i_id_ejecucion
         AND d.id_monitoreo = i_id_monitoreo
         AND d.cantidad_elementos > 0;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    $if k_modulo.c_instalado_msj $then
    IF l_envia = 'S' THEN
      -- Obtiene datos del monitoreo
      BEGIN
        SELECT o.detalle
          INTO l_detalle
          FROM t_monitoreos m, t_operaciones o
         WHERE o.id_operacion = m.id_monitoreo
           AND o.activo = 'S'
           AND m.id_monitoreo = i_id_monitoreo;
      END;
    
      l_query := REPLACE(l_query,
                         '&columnas',
                         f_monitoreo_columnas_sql(i_id_monitoreo));
      l_query := REPLACE(l_query, '&id_ejecucion', i_id_ejecucion);
      l_query := REPLACE(l_query, '&id_monitoreo', i_id_monitoreo);
    
      l_tabla := k_html.f_query2table(i_query    => l_query,
                                      i_template => c_table_template);
    
      l_tabla_causa := k_html.f_query2table(i_query    => REPLACE(l_query_causa,
                                                                  '&id_monitoreo',
                                                                  i_id_monitoreo),
                                            i_template => c_table_template);
    
      l_tabla_accion := k_html.f_query2table(i_query    => REPLACE(l_query_accion,
                                                                   '&id_monitoreo',
                                                                   i_id_monitoreo),
                                             i_template => c_table_template);
    
      -- Envía correo de monitoreo
      l_body := k_mensajeria.f_correo_tabla_aux_html(i_tabla       => l_tabla,
                                                     i_tabla_aux_1 => l_tabla_causa,
                                                     i_tabla_aux_2 => l_tabla_accion,
                                                     i_titulo      => l_detalle,
                                                     i_encabezado  => l_detalle);
      l_body := REPLACE(l_body, '_x0020_', ' ');
      l_body := REPLACE(l_body, '*=*', chr(10) || '<br>');
      --dbms_output.put_line(l_body);
    
      IF k_mensajeria.f_enviar_correo('Monitoreo de Conflictos ' || '#' ||
                                      i_id_ejecucion,
                                      l_body,
                                      NULL,
                                      k_util.f_valor_parametro('DIRECCION_CORREO_MONITOREOS'),
                                      NULL,
                                      NULL,
                                      NULL,
                                      NULL,
                                      k_mensajeria.c_prioridad_importante) <>
         k_mensajeria.c_ok THEN
        dbms_output.put_line('Error en envio de monitoreo de conflictos resumido');
      END IF;
    END IF;
    $end
  
  END;

  FUNCTION f_pagina_parametros(i_parametros IN y_parametros)
    RETURN y_pagina_parametros IS
  BEGIN
    RETURN nvl(treat(k_operacion.f_valor_parametro_object(i_parametros,
                                                          'pagina_parametros') AS
                     y_pagina_parametros),
               NEW y_pagina_parametros());
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NEW y_pagina_parametros();
  END;

  FUNCTION f_paginar_elementos(i_elementos           IN y_objetos,
                               i_numero_pagina       IN INTEGER DEFAULT NULL,
                               i_cantidad_por_pagina IN INTEGER DEFAULT NULL,
                               i_no_paginar          IN VARCHAR2 DEFAULT NULL)
    RETURN y_pagina IS
    l_pagina              y_pagina;
    l_objetos             y_objetos;
    l_numero_pagina       INTEGER;
    l_cantidad_por_pagina INTEGER;
    l_rango_i             INTEGER;
    l_rango_j             INTEGER;
    l_no_paginar          BOOLEAN;
  BEGIN
    -- Inicializa respuesta
    l_pagina                    := NEW y_pagina();
    l_pagina.numero_actual      := 0;
    l_pagina.numero_siguiente   := 0;
    l_pagina.numero_ultima      := 0;
    l_pagina.numero_primera     := 0;
    l_pagina.numero_anterior    := 0;
    l_pagina.cantidad_elementos := 0;
  
    l_no_paginar := nvl(i_no_paginar, 'N') = 'S';
  
    -- Carga la cantidad total de elementos
    l_pagina.cantidad_elementos := i_elementos.count;
    --
  
    -- Valida parámetro de cantidad por página
    IF l_no_paginar THEN
      l_cantidad_por_pagina := l_pagina.cantidad_elementos;
    ELSE
      l_cantidad_por_pagina := nvl(i_cantidad_por_pagina,
                                   to_number(k_util.f_valor_parametro('PAGINACION_CANTIDAD_DEFECTO_POR_PAGINA')));
    END IF;
  
    IF l_cantidad_por_pagina <= 0 THEN
      l_cantidad_por_pagina := to_number(k_util.f_valor_parametro('PAGINACION_CANTIDAD_DEFECTO_POR_PAGINA'));
    END IF;
  
    IF NOT l_no_paginar AND
       l_cantidad_por_pagina >
       to_number(k_util.f_valor_parametro('PAGINACION_CANTIDAD_MAXIMA_POR_PAGINA')) THEN
      l_cantidad_por_pagina := to_number(k_util.f_valor_parametro('PAGINACION_CANTIDAD_MAXIMA_POR_PAGINA'));
    END IF;
    --
  
    -- Calcula primera página y última página
    l_pagina.numero_ultima := ceil(l_pagina.cantidad_elementos /
                                   l_cantidad_por_pagina);
  
    IF l_pagina.numero_ultima > 0 THEN
      l_pagina.numero_primera := 1;
    END IF;
    --
  
    -- Valida parámetro de número de página
    l_numero_pagina := nvl(i_numero_pagina, 1);
  
    IF l_numero_pagina < l_pagina.numero_primera THEN
      l_numero_pagina := l_pagina.numero_primera;
    END IF;
  
    IF l_numero_pagina > l_pagina.numero_ultima THEN
      l_numero_pagina := l_pagina.numero_ultima;
    END IF;
    --
  
    -- Carga página actual
    l_pagina.numero_actual := l_numero_pagina;
    --
  
    -- Calcula página anterior y página siguiente
    l_pagina.numero_anterior  := l_pagina.numero_actual - 1;
    l_pagina.numero_siguiente := l_pagina.numero_actual + 1;
  
    IF l_pagina.numero_anterior < l_pagina.numero_primera THEN
      l_pagina.numero_anterior := l_pagina.numero_primera;
    END IF;
  
    IF l_pagina.numero_siguiente > l_pagina.numero_ultima THEN
      l_pagina.numero_siguiente := l_pagina.numero_ultima;
    END IF;
    --
  
    -- Calcula el rango de elementos
    l_rango_i := ((l_pagina.numero_actual - 1) * l_cantidad_por_pagina) + 1;
    l_rango_j := l_pagina.numero_actual * l_cantidad_por_pagina;
  
    IF l_rango_i < 0 THEN
      l_rango_i := 0;
    END IF;
  
    IF l_rango_j > l_pagina.cantidad_elementos THEN
      l_rango_j := l_pagina.cantidad_elementos;
    END IF;
    --
  
    -- Carga elementos dentro del rango
    l_objetos := NEW y_objetos();
    IF l_pagina.cantidad_elementos > 0 THEN
      FOR i IN l_rango_i .. l_rango_j LOOP
        l_objetos.extend;
        l_objetos(l_objetos.count) := i_elementos(i);
      END LOOP;
    END IF;
    l_pagina.elementos := l_objetos;
    --
  
    RETURN l_pagina;
  END;

  FUNCTION f_paginar_elementos(i_elementos         IN y_objetos,
                               i_pagina_parametros IN y_pagina_parametros)
    RETURN y_pagina IS
  BEGIN
    RETURN f_paginar_elementos(i_elementos,
                               i_pagina_parametros.pagina,
                               i_pagina_parametros.por_pagina,
                               i_pagina_parametros.no_paginar);
  END;

  FUNCTION f_monitoreo_sql(i_id_monitoreo    IN NUMBER,
                           i_version         IN VARCHAR2 DEFAULT NULL,
                           o_tiene_conflicto OUT BOOLEAN) RETURN y_respuesta IS
    l_rsp       y_respuesta;
    l_rsp_det   y_respuesta;
    l_prms      y_parametros;
    l_pagina    y_pagina;
    l_elementos y_objetos;
    l_elemento  y_dato;
  
    l_nombre_monitoreo    t_operaciones.nombre%TYPE;
    l_dominio_monitoreo   t_operaciones.dominio%TYPE;
    l_version_actual      t_operaciones.version_actual%TYPE;
    l_tipo_implementacion t_operaciones.tipo_implementacion%TYPE;
    l_consulta_sql        t_monitoreos.consulta_sql%TYPE;
    l_bloque_plsql        t_monitoreos.bloque_plsql%TYPE;
  
    l_sentencia VARCHAR2(4000);
  BEGIN
    -- Inicializa respuesta
    l_rsp             := NEW y_respuesta();
    l_elementos       := NEW y_objetos();
    o_tiene_conflicto := FALSE;
  
    l_rsp.lugar := 'Buscando datos del servicio';
    BEGIN
      SELECT upper(o.nombre),
             upper(o.dominio),
             o.version_actual,
             nvl(o.tipo_implementacion, 'K'),
             m.consulta_sql,
             m.bloque_plsql
        INTO l_nombre_monitoreo,
             l_dominio_monitoreo,
             l_version_actual,
             l_tipo_implementacion,
             l_consulta_sql,
             l_bloque_plsql
        FROM t_monitoreos m, t_operaciones o
       WHERE o.id_operacion = m.id_monitoreo
         AND o.activo = 'S'
         AND m.id_monitoreo = i_id_monitoreo;
    EXCEPTION
      WHEN no_data_found THEN
        k_operacion.p_respuesta_error(l_rsp,
                                      k_operacion.c_error_parametro,
                                      'Monitoreo inexistente o inactivo');
        RAISE k_operacion.ex_error_parametro;
    END;
  
    l_rsp.lugar := 'Validando parametros';
    IF l_consulta_sql IS NULL THEN
      k_operacion.p_respuesta_error(l_rsp,
                                    k_operacion.c_error_general,
                                    'Consulta SQL no definida');
      RAISE k_operacion.ex_error_parametro;
    END IF;
  
    -- ========================================================
    DECLARE
      l_cursor   PLS_INTEGER;
      l_row_cnt  PLS_INTEGER;
      l_col_cnt  PLS_INTEGER;
      l_desc_tab dbms_sql.desc_tab2;
      --
      l_buffer_varchar2  VARCHAR2(32767);
      l_buffer_number    NUMBER;
      l_buffer_date      DATE;
      l_buffer_timestamp TIMESTAMP;
      --
      l_json_object json_object_t;
    BEGIN
      l_cursor := dbms_sql.open_cursor;
      dbms_sql.parse(l_cursor, l_consulta_sql, dbms_sql.native);
      dbms_sql.describe_columns2(l_cursor, l_col_cnt, l_desc_tab);
    
      FOR i IN 1 .. l_col_cnt LOOP
        IF l_desc_tab(i).col_type IN (dbms_types.typecode_varchar,
                         dbms_types.typecode_varchar2,
                         dbms_types.typecode_char,
                         dbms_types.typecode_clob,
                         dbms_types.typecode_nvarchar2,
                         dbms_types.typecode_nchar,
                         dbms_types.typecode_nclob) THEN
          dbms_sql.define_column(l_cursor, i, l_buffer_varchar2, 32767);
        ELSIF l_desc_tab(i).col_type IN (dbms_types.typecode_number) THEN
          dbms_sql.define_column(l_cursor, i, l_buffer_number);
        ELSIF l_desc_tab(i).col_type IN (dbms_types.typecode_date) THEN
          dbms_sql.define_column(l_cursor, i, l_buffer_date);
        ELSIF l_desc_tab(i).col_type IN (dbms_types.typecode_timestamp) THEN
          dbms_sql.define_column(l_cursor, i, l_buffer_timestamp);
        END IF;
      END LOOP;
    
      l_row_cnt := dbms_sql.execute(l_cursor);
    
      LOOP
        EXIT WHEN dbms_sql.fetch_rows(l_cursor) = 0;
      
        l_json_object := NEW json_object_t();
      
        FOR i IN 1 .. l_col_cnt LOOP
          IF l_desc_tab(i)
           .col_type IN (dbms_types.typecode_varchar,
                           dbms_types.typecode_varchar2,
                           dbms_types.typecode_char,
                           dbms_types.typecode_clob,
                           dbms_types.typecode_nvarchar2,
                           dbms_types.typecode_nchar,
                           dbms_types.typecode_nclob) THEN
            dbms_sql.column_value(l_cursor, i, l_buffer_varchar2);
            l_json_object.put(lower(l_desc_tab(i).col_name),
                              l_buffer_varchar2);
          ELSIF l_desc_tab(i).col_type IN (dbms_types.typecode_number) THEN
            dbms_sql.column_value(l_cursor, i, l_buffer_number);
            l_json_object.put(lower(l_desc_tab(i).col_name),
                              l_buffer_number);
          ELSIF l_desc_tab(i).col_type IN (dbms_types.typecode_date) THEN
            dbms_sql.column_value(l_cursor, i, l_buffer_date);
            l_json_object.put(lower(l_desc_tab(i).col_name), l_buffer_date);
          ELSIF l_desc_tab(i).col_type IN (dbms_types.typecode_timestamp) THEN
            dbms_sql.column_value(l_cursor, i, l_buffer_timestamp);
            l_json_object.put(lower(l_desc_tab(i).col_name),
                              l_buffer_timestamp);
          END IF;
        END LOOP;
      
        l_elemento      := NEW y_dato();
        l_elemento.json := l_json_object.to_clob;
        --dbms_output.put_line(l_elemento.json);
      
        BEGIN
          -- Inicializa respuesta del conflicto
          l_rsp_det := NEW y_respuesta();
        
          l_rsp_det.lugar := 'Procesando parámetros del conflicto';
          BEGIN
            l_prms := k_operacion.f_procesar_parametros(i_id_monitoreo,
                                                        l_elemento.json,
                                                        nvl(i_version,
                                                            l_version_actual));
          EXCEPTION
            WHEN OTHERS THEN
              k_operacion.p_respuesta_error(l_rsp_det,
                                            k_operacion.c_error_parametro,
                                            CASE
                                            k_error.f_tipo_excepcion(utl_call_stack.error_number(1)) WHEN
                                            k_error.c_user_defined_error THEN
                                            utl_call_stack.error_msg(1) WHEN
                                            k_error.c_oracle_predefined_error THEN
                                            k_error.f_mensaje_error(k_operacion.c_error_parametro) END,
                                            dbms_utility.format_error_stack);
          END;
        
          l_rsp_det.lugar := 'Construyendo sentencia';
          IF l_tipo_implementacion = 'B' THEN
            l_bloque_plsql := 'DECLARE' || chr(10) ||
                              '  l_rsp        y_respuesta := NEW y_respuesta();' ||
                              chr(10) ||
                              '  l_parametros y_parametros := :1;' ||
                              chr(10) || 'BEGIN' || chr(10) ||
                              '  IF l_parametros.count > 0 THEN' || chr(10) ||
                              '    ' || l_bloque_plsql || ' ' || chr(10) ||
                              '  ELSE' || chr(10) ||
                              '    l_rsp.lugar := ''SIN PARÁMETROS'';' ||
                              chr(10) || '  END IF;' || chr(10) ||
                              '  :2 := l_rsp;' || chr(10) || 'END;';
          ELSE
            IF nvl(i_version, l_version_actual) = l_version_actual THEN
              l_sentencia := 'BEGIN :1 := K_MONITOREO_' ||
                             l_dominio_monitoreo || '.' ||
                             l_nombre_monitoreo || '(:2); END;';
            ELSE
              l_sentencia := 'BEGIN :1 := K_MONITOREO_' ||
                             l_dominio_monitoreo || '.' ||
                             l_nombre_monitoreo || '_' ||
                             REPLACE(i_version, '.', '_') || '(:2); END;';
            END IF;
          END IF;
        
          l_rsp_det.lugar := 'Mitigando conflicto';
          BEGIN
            IF l_tipo_implementacion = 'B' THEN
              EXECUTE IMMEDIATE l_bloque_plsql
                USING IN l_prms, OUT l_rsp_det;
            ELSE
              EXECUTE IMMEDIATE l_sentencia
                USING OUT l_rsp_det, IN l_prms;
            END IF;
          EXCEPTION
            WHEN k_operacion.ex_servicio_no_implementado THEN
              k_operacion.p_respuesta_error(l_rsp_det,
                                            k_operacion.c_servicio_no_implementado,
                                            'Mitigación de conflicto no implementada',
                                            dbms_utility.format_error_stack);
            WHEN OTHERS THEN
              k_operacion.p_respuesta_error(l_rsp_det,
                                            k_operacion.c_error_general,
                                            CASE
                                            k_error.f_tipo_excepcion(utl_call_stack.error_number(1)) WHEN
                                            k_error.c_user_defined_error THEN
                                            utl_call_stack.error_msg(1) WHEN
                                            k_error.c_oracle_predefined_error THEN
                                            'Error al mitigar conflicto' END,
                                            dbms_utility.format_error_stack);
          END;
        
          -- Reserva identificador para log
          k_operacion.p_reservar_id_log(i_id_monitoreo);
        
          -- Registra log con datos de entrada y salida
          k_operacion.p_registrar_log(i_id_monitoreo,
                                      l_elemento.json,
                                      l_rsp_det.codigo,
                                      l_rsp_det.to_json,
                                      NULL,
                                      i_version);
        
          l_json_object.put('mitigado',
                            l_rsp_det.codigo = k_operacion.c_ok);
          l_elemento.json := l_json_object.to_clob;
          --dbms_output.put_line(l_elemento.json);
        END;
      
        l_elementos.extend;
        l_elementos(l_elementos.count) := l_elemento;
      
        o_tiene_conflicto := TRUE;
      END LOOP;
    
      dbms_sql.close_cursor(l_cursor);
    END;
    -- ========================================================
  
    l_pagina := f_paginar_elementos(l_elementos, f_pagina_parametros(NULL));
  
    k_operacion.p_respuesta_ok(l_rsp, l_pagina);
  
    RETURN l_rsp;
  EXCEPTION
    WHEN k_operacion.ex_error_parametro THEN
      RETURN l_rsp;
    WHEN k_operacion.ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      k_operacion.p_respuesta_excepcion(l_rsp,
                                        utl_call_stack.error_number(1),
                                        utl_call_stack.error_msg(1),
                                        dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  FUNCTION f_monitoreo_columnas_sql(i_id_monitoreo IN NUMBER) RETURN CLOB IS
    l_rsp VARCHAR2(4000) := '';
  
    l_nombre_monitoreo  t_operaciones.nombre%TYPE;
    l_dominio_monitoreo t_operaciones.dominio%TYPE;
    l_version_actual    t_operaciones.version_actual%TYPE;
    l_consulta_sql      t_monitoreos.consulta_sql%TYPE;
  BEGIN
    BEGIN
      SELECT upper(o.nombre),
             upper(o.dominio),
             o.version_actual,
             m.consulta_sql
        INTO l_nombre_monitoreo,
             l_dominio_monitoreo,
             l_version_actual,
             l_consulta_sql
        FROM t_monitoreos m, t_operaciones o
       WHERE o.id_operacion = m.id_monitoreo
         AND o.activo = 'S'
         AND m.id_monitoreo = i_id_monitoreo;
    EXCEPTION
      WHEN no_data_found THEN
        RETURN NULL;
    END;
  
    IF l_consulta_sql IS NULL THEN
      RETURN NULL;
    END IF;
  
    -- ========================================================
    DECLARE
      l_cursor   PLS_INTEGER;
      l_row_cnt  PLS_INTEGER;
      l_col_cnt  PLS_INTEGER;
      l_desc_tab dbms_sql.desc_tab2;
      --
      l_buffer_varchar2  VARCHAR2(32767);
      l_buffer_number    NUMBER;
      l_buffer_date      DATE;
      l_buffer_timestamp TIMESTAMP;
    BEGIN
      l_cursor := dbms_sql.open_cursor;
      dbms_sql.parse(l_cursor, l_consulta_sql, dbms_sql.native);
      dbms_sql.describe_columns2(l_cursor, l_col_cnt, l_desc_tab);
    
      FOR i IN 1 .. l_col_cnt LOOP
        IF l_desc_tab(i).col_type IN (dbms_types.typecode_varchar,
                         dbms_types.typecode_varchar2,
                         dbms_types.typecode_char,
                         dbms_types.typecode_clob,
                         dbms_types.typecode_nvarchar2,
                         dbms_types.typecode_nchar,
                         dbms_types.typecode_nclob) THEN
          dbms_sql.define_column(l_cursor, i, l_buffer_varchar2, 32767);
        ELSIF l_desc_tab(i).col_type IN (dbms_types.typecode_number) THEN
          dbms_sql.define_column(l_cursor, i, l_buffer_number);
        ELSIF l_desc_tab(i).col_type IN (dbms_types.typecode_date) THEN
          dbms_sql.define_column(l_cursor, i, l_buffer_date);
        ELSIF l_desc_tab(i).col_type IN (dbms_types.typecode_timestamp) THEN
          dbms_sql.define_column(l_cursor, i, l_buffer_timestamp);
        END IF;
      
        l_rsp := l_rsp || CASE
                   WHEN l_rsp IS NOT NULL THEN
                    ', ' || chr(10)
                 END || lower(l_desc_tab(i).col_name) || ' path ''$.' ||
                 lower(l_desc_tab(i).col_name) || '''';
      END LOOP;
    
      dbms_sql.close_cursor(l_cursor);
    END;
    -- ========================================================
  
    l_rsp := l_rsp || CASE
               WHEN l_rsp IS NOT NULL THEN
                ', ' || chr(10)
             END || 'mitigado' || ' path ''$.' || 'mitigado' || '''';
  
    RETURN l_rsp;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN l_rsp;
  END;

  FUNCTION f_procesar_monitoreo(i_id_monitoreo IN NUMBER,
                                i_version      IN VARCHAR2 DEFAULT NULL)
    RETURN CLOB IS
    l_rsp       y_respuesta;
    l_conflicto BOOLEAN;
  BEGIN
    -- Procesa monitoreo
    l_rsp := lf_procesar_monitoreo(i_id_monitoreo, i_version, l_conflicto);
    -- Registra ejecución
    k_monitoreo.lp_registrar_ejecucion(i_id_monitoreo,
                                       l_rsp.to_json,
                                       l_conflicto);
    RETURN l_rsp.to_json;
  END;

  FUNCTION f_procesar_monitoreo(i_nombre  IN VARCHAR2,
                                i_dominio IN VARCHAR2,
                                i_version IN VARCHAR2 DEFAULT NULL)
    RETURN CLOB IS
    l_rsp          y_respuesta;
    l_id_monitoreo t_monitoreos.id_monitoreo%TYPE;
    l_conflicto    BOOLEAN;
  BEGIN
    -- Busca monitoreo
    l_id_monitoreo := k_operacion.f_id_operacion(k_operacion.c_tipo_monitoreo,
                                                 i_nombre,
                                                 i_dominio);
    -- Procesa monitoreo
    l_rsp := lf_procesar_monitoreo(l_id_monitoreo, i_version, l_conflicto);
    -- Registra ejecución
    k_monitoreo.lp_registrar_ejecucion(l_id_monitoreo,
                                       l_rsp.to_json,
                                       l_conflicto);
    RETURN l_rsp.to_json;
  END;

  PROCEDURE p_procesar_monitoreos(i_frecuencia IN VARCHAR2 DEFAULT NULL) IS
    CURSOR c_monitoreos(i_frecuencias IN VARCHAR2 DEFAULT NULL) IS
      SELECT o.id_operacion,
             upper(o.nombre) nombre,
             upper(o.dominio) dominio,
             o.version_actual
        FROM t_monitoreos m, t_operaciones o
       WHERE o.id_operacion = m.id_monitoreo
         AND o.activo = 'S'
         AND (m.frecuencia IN
             (SELECT *
                 FROM (k_cadena.f_separar_cadenas(i_frecuencias, ','))) OR
             i_frecuencias IS NULL);
    --
    l_frecuencias t_significados.referencia%TYPE;
  BEGIN
    -- Reserva identificador para ejecución
    k_monitoreo.lp_reservar_id_ejecucion;
    dbms_output.put_line('#' ||
                         k_sistema.f_valor_parametro_number(c_id_ejecucion));
    -- Obtiene las frecuencias según parámetro
    IF i_frecuencia IS NOT NULL THEN
      BEGIN
        SELECT si.referencia
          INTO l_frecuencias
          FROM t_significados si
         WHERE si.dominio = 'FRECUENCIA_MONITOREO'
           AND si.activo = 'S'
           AND si.codigo = i_frecuencia;
      EXCEPTION
        WHEN no_data_found THEN
          RAISE ex_frecuencia_no_existe;
      END;
    END IF;
    -- Procesa todos los monitoreos activos
    FOR c IN c_monitoreos(l_frecuencias) LOOP
      DECLARE
        l_res CLOB;
      BEGIN
        l_res := k_monitoreo.f_procesar_monitoreo(c.id_operacion,
                                                  c.version_actual);
      END;
    END LOOP;
    -- Realiza el aviso resumido
    k_monitoreo.p_aviso_resumido(k_sistema.f_valor_parametro_number(c_id_ejecucion));
    -- Realiza el aviso detallado
    FOR c IN c_monitoreos(l_frecuencias) LOOP
      k_monitoreo.p_aviso_detallado(k_sistema.f_valor_parametro_number(c_id_ejecucion),
                                    c.id_operacion);
    END LOOP;
  END;

END;
/
