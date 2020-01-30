using Risk.API.Entities;

namespace Risk.API.Services
{
    public interface IAuthService
    {
        YRespuesta ApiValidarCredenciales(string usuario, string clave);
        YRespuesta ApiIniciarSesion(string usuario, string token);
        YRespuesta ApiFinalizarSesion(int idSesion);
    }
}