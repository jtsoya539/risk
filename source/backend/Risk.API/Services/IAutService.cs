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
    public interface IAutService
    {
        Respuesta<Dato> ValidarCredenciales(string usuario, string clave, string tipoClave);
        Respuesta<Sesion> IniciarSesion(string usuario, string claveAplicacion, string accessToken, string refreshToken);
        Respuesta<Sesion> RefrescarSesion(string accessTokenAntiguo, string refreshTokenAntiguo, string accessTokenNuevo, string refreshTokenNuevo);
        Respuesta<Dato> CambiarEstadoSesion(string token, string estado);
        Respuesta<Dato> RegistrarUsuario(string usuario, string clave, string nombre, string apellido, string direccionCorreo, string numeroTelefono);
        Respuesta<Dato> RegistrarClave(string usuario, string clave, string tipoClave);
        Respuesta<Dato> CambiarClave(string usuario, string claveAntigua, string claveNueva, string tipoClave);
        Respuesta<Dato> ValidarSesion(string token);
        Respuesta<Usuario> DatosUsuario(string usuario);
        Respuesta<Dato> ValidarClaveAplicacion(string claveAplicacion);
    }
}