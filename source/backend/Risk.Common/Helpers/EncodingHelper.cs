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

using System.Text;

namespace Risk.Common.Helpers
{
    public static class EncodingHelper
    {
        public static byte[] ConvertToUTF8(byte[] data, string charset = null)
        {
            byte[] resultado = data;

            if (!string.IsNullOrEmpty(charset))
            {
                Encoding.RegisterProvider(CodePagesEncodingProvider.Instance);

                Encoding databaseEncoding = Encoding.GetEncoding(charset);
                Encoding utf8Encoding = Encoding.UTF8;

                if (!databaseEncoding.Equals(utf8Encoding))
                {
                    resultado = Encoding.Convert(databaseEncoding, utf8Encoding, data);
                }
            }

            return resultado;
        }

        public static string ConvertToUTF8(string data, string charset = null)
        {
            string resultado = data;

            if (!string.IsNullOrEmpty(charset))
            {
                Encoding.RegisterProvider(CodePagesEncodingProvider.Instance);

                Encoding databaseEncoding = Encoding.GetEncoding(charset);
                Encoding utf8Encoding = Encoding.UTF8;

                if (!databaseEncoding.Equals(utf8Encoding))
                {
                    byte[] utf8Bytes = Encoding.Convert(databaseEncoding, utf8Encoding, databaseEncoding.GetBytes(data));
                    resultado = Encoding.UTF8.GetString(utf8Bytes);
                }
            }

            return resultado;
        }
    }
}
