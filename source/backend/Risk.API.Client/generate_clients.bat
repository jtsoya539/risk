@echo off
:: ======================= Variables de entorno =======================
set RISK_HOME=
set SWAGGER_SPEC_URL=
set CLIENT_VERSION=
set API_KEY=
:: ====================================================================

:: =================== Definiciones de generadores ====================
:: Generador por defecto
set generator=1

set generator_count=2
set generator[0]=Todos
set generator[1]=openapi-generator-cli.jar
set generator[1].url=https://repo1.maven.org/maven2/org/openapitools/openapi-generator-cli/7.6.0/openapi-generator-cli-7.6.0.jar
set generator[2]=swagger-codegen-cli.jar
set generator[2].url=https://repo1.maven.org/maven2/io/swagger/codegen/v3/swagger-codegen-cli/3.0.57/swagger-codegen-cli-3.0.57.jar
:: ====================================================================

:: ===================== Definiciones de clientes =====================
set client_count=3
set client[0]=Todos
set client[1]=csharp
set client[1].dir=Risk.API.Client
set client[2]=java
set client[2].dir=Risk.API.JavaClient
set client[3]=kotlin
set client[3].dir=Risk.API.KotlinClient
:: ====================================================================

:Menu
setlocal EnableDelayedExpansion
cls
echo ************************************************************
echo.
echo Seleccione una opcion:
echo.
echo ************************************************************
echo.
echo 1. Descargar generador
echo.
echo 2. Generar cliente
echo.
echo 3. Actualizar documentacion
echo.
echo 4. Publicar cliente
echo.
echo ------------------------------------------------------------
echo.
echo 5. Mostrar variables de entorno
echo.
echo 6. Seleccionar generador
echo.
echo 99. Salir
set var=
set /p var=
if %var%==99 (
  cls
  exit
) else (
  if %var% LSS 0 (
    echo Error
    goto :Menu
  ) else if %var% GTR 6 (
    echo Error
    goto :Menu
  ) else (
	if %var%==1 goto :Primero
	if %var%==2 goto :Segundo
	if %var%==3 goto :Tercero
	if %var%==4 goto :Cuarto
	if %var%==5 goto :Quinto
	if %var%==6 goto :Sexto
  )
)
goto :Menu

:Primero
setlocal EnableDelayedExpansion
cls
echo ************************************************************
echo.
echo Seleccione un generador para descargar:
echo.
echo ************************************************************
echo.
(for /L %%i in (0,1,%generator_count%) do (
  echo %%i. !generator[%%i]!
  echo.
))
echo 99. Atras
set var=
set /p var=
if %var%==99 (
  goto :Menu
) else (
  if %var% LSS 0 (
    echo Error
    goto :Primero
  ) else if %var% GTR %generator_count% (
    echo Error
    goto :Primero
  ) else (
    if %var%==0 (
	  (for /L %%j in (1,1,%generator_count%) do (
		call :DescargarGenerador %%j 0
      ))
    ) else (
	  call :DescargarGenerador %var% 1
    )
  )
)
goto :Primero

:Segundo
setlocal EnableDelayedExpansion
cls
echo ************************************************************
echo.
echo Seleccione un cliente para generar:
echo.
echo ************************************************************
echo.
(for /L %%i in (0,1,%client_count%) do (
  echo %%i. !client[%%i]!
  echo.
))
echo 99. Atras
set var=
set /p var=
if %var%==99 (
  goto :Menu
) else (
  if %var% LSS 0 (
    echo Error
    goto :Segundo
  ) else if %var% GTR %client_count% (
    echo Error
    goto :Segundo
  ) else (
    if %var%==0 (
	  (for /L %%j in (1,1,%client_count%) do (
	    call :GenerarCliente %%j 0
      ))
    ) else (
	  call :GenerarCliente %var% 1
    )
  )
)
goto :Segundo

:Tercero
setlocal EnableDelayedExpansion
cls
echo ************************************************************
echo.
echo Seleccione una documentacion para actualizar:
echo.
echo ************************************************************
echo.
(for /L %%i in (0,1,%client_count%) do (
  echo %%i. !client[%%i]!
  echo.
))
echo 99. Atras
set var=
set /p var=
if %var%==99 (
  goto :Menu
) else (
  if %var% LSS 0 (
    echo Error
    goto :Tercero
  ) else if %var% GTR %client_count% (
    echo Error
    goto :Tercero
  ) else (
    if %var%==0 (
	  (for /L %%j in (1,1,%client_count%) do (
	    call :ActualizarDocumentacion %%j 0
      ))
    ) else (
	  call :ActualizarDocumentacion %var% 1
    )
  )
)
goto :Tercero

