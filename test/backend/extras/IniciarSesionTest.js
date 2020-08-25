var respuesta = pm.response.json();
if (respuesta.Codigo == "0") {
    pm.environment.set("AccessToken", respuesta.Datos.AccessToken); // {{AccessToken}}
    pm.environment.set("RefreshToken", respuesta.Datos.RefreshToken); // {{RefreshToken}}
}