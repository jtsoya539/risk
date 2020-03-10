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