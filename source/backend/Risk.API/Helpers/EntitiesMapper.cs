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

namespace Risk.API.Helpers
{
    public class EntitiesMapper
    {
        public static Archivo GetArchivoFromEntity(YArchivo entity)
        {
            Archivo model;
            if (entity == null)
            {
                model = null;
            }
            else
            {
                model = new Archivo
                {
                    Contenido = entity.Contenido,
                    Checksum = entity.Checksum,
                    Tamano = entity.Tamano,
                    Nombre = entity.Nombre,
                    Extension = entity.Extension,
                    TipoMime = entity.TipoMime
                };
            }
            return model;
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

        public static Respuesta<T> GetRespuestaFromEntity<T, YT>(YRespuesta<YT> entity, T datos)
        {
            return new Respuesta<T>
            {
                Codigo = entity.Codigo,
                Mensaje = entity.Mensaje,
                Datos = datos
            };
        }

        public static Rol GetRolFromEntity(YRol entity)
        {
            Rol model;
            if (entity == null)
            {
                model = null;
            }
            else
            {
                model = new Rol
                {
                    IdRol = entity.IdRol,
                    Nombre = entity.Nombre,
                    Activo = entity.Activo,
                    Detalle = entity.Detalle
                };
            }
            return model;
        }

        public static List<Rol> GetRolListFromEntity(List<YRol> entityList)
        {
            List<Rol> modelList = new List<Rol>();
            if (entityList != null)
            {
                foreach (var item in entityList)
                {
                    modelList.Add(GetRolFromEntity(item));
                }
            }
            return modelList;
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
                    TiempoExpiracion = entity.TiempoExpiracion
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
                    Tipo = entity.Tipo,
                    NombreNavegador = entity.NombreNavegador,
                    VersionNavegador = entity.VersionNavegador,
                    TokenNotificacion = entity.TokenNotificacion,
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
                    Roles = GetRolListFromEntity(entity.Roles)
                };
            }
            return model;
        }

        public static Pais GetPaisFromEntity(YPais entity)
        {
            Pais model;
            if (entity == null)
            {
                model = null;
            }
            else
            {
                model = new Pais
                {
                    IdPais = entity.IdPais,
                    Nombre = entity.Nombre
                };
            }
            return model;
        }

        public static List<Pais> GetPaisListFromEntity(List<YPais> entityList)
        {
            List<Pais> modelList = new List<Pais>();
            if (entityList != null)
            {
                foreach (var item in entityList)
                {
                    modelList.Add(GetPaisFromEntity(item));
                }
            }
            return modelList;
        }

        public static Mensaje GetMensajeFromEntity(YMensaje entity)
        {
            Mensaje model;
            if (entity == null)
            {
                model = null;
            }
            else
            {
                model = new Mensaje
                {
                    IdMensaje = entity.IdMensaje,
                    NumeroTelefono = entity.NumeroTelefono,
                    Contenido = entity.Contenido
                };
            }
            return model;
        }

        public static List<Mensaje> GetMensajeListFromEntity(List<YMensaje> entityList)
        {
            List<Mensaje> modelList = new List<Mensaje>();
            if (entityList != null)
            {
                foreach (var item in entityList)
                {
                    modelList.Add(GetMensajeFromEntity(item));
                }
            }
            return modelList;
        }

        public static Correo GetCorreoFromEntity(YCorreo entity)
        {
            Correo model;
            if (entity == null)
            {
                model = null;
            }
            else
            {
                model = new Correo
                {
                    IdCorreo = entity.IdCorreo,
                    MensajeTo = entity.MensajeTo,
                    MensajeSubject = entity.MensajeSubject,
                    MensajeBody = entity.MensajeBody,
                    MensajeFrom = entity.MensajeFrom,
                    MensajeReplyTo = entity.MensajeReplyTo,
                    MensajeCc = entity.MensajeCc,
                    MensajeBcc = entity.MensajeBcc
                };
            }
            return model;
        }

        public static List<Correo> GetCorreoListFromEntity(List<YCorreo> entityList)
        {
            List<Correo> modelList = new List<Correo>();
            if (entityList != null)
            {
                foreach (var item in entityList)
                {
                    modelList.Add(GetCorreoFromEntity(item));
                }
            }
            return modelList;
        }

        public static Pagina<T> GetPaginaFromEntity<T, YT>(YPagina<YT> entity, List<T> elementos)
        {
            return new Pagina<T>
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
    }
}