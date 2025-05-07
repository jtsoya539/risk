CREATE OR REPLACE VIEW V_ROLES_RESPONSABLES_EN_PROGRESO AS
WITH
-- JSON de roles requeridos
roles_requeridos AS
 (SELECT p.id_instancia, p.id_paso_instancia, valor AS rol
    FROM v_pasos_en_progreso p,
         json_table(p.roles_responsables,
                    '$[*]' columns(valor VARCHAR2(100) path '$'))),

-- JSON de roles del usuario actual
roles_usuario AS
 (SELECT DISTINCT a.id_instancia, a.id_paso_instancia, a.id_rol rol
    FROM v_roles_responsables_paso a
   WHERE EXISTS (SELECT 1
            FROM t_rol_usuarios y
           WHERE y.id_usuario = ''
             AND y.id_rol = a.id_rol)),

-- Extraer y unificar todos los roles firmados desde la tabla FIRMAS
roles_firmados AS
 (SELECT f.id_instancia, f.id_paso_instancia, valor AS rol
    FROM v_historial_aprobaciones f,
         json_table(f.rol_aprobador,
                    '$[*]' columns(valor VARCHAR2(100) path '$'))
   WHERE f.aprobado = 'S'),

-- Conteo de requeridos
conteo_requerido AS
 (SELECT rol, id_instancia, id_paso_instancia, COUNT(*) AS cantidad
    FROM roles_requeridos
   GROUP BY rol, id_instancia, id_paso_instancia),

-- Conteo de firmados
conteo_firmado AS
 (SELECT rol, id_paso_instancia, COUNT(*) AS cantidad
    FROM roles_firmados
   GROUP BY rol, id_paso_instancia),

-- Conteo de usuario actual
conteo_usuario AS
 (SELECT rol, id_paso_instancia, COUNT(*) AS cantidad
    FROM roles_usuario
   GROUP BY rol, id_paso_instancia)

-- Resultado final: pendientes
SELECT r.id_instancia,
       r.id_paso_instancia,
       r.rol id_rol,
       r.cantidad AS requeridos,
       nvl(f.cantidad, 0) AS ya_firmados,
       --NVL(u.cantidad, 0) AS del_usuario,
       greatest(r.cantidad - nvl(f.cantidad, 0) - nvl(u.cantidad, 0), 0) AS pendientes
  FROM conteo_requerido r
  LEFT JOIN conteo_firmado f
    ON r.rol = f.rol
   AND r.id_paso_instancia = f.id_paso_instancia
  LEFT JOIN conteo_usuario u
    ON r.rol = u.rol
   AND r.id_paso_instancia = u.id_paso_instancia
 WHERE greatest(r.cantidad - nvl(f.cantidad, 0) - nvl(u.cantidad, 0), 0) > 0;
