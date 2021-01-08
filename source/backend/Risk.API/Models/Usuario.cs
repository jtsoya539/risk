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

using System.Collections.Generic;
using Swashbuckle.AspNetCore.Annotations;

namespace Risk.API.Models
{
    [SwaggerSchema("Agrupa datos de un usuario")]
    public class Usuario
    {
        [SwaggerSchema("Identificador del usuario")]
        public int IdUsuario { get; set; }
        [SwaggerSchema("Alias del usuario (identificador para autenticacion)")]
        public string Alias { get; set; }
        [SwaggerSchema("Nombre de la persona")]
        public string Nombre { get; set; }
        [SwaggerSchema("Apellido de la persona")]
        public string Apellido { get; set; }
        [SwaggerSchema("Tipo de la persona")]
        public string TipoPersona { get; set; }
        [SwaggerSchema("Estado del usuario")]
        public string Estado { get; set; }
        [SwaggerSchema("Direccion de correo electronico principal del usuario")]
        public string DireccionCorreo { get; set; }
        [SwaggerSchema("Numero de telefono principal del usuario")]
        public string NumeroTelefono { get; set; }
        [SwaggerSchema("Version del avatar del usuario")]
        public int? VersionAvatar { get; set; }
        [SwaggerSchema("Roles del usuario")]
        public List<Rol> Roles { get; set; }
    }
}