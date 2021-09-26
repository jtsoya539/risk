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

namespace Risk.Common.Helpers
{
    public static class RiskConstants
    {
        // Códigos de respuesta para excepciones en API
        public const string CODIGO_DB_EXCEPTION = "api0001";
        public const string CODIGO_API_EXCEPTION = "api0002";
        public const string CODIGO_EXCEPTION = "api9999";

        // Códigos de respuesta de Base de Datos
        public const string CODIGO_OK = "0";
        public const string CODIGO_SERVICIO_NO_IMPLEMENTADO = "ser0001";
        public const string CODIGO_ERROR_PARAMETRO = "ser0002";
        public const string CODIGO_ERROR_PERMISO = "ser0003";
        public const string CODIGO_ERROR_GENERAL = "ser0099";
        public const string CODIGO_ERROR_INESPERADO = "ser9999";
        public const string CODIGO_ERROR_USUARIO_EXTERNO_EXISTENTE = "aut0010";

        // OpenApi Security Schemes
        public const string SECURITY_SCHEME_RISK_APP_KEY = "RiskAppKey";
        public const string SECURITY_SCHEME_ACCESS_TOKEN = "AccessToken";

        // Http Headers
        public const string HEADER_RISK_APP_KEY = "Risk-App-Key";
        public const string HEADER_AUTHORIZATION = "Authorization";
        public const string HEADER_RISK_SERVICE_VERSION = "Risk-Service-Version";

        // Swagger Response Descriptions
        public const string SWAGGER_RESPONSE_200 = "Operación exitosa";
        public const string SWAGGER_RESPONSE_400 = "Operación con error";
        public const string SWAGGER_RESPONSE_401 = "Operación no autorizada";
        public const string SWAGGER_RESPONSE_403 = "Aplicación no autorizada";
        public const string SWAGGER_RESPONSE_500 = "Error inesperado";
        public const string SWAGGER_RESPONSE_501 = "Servicio no implementado o inactivo";

        // Formatos de salida de reportes
        public const string FORMATO_PDF = "PDF";
        public const string FORMATO_DOCX = "DOCX";
        public const string FORMATO_XLSX = "XLSX";
        public const string FORMATO_CSV = "CSV";
        public const string FORMATO_HTML = "HTML";

        // Orientaciones de reportes
        public const string ORIENTACION_VERTICAL = "PORTRAIT";
        public const string ORIENTACION_HORIZONTAL = "LANDSCAPE";

        // Nombres de metadatos para conversión de reportes HTML a PDF
        public const string META_FORMAT = "risk:format";
        public const string META_PAGE_SIZE = "risk:page_size";
        public const string META_PAGE_ORIENTATION = "risk:page_orientation";

        // Secure Storage keys
        public const string ACCESS_TOKEN = "ACCESS_TOKEN";
        public const string REFRESH_TOKEN = "REFRESH_TOKEN";
        public const string DEVICE_TOKEN = "DEVICE_TOKEN";

        // Application Properties keys
        public const string IS_USER_LOGGED_IN = "IS_USER_LOGGED_IN";
        public const string IS_CONNECTED = "IS_CONNECTED";
    }
}