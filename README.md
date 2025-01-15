# win10debloat
Configuración para las instalaciones de Windows 10
Probada solo en la versión 20H2



## Optimizaciones del Sistema que se realizan:

**Desactivación de telemetría:** Impide que Windows envíe datos de uso a Microsoft.

**Desactivación de tareas programadas:** Deshabilita diversas tareas programadas que recopilan datos o realizan actualizaciones no esenciales.

**Desactivación del Centro de actividades:** Oculta las notificaciones del Centro de actividades.

**Activación del Modo Oscuro:** Cambia la interfaz de Windows al modo oscuro.

**Ajustes de efectos visuales:** Reduce los efectos visuales para mejorar el rendimiento del sistema.

**Desactivación de aplicaciones en segundo plano:** Impide que las aplicaciones se ejecuten en segundo plano y consuman recursos.

**Desactivación y eliminación de OneDrive:** Deshabilita la sincronización de archivos con OneDrive y elimina los archivos locales.

**Desactivación de Cortana:** Deshabilita el asistente virtual de Windows.

**Eliminación de aplicaciones de la Microsoft Store:** Desinstala las aplicaciones preinstaladas de la Microsoft Store.

**Configuración de Windows Update:** Configura Windows Update para que solo instale actualizaciones de seguridad.

**Instalación de Google Chrome:** Instala el navegador Google Chrome.


## Instrucciónes:

Ejecute Powershell como administrator

Coloque la siguiente línea :

``
Set-ExecutionPolicy Unrestricted -Force
``

A continuación coloque el path completo del script, por ejemplo 

``
c:\temp\win10debloat\script.ps1
``

Eso es todo, espere a que se realicen los cambios, termine el proceso y se reinicie el sistema.

