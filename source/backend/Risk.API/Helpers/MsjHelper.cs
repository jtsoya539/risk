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
using Microsoft.Extensions.Logging;
using Risk.API.Models;
using Risk.API.Services;

namespace Risk.API.Helpers
{
    public class MsjHelper : IMsjHelper
    {
        private readonly ILogger<MsjHelper> _logger;
        private readonly IMsjService _msjService;
        public bool MensajeriaActiva { get; set; }

        public MsjHelper(ILogger<MsjHelper> logger, IMsjService msjService)
        {
            _logger = logger;
            _msjService = msjService;
            MensajeriaActiva = false;
        }

        public void CambiarEstadoMensajeria(TipoMensajeria tipo, int id, EstadoMensajeria estado, string respuestaEnvio)
        {
            try
            {
                var respuesta = _msjService.CambiarEstadoMensajeria(tipo, id, estado, respuestaEnvio);

                if (!respuesta.Codigo.Equals(RiskConstants.CODIGO_OK))
                {
                    throw new Exception();
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"Error al cambiar estado de envío de la mensajería: {ex.Message}");
            }
        }

        public List<Correo> ListarCorreosPendientes()
        {
            List<Correo> mensajes = new List<Correo>();

            Respuesta<Pagina<Correo>> mensajesPendientes = null;
            try
            {
                mensajesPendientes = _msjService.ListarCorreosPendientes(new PaginaParametros { NoPaginar = "S" });
            }
            catch (Exception ex)
            {
                _logger.LogError($"Error al obtener lista de correos pendientes: {ex.Message}");
            }

            if (mensajesPendientes != null && mensajesPendientes.Codigo.Equals(RiskConstants.CODIGO_OK) && mensajesPendientes.Datos.CantidadElementos > 0)
            {
                mensajes = mensajesPendientes.Datos.Elementos;
            }

            return mensajes;
        }

        public List<Notificacion> ListarNotificacionesPendientes()
        {
            List<Notificacion> mensajes = new List<Notificacion>();

            Respuesta<Pagina<Notificacion>> mensajesPendientes = null;
            try
            {
                mensajesPendientes = _msjService.ListarNotificacionesPendientes(new PaginaParametros { NoPaginar = "S" });
            }
            catch (Exception ex)
            {
                _logger.LogError($"Error al obtener lista de notificaciones pendientes: {ex.Message}");
            }

            if (mensajesPendientes != null && mensajesPendientes.Codigo.Equals(RiskConstants.CODIGO_OK) && mensajesPendientes.Datos.CantidadElementos > 0)
            {
                mensajes = mensajesPendientes.Datos.Elementos;
            }

            return mensajes;
        }

        public List<Mensaje> ListarMensajesPendientes()
        {
            List<Mensaje> mensajes = new List<Mensaje>();

            Respuesta<Pagina<Mensaje>> mensajesPendientes = null;
            try
            {
                mensajesPendientes = _msjService.ListarMensajesPendientes(new PaginaParametros { NoPaginar = "S" });
            }
            catch (Exception ex)
            {
                _logger.LogError($"Error al obtener lista de mensajes pendientes: {ex.Message}");
            }

            if (mensajesPendientes != null && mensajesPendientes.Codigo.Equals(RiskConstants.CODIGO_OK) && mensajesPendientes.Datos.CantidadElementos > 0)
            {
                mensajes = mensajesPendientes.Datos.Elementos;
            }

            return mensajes;
        }
    }
}