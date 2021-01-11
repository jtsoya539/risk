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

using Risk.API.Models;

namespace Risk.API.Services
{
    public interface IGenService
    {
        Respuesta<Dato> VersionSistema();
        Respuesta<Dato> VersionServicio(string servicio);
        Respuesta<Dato> ValorParametro(string parametro);
        Respuesta<Dato> SignificadoCodigo(string dominio, string codigo);
        Respuesta<Pagina<Significado>> ListarSignificados(string dominio, PaginaParametros paginaParametros = null);
        Respuesta<Pagina<Pais>> ListarPaises(int? idPais = null, PaginaParametros paginaParametros = null);
        Respuesta<Pagina<Departamento>> ListarDepartamentos(int? idDepartamento = null, int? idPais = null, PaginaParametros paginaParametros = null);
        Respuesta<Pagina<Ciudad>> ListarCiudades(int? idCiudad = null, int? idPais = null, int? idDepartamento = null, PaginaParametros paginaParametros = null);
        Respuesta<Pagina<Barrio>> ListarBarrios(int? idBarrio = null, int? idPais = null, int? idDepartamento = null, int? idCiudad = null, PaginaParametros paginaParametros = null);
        Respuesta<Pagina<Error>> ListarErrores(string idError = null, PaginaParametros paginaParametros = null);
        Respuesta<Archivo> RecuperarArchivo(string tabla, string campo, string referencia, int? version = null);
        Respuesta<Dato> GuardarArchivo(string tabla, string campo, string referencia, Archivo archivo);
        Respuesta<Dato> RecuperarTexto(string referencia);
        Respuesta<Archivo> ReporteVersionSistema(FormatoReporte formato);
        Respuesta<Archivo> ReporteListarSignificados(FormatoReporte formato, string dominio);
    }
}