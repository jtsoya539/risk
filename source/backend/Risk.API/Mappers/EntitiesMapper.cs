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

using System;
using System.Collections.Generic;
using Risk.API.Entities;
using Risk.API.Models;

namespace Risk.API.Mappers
{
    public static class EntitiesMapper
    {
        public static TModel GetModelFromEntity<TModel, TEntity>(IEntity entity)
            where TModel : IModel
            where TEntity : IEntity
        {
            IModel model;
            if (entity == null)
            {
                model = null;
            }
            else
            {
                model = entity.ConvertToModel();
            }
            return (TModel)model;
        }

        public static List<TModel> GetModelListFromEntity<TModel, TEntity>(List<TEntity> entityList)
            where TModel : IModel
            where TEntity : IEntity
        {
            List<TModel> modelList = new List<TModel>();
            if (entityList != null)
            {
                foreach (var item in entityList)
                {
                    modelList.Add(GetModelFromEntity<TModel, TEntity>(item));
                }
            }
            return modelList;
        }

        public static Dato GetDatoFromEntity(YDato entity)
        {
            Dato model;
            if (entity == null)
            {
                model = null;
            }
            else
            {
                model = new Dato
                {
                    Contenido = entity.Contenido
                };
            }
            return model;
        }

        public static List<Dato> GetDatoListFromEntity(List<YDato> entityList)
        {
            List<Dato> modelList = new List<Dato>();
            if (entityList != null)
            {
                foreach (var item in entityList)
                {
                    modelList.Add(GetDatoFromEntity(item));
                }
            }
            return modelList;
        }

        public static Respuesta<TModel> GetRespuestaFromEntity<TModel, TEntity>(YRespuesta<TEntity> entity, TModel datos)
        {
            return new Respuesta<TModel>
            {
                Codigo = entity.Codigo,
                Mensaje = entity.Mensaje,
                Datos = datos
            };
        }

        public static Sesion GetSesionFromEntity(YSesion entity)
        {
            Sesion model;
            if (entity == null)
            {
                model = null;
            }
            else
            {
                model = new Sesion
                {
                    IdSesion = entity.IdSesion,
                    Estado = entity.Estado,
                    AccessToken = entity.AccessToken,
                    RefreshToken = entity.RefreshToken,
                    TiempoExpiracionAccessToken = entity.TiempoExpiracionAccessToken,
                    TiempoExpiracionRefreshToken = entity.TiempoExpiracionRefreshToken
                };
            }
            return model;
        }

        public static Dispositivo GetDispositivoFromEntity(YDispositivo entity)
        {
            Dispositivo model;
            if (entity == null)
            {
                model = null;
            }
            else
            {
                model = new Dispositivo
                {
                    IdDispositivo = entity.IdDispositivo,
                    TokenDispositivo = entity.TokenDispositivo,
                    NombreSistemaOperativo = entity.NombreSistemaOperativo,
                    VersionSistemaOperativo = entity.VersionSistemaOperativo,
                    Tipo = GetTipoDispositivoEnumFromValue(entity.Tipo),
                    NombreNavegador = entity.NombreNavegador,
                    VersionNavegador = entity.VersionNavegador,
                    TokenNotificacion = entity.TokenNotificacion,
                    PlataformaNotificacion = entity.PlataformaNotificacion,
                    Plantillas = GetPlantillaListFromEntity(entity.Plantillas),
                    Suscripciones = GetDatoListFromEntity(entity.Suscripciones)
                };
            }
            return model;
        }

        public static Usuario GetUsuarioFromEntity(YUsuario entity)
        {
            Usuario model;
            if (entity == null)
            {
                model = null;
            }
            else
            {
                model = new Usuario
                {
                    IdUsuario = entity.IdUsuario,
                    Alias = entity.Alias,
                    Nombre = entity.Nombre,
                    Apellido = entity.Apellido,
                    TipoPersona = entity.TipoPersona,
                    Estado = entity.Estado,
                    DireccionCorreo = entity.DireccionCorreo,
                    NumeroTelefono = entity.NumeroTelefono,
                    VersionAvatar = entity.VersionAvatar,
                    Origen = GetOrigenSesionEnumFromValue(entity.Origen),
                    Roles = GetModelListFromEntity<Rol, YRol>(entity.Roles)
                };
            }
            return model;
        }

        public static Aplicacion GetAplicacionFromEntity(SqlAplicacion entity)
        {
            Aplicacion model;
            if (entity == null)
            {
                model = null;
            }
            else
            {
                model = new Aplicacion
                {
                    IdAplicacion = entity.IdAplicacion,
                    Nombre = entity.Nombre,
                    Tipo = entity.Tipo,
                    Activo = GetBoolFromValue(entity.Activo),
                    Detalle = entity.Detalle,
                    VersionActual = entity.VersionActual
                };
            }
            return model;
        }

        public static List<Aplicacion> GetAplicacionListFromEntity(List<SqlAplicacion> entityList)
        {
            List<Aplicacion> modelList = new List<Aplicacion>();
            if (entityList != null)
            {
                foreach (var item in entityList)
                {
                    modelList.Add(GetAplicacionFromEntity(item));
                }
            }
            return modelList;
        }

        public static Plantilla GetPlantillaFromEntity(YPlantilla entity)
        {
            Plantilla model;
            if (entity == null)
            {
                model = null;
            }
            else
            {
                model = new Plantilla
                {
                    Contenido = entity.Contenido,
                    Nombre = entity.Nombre
                };
            }
            return model;
        }

        public static List<Plantilla> GetPlantillaListFromEntity(List<YPlantilla> entityList)
        {
            List<Plantilla> modelList = new List<Plantilla>();
            if (entityList != null)
            {
                foreach (var item in entityList)
                {
                    modelList.Add(GetPlantillaFromEntity(item));
                }
            }
            return modelList;
        }

        public static Pagina<TModel> GetPaginaFromEntity<TModel, TEntity>(YPagina<TEntity> entity, List<TModel> elementos)
        {
            return new Pagina<TModel>
            {
                PaginaActual = Convert.ToString(entity.NumeroActual),
                PaginaSiguiente = Convert.ToString(entity.NumeroSiguiente),
                PaginaUltima = Convert.ToString(entity.NumeroUltima),
                PaginaPrimera = Convert.ToString(entity.NumeroPrimera),
                PaginaAnterior = Convert.ToString(entity.NumeroAnterior),
                CantidadElementos = entity.CantidadElementos,
                Elementos = elementos
            };
        }

        public static TipoDispositivo GetTipoDispositivoEnumFromValue(string value)
        {
            switch (value.ToUpper())
            {
                case "M":
                    return TipoDispositivo.Mobile;
                case "T":
                    return TipoDispositivo.Tablet;
                case "D":
                    return TipoDispositivo.Desktop;
                case "V":
                    return TipoDispositivo.Tv;
                case "W":
                    return TipoDispositivo.Watch;
                default:
                    return TipoDispositivo.Mobile;
            }
        }

        public static OrigenSesion GetOrigenSesionEnumFromValue(string value)
        {
            if (value == null)
                return OrigenSesion.Risk;

            switch (value.ToUpper())
            {
                case "G":
                    return OrigenSesion.Google;
                case "F":
                    return OrigenSesion.Facebook;
                default:
                    return OrigenSesion.Risk;
            }
        }

        public static bool GetBoolFromValue(string value)
        {
            switch (value.ToUpper())
            {
                case "S":
                    return true;
                case "N":
                    return false;
                default:
                    return false;
            }
        }
    }
}