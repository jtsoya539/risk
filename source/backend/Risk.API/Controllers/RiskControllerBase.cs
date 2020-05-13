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

using Microsoft.AspNetCore.Mvc;
using Risk.API.Models;

namespace Risk.API.Controllers
{
    public class RiskControllerBase : ControllerBase
    {
        public IActionResult ProcesarRespuesta<T>(Respuesta<T> respuesta)
        {
            // https://httpstatuses.com/
            if (respuesta.Codigo.Equals("0"))
            {
                return Ok(respuesta); // 200 OK
            }
            else
            {
                if (respuesta.Codigo.Equals("api9999"))
                    return StatusCode(500, respuesta); // 500 Internal Server Error
                else if (respuesta.Codigo.Equals("api0001") || respuesta.Codigo.Equals("api0003"))
                    return StatusCode(501, respuesta); // 501 Not Implemented
                else
                    return BadRequest(respuesta); // 400 Bad Request
            }
        }
    }
}