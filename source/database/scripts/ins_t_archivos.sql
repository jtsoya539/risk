set define off
declare
  type   t_clob is table of clob index by binary_integer;
  l_clob t_clob;
  type   t_varchar2 is table of varchar2(64) index by binary_integer;
  l_varchar2 t_varchar2;
  l_blob     blob;
  FUNCTION base64decode(p_clob CLOB)
    RETURN BLOB
  -- -----------------------------------------------------------------------------------
  -- File Name    : https://oracle-base.com/dba/miscellaneous/base64decode.sql
  -- Author       : Tim Hall
  -- Description  : Decodes a Base64 CLOB into a BLOB
  -- Last Modified: 09/11/2011
  -- -----------------------------------------------------------------------------------
  IS
    l_blob    BLOB;
    l_raw     RAW(32767);
    l_amt     NUMBER := 7700;
    l_offset  NUMBER := 1;
    l_temp    VARCHAR2(32767);
  BEGIN
    BEGIN
      DBMS_LOB.createtemporary (l_blob, FALSE, DBMS_LOB.CALL);
      LOOP
        DBMS_LOB.read(p_clob, l_amt, l_offset, l_temp);
        l_offset := l_offset + l_amt;
        l_raw    := UTL_ENCODE.base64_decode(UTL_RAW.cast_to_raw(l_temp));
        DBMS_LOB.append (l_blob, TO_BLOB(l_raw));
      END LOOP;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        NULL;
    END;
    RETURN l_blob;
  END;
