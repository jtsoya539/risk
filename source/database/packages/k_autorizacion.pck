CREATE OR REPLACE PACKAGE k_autorizacion IS

  /**
  Agrupa operaciones relacionadas con la autorizacion de usuarios
  
  %author jtsoya539 27/3/2020 16:16:59
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

  -- Acciones
  c_accion_consultar  CONSTANT CHAR(1) := 'C';
  c_accion_insertar   CONSTANT CHAR(1) := 'I';
  c_accion_actualizar CONSTANT CHAR(1) := 'A';
  c_accion_eliminar   CONSTANT CHAR(1) := 'E';

  FUNCTION f_validar_permiso(i_id_usuario IN NUMBER,
                             i_id_permiso IN VARCHAR2,
                             i_accion     IN VARCHAR2 DEFAULT NULL)
    RETURN BOOLEAN;

END;
/
CREATE OR REPLACE PACKAGE BODY k_autorizacion IS

  FUNCTION f_validar_permiso(i_id_usuario IN NUMBER,
                             i_id_permiso IN VARCHAR2,
                             i_accion     IN VARCHAR2 DEFAULT NULL)
    RETURN BOOLEAN IS
    l_permiso VARCHAR2(1);
  BEGIN
    SELECT decode(i_accion,
                  NULL,
                  decode(nvl(COUNT(*), 0), 0, 'N', 'S'),
                  'C',
                  nvl(MAX(rp.consultar), 'N'),
                  'I',
                  nvl(MAX(rp.insertar), 'N'),
                  'A',
                  nvl(MAX(rp.actualizar), 'N'),
                  'E',
                  nvl(MAX(rp.eliminar), 'N'),
                  'N')
      INTO l_permiso
      FROM t_rol_permisos rp
     WHERE rp.id_rol IN (SELECT ru.id_rol
                           FROM t_rol_usuarios ru
                          WHERE ru.id_usuario = i_id_usuario)
       AND upper(rp.id_permiso) = upper(i_id_permiso);
    RETURN k_util.string_to_bool(l_permiso);
  EXCEPTION
    WHEN OTHERS THEN
      RETURN FALSE;
  END;

END;
/
