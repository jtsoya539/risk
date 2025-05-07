CREATE OR REPLACE PACKAGE k_flujo AS
  /**
  Agrupa procesos relacionados con el motor de flujos del sistema
  
  %author dmezac 04/05/2025
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
  --Constantes
  --Estados de instancias y pasos de los flujos
  c_estado_finalizado  CONSTANT VARCHAR2(30) := 'FINALIZADO';
  c_estado_en_progreso CONSTANT VARCHAR2(30) := 'EN_PROGRESO';
  c_estado_cancelado   CONSTANT VARCHAR2(30) := 'CANCELADO';

  --Tipos de pasos de los flujos
  c_tipo_paso_inicio     CONSTANT VARCHAR2(30) := 'INICIO';
  c_tipo_paso_manual     CONSTANT VARCHAR2(30) := 'MANUAL';
  c_tipo_paso_automatico CONSTANT VARCHAR2(30) := 'AUTOMATICO';
  c_tipo_paso_aprobacion CONSTANT VARCHAR2(30) := 'APROBACION';

  --Acción por defecto
  c_accion_aprobar CONSTANT VARCHAR2(30) := 'APROBAR';

  PROCEDURE iniciar_flujo(i_id_flujo     IN NUMBER,
                          i_usuario      IN VARCHAR2,
                          i_variables    IN CLOB,
                          o_id_instancia OUT NUMBER);

  FUNCTION obtener_estado_flujo(i_id_instancia IN NUMBER) RETURN CLOB;

  PROCEDURE avanzar_flujo(i_id_instancia IN NUMBER,
                          i_accion       IN VARCHAR2,
                          i_usuario      IN VARCHAR2,
                          i_comentario   IN VARCHAR2);

  PROCEDURE aprobar_paso(i_id_instancia IN NUMBER,
                         i_accion       IN VARCHAR2, --APROBAR / RECHAZAR / CONDICIONAR, ETC
                         i_usuario      IN VARCHAR2,
                         i_comentario   IN VARCHAR2);

END k_flujo;
/
CREATE OR REPLACE PACKAGE BODY k_flujo AS

  PROCEDURE iniciar_flujo(i_id_flujo     IN NUMBER,
                          i_usuario      IN VARCHAR2,
                          i_variables    IN CLOB,
                          o_id_instancia OUT NUMBER) IS
    l_id_paso_inicio t_flujo_pasos.id_paso%TYPE;
    l_nombre_flujo   t_flujos.nombre%TYPE;
  BEGIN
    -- Obtener información actual
    BEGIN
      SELECT nombre
        INTO l_nombre_flujo
        FROM t_flujos f
       WHERE f.id_flujo = i_id_flujo;
    EXCEPTION
      WHEN no_data_found THEN
        raise_application_error(-20001, 'Flujo no encontrado.');
    END;
  
    -- Crear nueva instancia
    INSERT INTO t_flujo_instancias
      (id_flujo, usuario_ingreso, variables)
    VALUES
      (i_id_flujo, i_usuario, i_variables)
    RETURNING id_instancia INTO o_id_instancia;
  
    -- Obtener primer paso (orden mínimo)
    SELECT id_paso
      INTO l_id_paso_inicio
      FROM t_flujo_pasos
     WHERE id_flujo = i_id_flujo
     ORDER BY orden
     FETCH FIRST 1 rows ONLY;
  
    -- Insertar paso inicial
    INSERT INTO t_flujo_instancia_pasos
      (id_instancia, id_paso, estado)
    VALUES
      (o_id_instancia, l_id_paso_inicio, c_estado_en_progreso);
  
    -- Si el siguiente paso es automático, avanzamos
    DECLARE
      l_tipo t_flujo_pasos.tipo%TYPE;
    BEGIN
      SELECT tipo
        INTO l_tipo
        FROM t_flujo_pasos
       WHERE id_paso = l_id_paso_inicio;
    
      IF l_tipo = c_tipo_paso_inicio THEN
        avanzar_flujo(o_id_instancia,
                      c_accion_aprobar,
                      i_usuario,
                      'Instancia inicializada');
      ELSE
        raise_application_error(-20001,
                                'Error al inicializar instancia. Paso inicial no definido correctamente');
      END IF;
    END;
  
  END iniciar_flujo;

  FUNCTION obtener_estado_flujo(i_id_instancia IN NUMBER) RETURN CLOB IS
    l_resultado CLOB;
  BEGIN
    SELECT json_object('id_instancia' VALUE i.id_instancia,
                       'estado' VALUE i.estado,
                       'variables' VALUE
                       json_query(i.variables, '$' RETURNING CLOB),
                       'pasos' VALUE
                       (SELECT json_arrayagg(json_object('id_paso' VALUE
                                                         pi.id_paso,
                                                         'nombre' VALUE
                                                         p.nombre,
                                                         'estado' VALUE
                                                         pi.estado,
                                                         'resultado' VALUE
                                                         pi.resultado,
                                                         'fecha_inicio' VALUE
                                                         to_char(pi.fecha_inicio,
                                                                 'YYYY-MM-DD"T"HH24:MI:SS'),
                                                         'fecha_fin' VALUE
                                                         to_char(pi.fecha_fin,
                                                                 'YYYY-MM-DD"T"HH24:MI:SS')))
                          FROM t_flujo_instancia_pasos pi
                          JOIN t_flujo_pasos p
                            ON pi.id_paso = p.id_paso
                         WHERE pi.id_instancia = i.id_instancia))
      INTO l_resultado
      FROM t_flujo_instancias i
     WHERE id_instancia = i_id_instancia;
  
    RETURN l_resultado;
  END obtener_estado_flujo;

  PROCEDURE avanzar_flujo(i_id_instancia IN NUMBER,
                          i_accion       IN VARCHAR2,
                          i_usuario      IN VARCHAR2,
                          i_comentario   IN VARCHAR2) IS
    l_id_flujo t_flujos.id_flujo%TYPE;
    --
    l_id_paso_actual    t_flujo_instancia_pasos.id_paso%TYPE;
    l_variables         t_flujo_instancias.variables%TYPE;
    l_id_paso_instancia t_flujo_instancia_pasos.id_paso_instancia%TYPE;
    l_usuario_ingreso   t_flujo_instancias.usuario_ingreso%TYPE;
    --
    l_nombre_paso       t_flujo_pasos.nombre%TYPE;
    l_id_paso_sig       t_flujo_pasos.id_paso%TYPE;
    l_acciones_posibles t_flujo_pasos.acciones_posibles%TYPE;
    l_roles             t_flujo_pasos.roles_responsables%TYPE;
    l_usuarios          t_flujo_pasos.usuarios_responsables%TYPE;
    l_bloque_plsql      t_flujo_pasos.bloque_plsql%TYPE;
    l_bloque_final      t_flujo_pasos.bloque_plsql%TYPE;
    --
    l_aprobadores_requeridos PLS_INTEGER;
    l_pendientes             PLS_INTEGER;
    l_puede_avanzar          BOOLEAN := FALSE;
    --
    l_es_final VARCHAR2(1) := 'N';
  BEGIN
    -- Obtener información actual
    BEGIN
      SELECT i.variables, i.id_flujo, i.usuario_ingreso
        INTO l_variables, l_id_flujo, l_usuario_ingreso
        FROM t_flujo_instancias i
       WHERE id_instancia = i_id_instancia;
    EXCEPTION
      WHEN no_data_found THEN
        raise_application_error(-20001, 'Instancia no encontrada.');
    END;
  
    -- Obtener el paso actual activo
    BEGIN
      SELECT id_paso_instancia,
             id_paso,
             roles_responsables,
             usuarios_responsables
        INTO l_id_paso_instancia, l_id_paso_actual, l_roles, l_usuarios
        FROM t_flujo_instancia_pasos
       WHERE id_instancia = i_id_instancia
         AND estado = c_estado_en_progreso;
    EXCEPTION
      WHEN no_data_found THEN
        raise_application_error(-20001, 'Instancia ya fue finalizada.');
    END;
  
    -- Obtener datos del paso actual
    SELECT nombre, acciones_posibles, bloque_plsql
      INTO l_nombre_paso, l_acciones_posibles, l_bloque_plsql
      FROM t_flujo_pasos
     WHERE id_paso = l_id_paso_actual;
  
    -- Verificar si hay múltiples aprobadores y si todos aprobaron
    SELECT COUNT(*)
      INTO l_aprobadores_requeridos
      FROM v_flujo_aprobador
     WHERE id_paso = l_id_paso_actual;
  
    SELECT SUM(nvl(pendientes, 0))
      INTO l_pendientes
      FROM v_roles_responsables_en_progreso
     WHERE id_paso_instancia = l_id_paso_instancia;
  
    --DBMS_OUTPUT.PUT_LINE( UTL_CALL_STACK.SUBPROGRAM(UTL_CALL_STACK.DYNAMIC_DEPTH - 1)(2) );
    IF l_aprobadores_requeridos > 0 AND
       utl_call_stack.subprogram(utl_call_stack.dynamic_depth - 1)
     (2) NOT IN ('APROBAR_PASO') THEN
      raise_application_error(-20001,
                              'No se puede avanzar. Faltan aprobaciones en el paso [' ||
                              l_nombre_paso || '].');
    END IF;
  
    IF i_accion = c_accion_aprobar THEN
      IF l_aprobadores_requeridos > 0 AND l_pendientes > 0 THEN
        raise_application_error(-20001,
                                'Faltan aprobaciones en el paso [' ||
                                l_nombre_paso || ']. Verifique.');
      END IF;
    END IF;
  
    -- Verificar las acciones permitidas
    IF NOT k_flujo_util.f_contiene_valor(i_accion, l_acciones_posibles) THEN
      raise_application_error(-20001,
                              'Acción [' || i_accion ||
                              '] no permitida para el paso ' ||
                              l_nombre_paso || '. ' ||
                              'Acciones posibles: ' || l_acciones_posibles || '');
    END IF;
  
    -- Verificar si el usuario tiene permiso a avanzar en el flujo
    IF l_roles IS NULL AND l_usuarios IS NULL THEN
      l_puede_avanzar := TRUE;
    END IF;
  
    IF l_roles IS NOT NULL THEN
      DECLARE
        l_cant_roles PLS_INTEGER;
      BEGIN
        SELECT COUNT(*) usuario_responsable
          INTO l_cant_roles
          FROM v_roles_responsables_paso a
         WHERE a.id_paso_instancia = l_id_paso_instancia
           AND EXISTS
         (SELECT 1
                  FROM t_rol_usuarios y
                 WHERE y.id_usuario = k_usuario.f_id_usuario(i_usuario)
                   AND (SELECT z.nombre
                          FROM t_roles z
                         WHERE z.id_rol = y.id_rol) = a.id_rol);
        IF l_cant_roles > 0 THEN
          l_puede_avanzar := TRUE;
        END IF;
      END;
    END IF;
  
    IF l_usuarios IS NOT NULL THEN
      DECLARE
        l_cant_usuario PLS_INTEGER;
      BEGIN
        SELECT COUNT(*) usuario_responsable
          INTO l_cant_usuario
          FROM v_usuarios_responsables_paso a
         WHERE a.id_paso_instancia = l_id_paso_instancia
           AND a.id_usuario = i_usuario;
        IF l_cant_usuario > 0 THEN
          l_puede_avanzar := TRUE;
        END IF;
      END;
    END IF;
  
    IF NOT l_puede_avanzar THEN
      raise_application_error(-20002,
                              'Usuario no tiene permiso para avanzar en el paso [' ||
                              l_nombre_paso || '].');
    END IF;
  
    -- Buscar transiciones posibles desde el paso actual al siguiente paso
    FOR t IN (SELECT id_transicion, id_paso_destino, condicion
                FROM t_flujo_transiciones
               WHERE id_paso_origen = l_id_paso_actual
                 AND accion = nvl(i_accion, c_accion_aprobar)) LOOP
      IF t.condicion IS NULL OR
         k_flujo_util.f_evaluar_condicion(t.condicion, l_variables) THEN
        l_id_paso_sig := t.id_paso_destino;
        EXIT;
      END IF;
    END LOOP;
  
    -- Ejecutar las acciones definidas en el bloque PLSQL
    BEGIN
      IF l_bloque_plsql IS NOT NULL THEN
        l_bloque_plsql := k_flujo_util.f_reemplazar_variables(l_bloque_plsql,
                                                              l_variables);
        l_bloque_final := 'DECLARE' || chr(10) || chr(10) || 'BEGIN' ||
                          chr(10) || '    DECLARE' || chr(10) ||
                          '    BEGIN' || chr(10) || '      --' || chr(10) ||
                          '      ' || l_bloque_plsql || ' ' || chr(10) ||
                          '      --' || chr(10) || '    END;' || chr(10) ||
                         /*'  :2 := l_rsp;' || chr(10) ||*/
                          'END;';
      
        --DBMS_OUTPUT.PUT_LINE( l_bloque_final );
        EXECUTE IMMEDIATE l_bloque_final
        /*USING IN i_prms, OUT io_rsp*/
        ;
      END IF;
    END;
  
    -- Obtener si es paso final
    IF l_id_paso_sig IS NULL THEN
      l_es_final := 'S';
    END IF;
  
    -- Cerrar paso actual
    UPDATE t_flujo_instancia_pasos
       SET estado    = c_estado_finalizado,
           resultado = i_accion,
           fecha_fin = systimestamp
     WHERE id_paso_instancia = l_id_paso_instancia;
  
    -- Registrar en historial
    INSERT INTO t_flujo_instancia_historial
      (id_instancia, id_paso, accion, usuario, comentario)
    VALUES
      (i_id_instancia, l_id_paso_actual, i_accion, i_usuario, i_comentario);
  
    -- Si es el paso final se finaliza la instancia, sino se registra el siguiente paso
    IF l_es_final = 'S' THEN
      UPDATE t_flujo_instancias
         SET estado = c_estado_finalizado, fecha_fin = systimestamp
       WHERE id_instancia = i_id_instancia;
      RETURN;
    ELSE
      DECLARE
        l_tipo         t_flujo_pasos.tipo%TYPE;
        l_roles_sig    t_flujo_pasos.roles_responsables%TYPE;
        l_usuarios_sig t_flujo_pasos.usuarios_responsables%TYPE;
      BEGIN
        -- Obtener los roles y usuarios responsables del siguiente paso
        SELECT tipo,
               roles_responsables,
               REPLACE(usuarios_responsables,
                       ':usuario_ingreso',
                       l_usuario_ingreso)
          INTO l_tipo, l_roles_sig, l_usuarios_sig
          FROM t_flujo_pasos
         WHERE id_paso = l_id_paso_sig;
      
        l_roles_sig    := k_flujo_util.f_reemplazar_variables(l_roles_sig,
                                                              l_variables,
                                                              NULL);
        l_usuarios_sig := k_flujo_util.f_reemplazar_variables(l_usuarios_sig,
                                                              l_variables,
                                                              NULL);
      
        -- Insertar nuevo paso
        INSERT INTO t_flujo_instancia_pasos
          (id_instancia,
           id_paso,
           estado,
           roles_responsables,
           usuarios_responsables)
        VALUES
          (i_id_instancia,
           l_id_paso_sig,
           c_estado_en_progreso,
           l_roles_sig,
           l_usuarios_sig);
      
        -- Si el siguiente paso es automático, avanzamos
        IF l_tipo = c_tipo_paso_automatico THEN
          avanzar_flujo(i_id_instancia,
                        c_accion_aprobar,
                        i_usuario,
                        'Realizado automaticamente');
        END IF;
      END;
    END IF;
  
  END;

  PROCEDURE aprobar_paso(i_id_instancia IN NUMBER,
                         i_accion       IN VARCHAR2, --APROBAR / RECHAZAR / CONDICIONAR, ETC
                         i_usuario      IN VARCHAR2,
                         i_comentario   IN VARCHAR2) IS
    l_id_flujo t_flujos.id_flujo%TYPE;
    --
    l_variables t_flujo_instancias.variables%TYPE;
    --
    l_nombre_paso       t_flujo_pasos.nombre%TYPE;
    l_acciones_posibles t_flujo_pasos.acciones_posibles%TYPE;
    l_roles             t_flujo_pasos.roles_responsables%TYPE;
    l_usuarios          t_flujo_pasos.usuarios_responsables%TYPE;
    --
    l_id_paso_instancia t_flujo_instancia_pasos.id_paso_instancia%TYPE;
    l_id_paso_actual    t_flujo_instancia_pasos.id_paso%TYPE;
    l_estado_actual     t_flujo_instancia_pasos.estado%TYPE;
    --
    l_aprobado t_flujo_instancia_aprobaciones.aprobado%TYPE := 'N';
    --
    l_aprobadores_requeridos PLS_INTEGER;
    l_pendientes             PLS_INTEGER;
    l_usuario_firmado        PLS_INTEGER;
    l_puede_avanzar          BOOLEAN := FALSE;
  BEGIN
    -- Obtener información actual
    BEGIN
      SELECT variables, i.id_flujo
        INTO l_variables, l_id_flujo
        FROM t_flujo_instancias i
       WHERE id_instancia = i_id_instancia;
    EXCEPTION
      WHEN no_data_found THEN
        raise_application_error(-20001, 'Instancia no encontrada.');
    END;
  
    -- Obtener el paso actual activo
    BEGIN
      SELECT id_paso_instancia,
             id_paso,
             estado,
             roles_responsables,
             usuarios_responsables
        INTO l_id_paso_instancia,
             l_id_paso_actual,
             l_estado_actual,
             l_roles,
             l_usuarios
        FROM t_flujo_instancia_pasos
       WHERE id_instancia = i_id_instancia
         AND estado = c_estado_en_progreso;
    EXCEPTION
      WHEN no_data_found THEN
        raise_application_error(-20001, 'Instancia ya fue finalizada.');
    END;
  
    -- Verificar si el usuario ya aprobó el paso actual activo
    SELECT COUNT(*)
      INTO l_usuario_firmado
      FROM t_flujo_instancia_aprobaciones a
     WHERE a.id_paso_instancia = l_id_paso_instancia
       AND a.usuario_aprobador = i_usuario
       AND a.aprobado = 'S';
    IF l_usuario_firmado > 0 THEN
      raise_application_error(-20001,
                              'Paso actual ya fue aprobado por el usuario.');
    END IF;
  
    -- Verificar las acciones permitidas
    SELECT nombre, acciones_posibles
      INTO l_nombre_paso, l_acciones_posibles
      FROM t_flujo_pasos
     WHERE id_paso = l_id_paso_actual;
  
    IF NOT k_flujo_util.f_contiene_valor(i_accion, l_acciones_posibles) THEN
      raise_application_error(-20001,
                              'Acción [' || i_accion ||
                              '] no permitida para el paso ' ||
                              l_nombre_paso || '. ' ||
                              'Acciones posibles: ' || l_acciones_posibles || '');
    END IF;
  
    -- Verificar si el usuario tiene permiso a avanzar en el flujo
    IF l_roles IS NULL AND l_usuarios IS NULL THEN
      l_puede_avanzar := TRUE;
    END IF;
  
    IF l_roles IS NOT NULL THEN
      DECLARE
        l_cant_roles PLS_INTEGER;
      BEGIN
        SELECT COUNT(*) usuario_responsable
          INTO l_cant_roles
          FROM v_roles_responsables_paso a
         WHERE a.id_paso_instancia = l_id_paso_instancia
           AND EXISTS
         (SELECT 1
                  FROM t_rol_usuarios y
                 WHERE y.id_usuario = k_usuario.f_id_usuario(i_usuario)
                   AND (SELECT z.nombre
                          FROM t_roles z
                         WHERE z.id_rol = y.id_rol) = a.id_rol);
        IF l_cant_roles > 0 THEN
          l_puede_avanzar := TRUE;
        END IF;
      END;
    END IF;
  
    IF l_usuarios IS NOT NULL THEN
      DECLARE
        l_cant_usuario PLS_INTEGER;
      BEGIN
        SELECT COUNT(*) usuario_responsable
          INTO l_cant_usuario
          FROM v_usuarios_responsables_paso a
         WHERE a.id_paso_instancia = l_id_paso_instancia
           AND a.id_usuario = i_usuario;
        IF l_cant_usuario > 0 THEN
          l_puede_avanzar := TRUE;
        END IF;
      END;
    END IF;
  
    -- Verificar si hay múltiples aprobadores
    SELECT COUNT(*)
      INTO l_aprobadores_requeridos
      FROM v_flujo_aprobador
     WHERE id_paso = l_id_paso_actual;
  
    IF l_aprobadores_requeridos = 0 THEN
      raise_application_error(-20001,
                              'Paso actual NO requiere aprobaciones.');
    END IF;
  
    -- Lanzar mensaje de error si el usuario no tiene permiso a avanzar
    IF NOT l_puede_avanzar THEN
      raise_application_error(-20002,
                              'Usuario no tiene permiso para realizar el paso [' ||
                              l_nombre_paso || '].');
    END IF;
  
    -- Registro la aprobacion, rechazo o condicionamiento, etc
    IF i_accion = c_accion_aprobar THEN
      l_aprobado := 'S';
    END IF;
  
    INSERT INTO t_flujo_instancia_aprobaciones
      (rol_aprobador,
       id_paso_instancia,
       usuario_aprobador,
       aprobado,
       fecha_aprobacion,
       comentario)
    VALUES
      ((SELECT json_arrayagg(a.id_rol) AS valores_json
         FROM v_roles_responsables_en_progreso a
        WHERE a.id_paso_instancia = l_id_paso_instancia
          AND EXISTS
        (SELECT 1
                 FROM t_rol_usuarios y
                WHERE y.id_usuario = k_usuario.f_id_usuario(i_usuario)
                  AND (SELECT z.nombre
                         FROM t_roles z
                        WHERE z.id_rol = y.id_rol) = a.id_rol)),
       l_id_paso_instancia,
       i_usuario,
       l_aprobado,
       systimestamp,
       i_comentario);
  
    -- Verificar si hay múltiples aprobadores y si todos los múltiples aprobadores, aprobaron
    SELECT SUM(nvl(pendientes, 0))
      INTO l_pendientes
      FROM v_roles_responsables_en_progreso
     WHERE id_paso_instancia = l_id_paso_instancia;
  
    IF l_aprobado = 'N' THEN
      -- Actualizar estado en caso de rechazo, condicionado u otros.
      avanzar_flujo(i_id_instancia, i_accion, i_usuario, i_comentario);
    ELSE
      IF l_aprobadores_requeridos > 0 AND l_pendientes > 0 THEN
        NULL;
      ELSE
        -- Actualizar estado en caso de aprobaciones completadas
        avanzar_flujo(i_id_instancia,
                      i_accion,
                      i_usuario,
                      'Completadas las aprobaciones múltiples');
      END IF;
    END IF;
  
  END;

END k_flujo;
/
