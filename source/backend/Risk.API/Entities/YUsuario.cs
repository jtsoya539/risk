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
using Newtonsoft.Json;

namespace Risk.API.Entities
{
    public class YUsuario
    {
        [JsonProperty("id_usuario")]
        public int IdUsuario { get; set; }
        [JsonProperty("alias")]
        public string Alias { get; set; }
        [JsonProperty("nombre")]
        public string Nombre { get; set; }
        [JsonProperty("apellido")]
        public string Apellido { get; set; }
        [JsonProperty("tipo_persona")]
        public string TipoPersona { get; set; }
        [JsonProperty("estado")]
        public string Estado { get; set; }
        [JsonProperty("direccion_correo")]
        public string DireccionCorreo { get; set; }
        [JsonProperty("numero_telefono")]
        public string NumeroTelefono { get; set; }
        [JsonProperty("version_avatar")]
        public int? VersionAvatar { get; set; }
        [JsonProperty("origen")]
        public string Origen { get; set; }
        [JsonProperty("roles")]
        public List<YRol> Roles { get; set; }
    }
}