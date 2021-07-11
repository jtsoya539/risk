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
using Risk.API.Models;

namespace Risk.API.Entities
{
    public class YPagina<T> : IEntity
    {
        [JsonProperty("numero_actual")]
        public int NumeroActual { get; set; }
        [JsonProperty("numero_siguiente")]
        public int NumeroSiguiente { get; set; }
        [JsonProperty("numero_ultima")]
        public int NumeroUltima { get; set; }
        [JsonProperty("numero_primera")]
        public int NumeroPrimera { get; set; }
        [JsonProperty("numero_anterior")]
        public int NumeroAnterior { get; set; }
        [JsonProperty("cantidad_elementos")]
        public int CantidadElementos { get; set; }
        [JsonProperty("elementos")]
        public List<T> Elementos { get; set; }

        public IModel ConvertToModel()
        {
            throw new System.NotImplementedException();
        }
    }
}