CREATE OR REPLACE TYPE y_objeto AS OBJECT
(
/**
Tipo base para un objeto que puede ser serializado/deserializado con formato JSON.

%author jtsoya539 30/3/2020 09:35:21
*/

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

/** Objeto serializado en formato JSON. */
  json CLOB,

/**
Retorna el objeto deserializado a partir de un JSON.
Cada sub-tipo del tipo base y_objeto debe implementar esta función con los
atributos correspondientes.
  
%author jtsoya539 30/3/2020 09:42:09
%param i_json JSON del objeto a deserializar.
%return Objeto deserializado a partir de un JSON.
*/
  NOT FINAL STATIC FUNCTION parse_json(i_json IN CLOB) RETURN y_objeto,

/**
Retorna el objeto serializado en formato JSON.
Cada sub-tipo del tipo base y_objeto debe implementar esta función con los
atributos correspondientes.
  
%author jtsoya539 30/3/2020 09:42:09
%return Objeto serializado en formato JSON.
*/
  NOT FINAL NOT INSTANTIABLE MEMBER FUNCTION to_json RETURN CLOB
)
NOT FINAL NOT INSTANTIABLE
/
