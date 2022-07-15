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
using System.IO;
using System.Linq;
using MimeKit;
using Risk.API.Models;
using Risk.Common.Helpers;

namespace Risk.API.Helpers
{
    public static class MailHelper
    {
        public static MimeMessage GetMimeMessageFromCorreo(Correo msj)
        {
            var message = new MimeMessage();

            // From
            message.From.Add(new MailboxAddress(msj.MensajeFrom, msj.MensajeFrom));

            // https://stackoverflow.com/a/59993188
            // To
            foreach (string address in msj.MensajeTo.Replace(";", ",").Split(",")) // Split on ,
            {
                message.To.Add(new MailboxAddress(address.Trim(), address.Trim()));
            }

            // ReplyTo
            if (!string.IsNullOrEmpty(msj.MensajeReplyTo))
            {
                foreach (string address in msj.MensajeReplyTo.Replace(";", ",").Split(",")) // Split on ,
                {
                    message.ReplyTo.Add(new MailboxAddress(address.Trim(), address.Trim()));
                }
            }

            // Cc
            if (!string.IsNullOrEmpty(msj.MensajeCc))
            {
                foreach (string address in msj.MensajeCc.Replace(";", ",").Split(",")) // Split on ,
                {
                    message.Cc.Add(new MailboxAddress(address.Trim(), address.Trim()));
                }
            }

            // Bcc
            if (!string.IsNullOrEmpty(msj.MensajeBcc))
            {
                foreach (string address in msj.MensajeBcc.Replace(";", ",").Split(",")) // Split on ,
                {
                    message.Bcc.Add(new MailboxAddress(address.Trim(), address.Trim()));
                }
            }

            message.Subject = msj.MensajeSubject;

            var multipart = new Multipart("mixed");

            // Body
            string subtype;
            if (msj.MensajeBody.Contains("<html>") && msj.MensajeBody.Contains("</html>"))
            {
                subtype = "html";
            }
            else
            {
                subtype = "plain";
            }
            var body = new TextPart(subtype)
            {
                Text = msj.MensajeBody
            };
            multipart.Add(body);

            // Attachments
            if (msj.Adjuntos.Any())
            {
                foreach (var adjunto in msj.Adjuntos)
                {
                    string contentType = adjunto.TipoMime;
                    if (string.IsNullOrEmpty(contentType))
                    {
                        contentType = "application/octet-stream";
                    }

                    byte[] contenido = GZipHelper.Decompress(Convert.FromBase64String(adjunto.Contenido));
                    var ms = new MemoryStream();
                    ms.Write(contenido, 0, contenido.Length);

                    var attachment = new MimePart(contentType)
                    {
                        Content = new MimeContent(ms, ContentEncoding.Default),
                        ContentDisposition = new ContentDisposition(ContentDisposition.Attachment),
                        ContentTransferEncoding = ContentEncoding.Base64,
                        FileName = string.Concat(adjunto.Nombre, ".", adjunto.Extension)
                    };
                    multipart.Add(attachment);
                }
            }

            message.Body = multipart;
            return message;
        }
    }
}