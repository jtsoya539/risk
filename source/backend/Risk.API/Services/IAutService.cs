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

using Risk.API.Entities;

namespace Risk.API.Services
{
    public interface IAutService
    {
        YRespuesta<YDato> ValidarCredenciales(string usuario, string clave, string tipoClave);
        YRespuesta<YSesion> IniciarSesion(string usuario, string claveAplicacion, string accessToken, string refreshToken);
        YRespuesta<YSesion> RefrescarSesion(string accessTokenAntiguo, string refreshTokenAntiguo, string accessTokenNuevo, string refreshTokenNuevo);
        YRespuesta<YDato> CambiarEstadoSesion(string token, string estado);
        YRespuesta<YDato> RegistrarUsuario(string usuario, string clave, string nombre, string apellido, string direccionCorreo, string numeroTelefono);
        YRespuesta<YDato> RegistrarClave(string usuario, string clave, string tipoClave);
        YRespuesta<YDato> CambiarClave(string usuario, string claveAntigua, string claveNueva, string tipoClave);
        YRespuesta<YDato> ValidarSesion(string token);
        YRespuesta<YUsuario> DatosUsuario(string usuario);
        YRespuesta<YDato> ValidarClaveAplicacion(string claveAplicacion);
    }
}