using Risk.API.Entities;

namespace Risk.API.Services
{
    public interface IAuthService
    {
        YRespuesta ApiValidarCredenciales(string usuario, string clave, string tipoClave);
        YRespuesta ApiIniciarSesion(string usuario, string token);
        YRespuesta ApiFinalizarSesion(string token);
        YRespuesta ApiRegistrarUsuario(string usuario, string clave);
        YRespuesta ApiRegistrarClave(string usuario, string clave, string tipoClave);
        YRespuesta ApiCambiarClave(string usuario, string claveAntigua, string claveNueva, string tipoClave);
        YRespuesta ApiValidarSesion(string token);
    }
}