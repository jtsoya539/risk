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

set serveroutput on size unlimited

BEGIN
  EXECUTE IMMEDIATE 'ALTER SESSION SET TIME_ZONE = ''' ||
                    k_util.f_valor_parametro('ZONA_HORARIA') || '''';
  -- Eliminar trabajos de monitoreo de conflictos
  k_trabajo.p_eliminar_trabajo(i_id_trabajo   => k_trabajo.c_monitoreo_conflictos_mensual,
                               i_parametros   => '{"frecuencia": "M"}'
                               );

  k_trabajo.p_eliminar_trabajo(i_id_trabajo   => k_trabajo.c_monitoreo_conflictos_semanal,
                               i_parametros   => '{"frecuencia": "S"}'
                               );

  k_trabajo.p_eliminar_trabajo(i_id_trabajo   => k_trabajo.c_monitoreo_conflictos_diario,
                               i_parametros   => '{"frecuencia": "D"}'
                               );

  k_trabajo.p_eliminar_trabajo(i_id_trabajo   => k_trabajo.c_monitoreo_conflictos_12_horas,
                               i_parametros   => '{"frecuencia": "12H"}'
                               );

  k_trabajo.p_eliminar_trabajo(i_id_trabajo   => k_trabajo.c_monitoreo_conflictos_6_horas,
                               i_parametros   => '{"frecuencia": "6H"}'
                               );

  k_trabajo.p_eliminar_trabajo(i_id_trabajo   => k_trabajo.c_monitoreo_conflictos_2_horas,
                               i_parametros   => '{"frecuencia": "2H"}'
                               );

  k_trabajo.p_eliminar_trabajo(i_id_trabajo   => k_trabajo.c_monitoreo_conflictos_hora,
                               i_parametros   => '{"frecuencia": "H"}'
                               );
END;
/

set serveroutput off