:Cuarto
setlocal EnableDelayedExpansion
cls
echo ************************************************************
echo.
echo Seleccione un cliente para publicar:
echo.
echo ************************************************************
echo.
(for /L %%i in (0,1,%client_count%) do (
  echo %%i. !client[%%i]!
  echo.
))
echo 99. Atras
set var=
set /p var=
if %var%==99 (
  goto :Menu
) else (
  if %var% LSS 0 (
    echo Error
    goto :Cuarto
  ) else if %var% GTR %client_count% (
    echo Error
    goto :Cuarto
  ) else (
    if %var%==0 (
	  (for /L %%j in (1,1,%client_count%) do (
	    call :PublicarCliente %%j 0
      ))
    ) else (
	  call :PublicarCliente %var% 1
    )
  )
)
goto :Cuarto

:Quinto
cls
echo ************************************************************
echo.
echo Variables de entorno
echo.
echo ************************************************************
echo.
echo RISK_HOME=%RISK_HOME%
echo.
echo SWAGGER_SPEC_URL=%SWAGGER_SPEC_URL%
echo.
echo CLIENT_VERSION=%CLIENT_VERSION%
echo.
echo API_KEY=%API_KEY%
echo.
echo GENERATOR=!generator[%generator%]!
echo.
Pause
goto :Menu

:Sexto
cls
echo ************************************************************
echo.
echo Seleccione un generador:
echo.
echo ************************************************************
echo.
(for /L %%i in (1,1,%generator_count%) do (
  if %%i==%generator% (
    echo %%i. !generator[%%i]! [ACTUAL]
  ) else (
    echo %%i. !generator[%%i]!
  )
  echo.
))
echo 99. Atras
set var=
set /p var=
if %var%==99 (
  goto :Menu
) else (
  if %var% LSS 1 (
    echo Error
    goto :Sexto
  ) else if %var% GTR %generator_count% (
    echo Error
    goto :Sexto
  ) else (
	if %var%==1 set generator=1
	if %var%==2 set generator=2
  )
)
goto :Menu

:DescargarGenerador
cls
echo Descargando generador !generator[%1]!...
cd %RISK_HOME%\source\backend\Risk.API.Client
del /q !generator[%1]!
set client_cmd=powershell -command "Invoke-WebRequest -OutFile !generator[%1]! !generator[%1].url!"
call %client_cmd%
if %2==1 Pause
goto :eof

:GenerarCliente
cls
echo Generando cliente !client[%1]!...
cd %RISK_HOME%\source\backend\Risk.API.Client
rd /s /q !client[%1].dir!
if %generator%==1 (
  set client_cmd=java -Dio.swagger.parser.util.RemoteUrl.trustAll=true -Dio.swagger.v3.parser.util.RemoteUrl.trustAll=true -jar !generator[%generator%]! generate -i %SWAGGER_SPEC_URL% -o !client[%1].dir! -g !client[%1]! -c config-!client[%1]!.json
) else if %generator%==2 (
  set client_cmd=java -jar !generator[%generator%]! generate -i %SWAGGER_SPEC_URL% -o !client[%1].dir! -l !client[%1]! -c config-!client[%1]!.json
)
call %client_cmd%
if %2==1 Pause
goto :eof

:ActualizarDocumentacion
cls
echo Actualizando documentacion de cliente !client[%1]!...
rd /s /q %RISK_HOME%\docs\backend\clients\!client[%1]!
echo D | xcopy /Y %RISK_HOME%\source\backend\Risk.API.Client\!client[%1].dir!\docs %RISK_HOME%\docs\backend\clients\!client[%1]!\docs
echo F | xcopy /Y %RISK_HOME%\source\backend\Risk.API.Client\!client[%1].dir!\README.md %RISK_HOME%\docs\backend\clients\!client[%1]!\README.md
if %2==1 Pause
goto :eof

:PublicarCliente
cls
echo Publicando cliente !client[%1]!...
if %1==1 (
  echo Abriendo archivo .csproj...
  notepad %RISK_HOME%\source\backend\Risk.API.Client\!client[%1].dir!\src\Risk.API.Client\Risk.API.Client.csproj
  dotnet pack %RISK_HOME%\source\backend\Risk.API.Client\!client[%1].dir!\src\Risk.API.Client\Risk.API.Client.csproj
  dotnet nuget push %RISK_HOME%\source\backend\Risk.API.Client\!client[%1].dir!\src\Risk.API.Client\bin\Debug\Risk.API.Client.%CLIENT_VERSION%.nupkg -k %API_KEY% -s https://api.nuget.org/v3/index.json
) else (
  echo No es posible publicar este cliente
)
if %2==1 Pause
goto :eof