begin

  null;
  -- start generation of records
  -----------------------------------

  l_clob(1) :=q'!TEXTOS!';
  l_clob(2) :=q'!ARCHIVO!';
  l_clob(3) :=q'!email-inlined.html!';
  l_clob(4) :=q'!!';
  l_blob :=empty_blob();
  l_clob(4) :=l_clob(4) || q'!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!';
  l_clob(4) :=l_clob(4) || q'!tKrTploLq3SLVBu3Ej4lHPSEPRjd2ObrwpmjRFK6v/rgYjntvBmPJyVnm9zpbM65LhPJhwtGsFA5IZfp2ARVJTkiltWvwgBwcGJ4hIb1TcfqyrmlvPvsne7VD4O6EFWdEay95rhRI38GzscrqSiv9FWshJeWgJaqWdFhume/DgelSVWWDmUQbwAey0Gfx2/u60Jhw8GXlW/yESe1LbOo3TBVSX8bVT83/w+yQr1ghh4AAA==!';
  l_blob :=utl_compress.lz_uncompress(base64decode(l_clob(4)));
  l_clob(5) :=q'!!';
  l_clob(6) :=q'!1B91B8D05DF4299D1177E64F4E1E2C699FA50410!';
  l_varchar2(7) :=q'!7814!';
  l_clob(8) :=q'!email-inlined!';
  l_clob(9) :=q'!html!';
  l_varchar2(10) :=q'!!';


  insert into t_archivos
  (
     "TABLA"
    ,"CAMPO"
    ,"REFERENCIA"
    ,"CONTENIDO"
    ,"URL"
    ,"CHECKSUM"
    ,"TAMANO"
    ,"NOMBRE"
    ,"EXTENSION"
    ,"VERSION_ACTUAL"
  )
  values
  (
     to_char(l_clob(1))
    ,to_char(l_clob(2))
    ,to_char(l_clob(3))
    ,l_blob
    ,to_char(l_clob(5))
    ,to_char(l_clob(6))
    ,to_number(l_varchar2(7))
    ,to_char(l_clob(8))
    ,to_char(l_clob(9))
    ,to_number(l_varchar2(10))
  );

  l_clob(1) :=q'!TEXTOS!';
  l_clob(2) :=q'!ARCHIVO!';
  l_clob(3) :=q'!email-table-aux-inlined.html!';
  l_clob(4) :=q'!!';
  l_blob :=empty_blob();
  l_clob(4) :=l_clob(4) || q'!H4sIAAAAAAAAA91YbW/bNhD+7l/BKFixAVXiOGmQWnYwJ3GxAG0yZM42bBgGWqItLpSokbRjb8h/35GiZL3aTdtgw5wPkci74z139xzPHuwF3FfrhKBQRey8M0j/wX+Cg/MOQoOIKIxiHJGhs6TkMeFCOcjnsSKxGjqPNFDhMCBL6hPXvDgbrVCpxCV/Luhy6FymGu4EziroK7JSh/pMD/khFpKo4f3knXuWWlFUMXL+anI9uX9/OzhMX/WGVGv99G1EAooRj9kaSV8QEiMcB+jrCK9SZ/rotNdNVt+gv0FL4Skjv/oMSzmc8mD9GwqPzAZCM/DHlfQv0ke9s2SF9mikgeJYeWY/wmJOY3fKleJRHx11azJPncYTkted+uKCNa3yxlUVNK3KBMdN67iO5+j0Y309eBQ4SYhoMnyAhaI+I9Z+goOAxvPnROLA5rxqofsMdUxjInYZQMim/qjb/eojjUdg2dqdchEQ4TIyU1kN1U+wQgIHdCG3CdB52GqmzZmpitNl69Hz4WgL+JO1aTR3BZEJjyVdZk6EREPpI7xQvIEeOd8azsl9aNB96jxlLMaMmbMOxitFRIzZpXaqjiJ3vSz4ulNRTGorKWsqi5oqtUXNuspSQJfWFwZV6GbxKHsE/GHEBYGHPP4+Z1z0EY1DIqiqhcYwdYYjytY7hFI6bxV5tE61CZU8bxPSLdkNiM8FVpTHfRTzmDSVzv4HIiWekx/hWriA0mmBvMVqG7r20LSDbUe4SQ/wwk0EhW6+tgxTQT/ky7ypTLH/MBd8EQeuBbF/fHLy9k0j/pI5/El28kax47SnzuDQ3nmDw/Rq7gw0XVHKXMdBZnvoNJw8O9V/XjmeEsfSlRCemYcglNMHCnsmERHnKjSdFY6nmFEsSeCVrpSTZOVVaHBw4tlbEhqdV+jOYD6Srkm/1nZx8MdCZsTJj27ZT8cAzdsMaCKIxk9EjtjCVAIQJVjAFeMBWWXC8NpWWd68up5pVZXXrD17iCfYp2qdPkM2Z4w/9lFIg4DEICu5C88QAGhVHlpSSaeUGflMJDflnL8a31yOLsa/jK5gctEI0onGVJ3g2nGAIsFbwwfHFsLQ6cJ0RBizAczfpXYte09DofO/yXteRwwnEnyUBIKBFUn9Nue6xgrsdRNVXBbF5S0FVGzCTvo2dPQbeD83wkPHCpvEabwifdCPQeZrayHWagxyAGMHZi6U4RwqS/HES1uJXdDXdKHaYHYDz5ZmE4ZLnjjIPmtBSEo8lYkHk2RQdMvGM58wnBdzNK/LKeP+Q6n83px1taHSZJWH3G7mBDNX6SYHsL0NtYUKYPUlVkAL1VcooJVGZM62xQRLTS6XfNgJAY7PzwcP9lwX/TAZ3U3Q5fhmMr4bX6GfvruejNHl7c1kdH0zvkOue17UaKeMRaKHt5fkgWaA+XjVue+4kKIGVpSQl7B/AKQGMcQAje7GowroEnM2S3mp2kn95Qq1rRry3Pa6O6hWcf5L9b4vneZt2asiaMzKf6i7NXoGvoW9yl253zWfLSNBacI60aJbr/vK9+Nj0weKSHxINhH6Wky/zP8+GV28H8Es06uQZPN5ZUTaME1bEgF6o/ufU/NHn6Pc+xzl4zZQhR6gBcfo3e3tpNbzShqFnj2D0aw4+TCCheanCvMUQFVkd0dD/Mvl3nbk/4OrGyytCcsEgsql6Jq7bnd3bSRwia7ZW+mno81qIVsZNd+aT7lb9Nro1NgM0k2g2vfX44xnm4GnMQKH22IEuzoXrQV6CBXauqnrfXxzVa/25jba4mizgy2O1Y3U1XO/mm/iTkm3ekiuvHWE2UxdxQBVZ89//dKojsRZrHLc8I1Tf9MwD+bX4X8A1UWCAzQWAAA=!';
  l_blob :=utl_compress.lz_uncompress(base64decode(l_clob(4)));
  l_clob(5) :=q'!!';
  l_clob(6) :=q'!04418F8CAF3BB1400D6FBABECBBDA8EB1DFB4B92!';
  l_varchar2(7) :=q'!5684!';
  l_clob(8) :=q'!email-table-aux-inlined!';
  l_clob(9) :=q'!html!';
  l_varchar2(10) :=q'!!';


  insert into t_archivos
  (
     "TABLA"
    ,"CAMPO"
    ,"REFERENCIA"
    ,"CONTENIDO"
    ,"URL"
    ,"CHECKSUM"
    ,"TAMANO"
    ,"NOMBRE"
    ,"EXTENSION"
    ,"VERSION_ACTUAL"
  )
  values
  (
     to_char(l_clob(1))
    ,to_char(l_clob(2))
    ,to_char(l_clob(3))
    ,l_blob
    ,to_char(l_clob(5))
    ,to_char(l_clob(6))
    ,to_number(l_varchar2(7))
    ,to_char(l_clob(8))
    ,to_char(l_clob(9))
    ,to_number(l_varchar2(10))
  );

  l_clob(1) :=q'!TEXTOS!';
  l_clob(2) :=q'!ARCHIVO!';
  l_clob(3) :=q'!email-table-inlined.html!';
  l_clob(4) :=q'!!';
  l_blob :=empty_blob();
  l_clob(4) :=l_clob(4) || q'!H4sIAAAAAAAAA91YbW/bNhD+7l/BKFixAVXsOGmQWnYwJ3GxAG0yZO4GbBgGWqItLpSokbRjd8h/35GiZL3aTdFgw5wPkY7H4z139xzPHh4E3FebhKBQReyiM0z/wX+Cg4sOQsOIKIxiHJGRs6LkMeFCOcjnsSKxGjmPNFDhKCAr6hPXvDjbXaFSiUv+WtLVyLlKd7hTOKuwX5G16uozPeSHWEiiRh+n79zz1IqiipGLV9Ob6cf3d8Nu+qoXpNrop+8jElCMeMw2SPqCkBjhOEDfRnidOjNAZ/1esv4O/Q27FJ4x8pvPsJSjGQ82v6Pw2CwgNAd/XEk/kQHqnydrdEAjDRTHyjPrERYLGrszrhSPBui4V9N56jSekLzu1IVL1iTljVIVNEllguMmOa7jOT77XF+PHgVOEiKaDB9hoajPiLWf4CCg8eI5kTiyOa9a6D1jO6YxEfsMIGRTf9zrffOZxiOwbO3OuAiIcBmZq6yG6idYJYEDupS7FOgibDXT5sxMxanYevR8ONoC/uLdNFq4gsiEx5KuMidCoqEMEF4q3kCPnG8N5+Q+NOx96jxlLMaMmbOOJmtFRIzZlXaqjiJ3vaz4ulPZmNQkKWsqQk2VmlCzriIK6Mr6wqAK3SweZY+AP4y4oPCQx9/njIsBonFIBFW10BimznFE2WaPUkrnnSqP1qk2pZLnbUq6JbsB8bnAivJ4gGIek6bSOfxApMQL8jNcC5dQOi2Qd1htQ9cemnaw7Qi36QFeuImg0M03lmEqGIR8lTeVGfYfFoIv48C1IA5PTk/fvmnEXzKHv8hO3ij2nPbUGXbtnTfspldzZ6jpilLmOg4yyyOn4eT5mf7zyvGUOJauhPDMPQShnD1QWDOJiDhXoemscDzFjGJJAq90pZwma69Cg6NTz96S0Oi8QncG85F0Tfr1bhcHfy5lRpz86Jb1dAzQvM2AJoJo/ETkiC1MJQBRggVcMR6QVSYMb2yV5c2r55lWVXnN2rOHeIJ9qjbpM2RzzvjjAIU0CEgMupK78AwBgFbloRWVdEaZ0c9UclPOxavJ7dX4cvLr+BomF40gnWhM1QmuHQcoErw1fHBsIYycHkxHhDEbwPxdatey9zQUOv/bvOd1xHAiwUdJIBhYkdRvc65rrMBaL1FFsSiKdxRQsQk76dvI0W/g/cIojxyrbBKn8Yr0QT8Gma+thVirMcgBjB2YuVCGC6gsxRMvbSVWoK/pQrXB7AaercwiDJc8cZB91oqQlHgmEw8myaDolo1nPmE4L+ZoXpczxv2HUvm9Oe9pQ6XJKg+5XcwJZq7SbQ5geRdqCxXA6kusgBaqr1BAa43InG2LCURNLpd82AsBjs/PBw8OXBf9NB3fT9HV5HY6uZ9co19+uJlO0NXd7XR8czu5R657UdzRThmLRA9vL8kDzQDz8apz30khRQ2sKCEvYf8ASA1iiAEa30/GFdAl5mxFeanaSf3lCrWtGvLc9nt7qFZx/mv1vq+d5l3ZqyJozMp/qLs1ega+hf3KXXnYM58dI0FpwjrVqjuv+8r34xPTB4pIfEg2EVZmruo5F6Dp44Qq0PlE9JWZftH/Yzq+fD+GOadfIdD288qotK0WiKb1Jujd3d201lhKOwqNcQ7zT3G8YAQLTQIV5jgh9FmDbgJZqqm2I/8fhNhiaSHGViGo3DyuuVD2t7BGlpQ4kb2Vfp/ZSgvZyur/rfmUKdlvSWcz49JFqNkfbyZZwW6nisYIdHfFCFZ1LloLtAsV2rqo631ye12v9uZe1eJos4MtjtWN1LfnfjVfd53S3uoh+eadc8J2tCkGqDrg/euduTp3ZrHKccPXOj3OmwfzE+w/vhm38pkVAAA=!';
  l_blob :=utl_compress.lz_uncompress(base64decode(l_clob(4)));
  l_clob(5) :=q'!!';
  l_clob(6) :=q'!1AB33EC8FE8DB347B4EA1749A913D7D9C4837B0E!';
  l_varchar2(7) :=q'!5529!';
  l_clob(8) :=q'!email-table-inlined!';
  l_clob(9) :=q'!html!';
  l_varchar2(10) :=q'!!';


  insert into t_archivos
  (
     "TABLA"
    ,"CAMPO"
    ,"REFERENCIA"
    ,"CONTENIDO"
    ,"URL"
    ,"CHECKSUM"
    ,"TAMANO"
    ,"NOMBRE"
    ,"EXTENSION"
    ,"VERSION_ACTUAL"
  )
  values
  (
     to_char(l_clob(1))
    ,to_char(l_clob(2))
    ,to_char(l_clob(3))
    ,l_blob
    ,to_char(l_clob(5))
    ,to_char(l_clob(6))
    ,to_number(l_varchar2(7))
    ,to_char(l_clob(8))
    ,to_char(l_clob(9))
    ,to_number(l_varchar2(10))
  );

  l_clob(1) :=q'!IMAGENES!';
  l_clob(2) :=q'!ARCHIVO!';
  l_clob(3) :=q'!x-mark-5-256.jpg!';
  l_clob(4) :=q'!!';
  l_blob :=empty_blob();
  l_clob(4) :=l_clob(4) || q'!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!';
  l_clob(4) :=l_clob(4) || q'!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!';
  l_clob(4) :=l_clob(4) || q'!1twO0PLrb4ATL8fK++HMtK1EWv1XcD/gixm6MkAXNIKfXfegPUt035hzzNQ+T+lrtdzoqvzzmMNYPv3VobgZU5DLDaL/QFmO2Y4TnGMwmx7FIF2CxcsSy8dHnT/TRPR/gSVAapchPfOVecQdi3f8aFRBo+cwhRLpupcvZfIIhm+KJOiLm63GhJaUXMojCeoI1IuB2YQC2T0tDJJ5m4f7Owfb3TclYtRYgASmJpev7VFPTE37UKfnlabhhALsbwi2jQazbRPVgh2EOoFkAGmmI4wkulTMCBeAZPgEkoEP7S439bS1YhD6n7Il6StZ/huE6TT4twizUPdPCHOO37nJILXtASIqWUa+TPXCSLxMwrUMmegIe33l4clfe1NBMMxAkZf7GxRB30BRBmi5HIwoU1SJGkwR9q5CtefM7dSYdDvfFVaZCUrDbxjaTd+wassEqVbUx6GiV+VwHpgSmqk99/xHYJifnn+BKniY37HSXaZ8V0xztt1tCnz4p1pmBJw8wB7ZKDdG8EUWMFaKHdHJaiOqM3WKsPM9MLbWH2duF4tlBLvBxspYACjsbUQjpk5x4jwYtuekLJz9b2oLgRjsrmTnjC+DHyvge2u2Kh7Xgyoym1Y6zsjfm7w4pwYqXDG4V6/9HWVPTdUGzagnC38r+Pbr2CUTR9qveLPdMlZ/G8TXRW1p+cAIBnrki2FcTO3+rPhl16F6ZS3GNhJS8nVbr0YUgGZjLr0eWQvmia7UYy0JCwvGmeWK+PLxDo4xg8LoTsSdDJkd2UWy3+83WK/wASgY3PZ4eP518/Rvl8PBMjzeY3Owg3Y7mXsoPFD7eXo+9DrZSd0xb77E20b8iw5ex8nnCJz6a2xWbH8IWuS/VsVbaezT1JUJFrAiCJ4/yT4/vOaDBUMXCtIvEMyOx0+/osQeRDcBXwxYhLiurlwhD6XUgDzSE+Z1/Pf/ZAF8i5e2HS9oVB0syD8hP9S9Nuxmbt1E+DixoFleowLS4B5Ig1n7r2piwFYTihQmvpmAmzSQOR9wZ1jhdZ3JOFiwJ+6x75wzvh6m8il49wSLml49+jGimIJqfIHi/ijpNJEL+ATNH+kdEh74C3EkBrPwaMEyb8hU8cOkFObGj72U8AyKuOJjLWETe0GluiYCYxyk7VxLwEE5W0G2/vbHIKezgFoklVmWwbypSPyblgi1D5r22z/B1iJnmWUVzJuuRNTflSTkmW7/50jyR2NjXdULKZ+GEIqKsoPF6xUklNCj2Mr/Yj8L/uv99P6qzmhDHJQiHX1/5sCjDDmFI0VgrezXwUFh35R0z2+QwocGNtE76twRuLILwcKPCWhvcNNii046mm4OmZTy4UKG86bnXkdESX+QuQBSLf1XpHcxwWqsy6PTtiZaMxtfHj4K1cMZy+bU3UnjVYB3pgzjtyxhwDIMQ/Uom80KJQXk781cXMjBrahbNymBdUQnOdR9RnJeuF9bEowkIWrbyaVnkj8qHF0+b4eYHD8jnPnsCBGfW1+wY8DhtZZshYTqecTfmqF/ruQBrn/TDuGRP8SDXP6Dxkl+CuzjNPUzicSsfv39dfr1YiuJUyTv76IzRUz58qRD/RuPHf0pr/kvsACBg2Lf5qnCTEJZs4GVhJRGnbt7ZJn9ulr8G0ohO/rpT+1Nx3+xx9K/2uOTHNyXwHTZJlafH+I3BiZ/KbuqXkl2v1KMJEZpGvHClMJGAtf4vzcseMAQigmZ5geRES4lX0weOB0KIqM7OeKcYvWik65ZowyGzikwdM44Nc4hvb/7+P9BIH478+8EYou/WIuF61/VMb14N/YnEQtQACmTaz5/dhQ7wI6CFAq2pBbyIF02jlSsN6E/TEwG/eMbJqtR8Z1dvwHLqffmwgNNlyzLvjjw4/jPDnwEE98bLqLuw3b7O1eaBm8VYEMe8n9b2KhTCJtP0jn4+4+GNDQMekAJVogQQlh1tZOdkj5R/f1lW22F9Xu95zZEukDzU0RNDFUsL9p8k5i8AdCl!';
  l_clob(4) :=l_clob(4) || q'!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!';
  l_clob(4) :=l_clob(4) || q'!8A/lfhP4Gx1GVWu0vCSmGU+hxr8p2JsTNJFYtQzeGcbq/A/+FeTlvx8AAA==!';
  l_blob :=utl_compress.lz_uncompress(base64decode(l_clob(4)));
  l_clob(5) :=q'!!';
  l_clob(6) :=q'!A6076C01DE62A2D6B53BA6F923973B6E3743BC5F!';
  l_varchar2(7) :=q'!8127!';
  l_clob(8) :=q'!x-mark-5-256!';
  l_clob(9) :=q'!jpg!';
  l_varchar2(10) :=q'!!';


  insert into t_archivos
  (
     "TABLA"
    ,"CAMPO"
    ,"REFERENCIA"
    ,"CONTENIDO"
    ,"URL"
    ,"CHECKSUM"
    ,"TAMANO"
    ,"NOMBRE"
    ,"EXTENSION"
    ,"VERSION_ACTUAL"
  )
  values
  (
     to_char(l_clob(1))
    ,to_char(l_clob(2))
    ,to_char(l_clob(3))
    ,l_blob
    ,to_char(l_clob(5))
    ,to_char(l_clob(6))
    ,to_number(l_varchar2(7))
    ,to_char(l_clob(8))
    ,to_char(l_clob(9))
    ,to_number(l_varchar2(10))
  );

end;
/
