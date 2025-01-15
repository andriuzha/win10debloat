
############################################################################
# Script de optimización de Windows 10
# Author: @andriuzha
# Versión 1.2
# 14 ene 2025
# https://github.com/andriuzha/
############################################################################


# Cambiando la política de ejecución 
Show-Message "Cambiando la política de ejecución a Irrestricta..."
Write-Host "Cambiando la política de ejecución a Irrestricta..."
Set-ExecutionPolicy Unrestricted -Force

# Permisos
Show-Message "Comprobado permisos de ejecución..."
Write-Host "Comprobado permisos de ejecución..."
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# Ejecutando como administrador
Show-Message "El script se esta ejecutando con los permisos correspondientes..."
Show-Message "El script se esta ejecutando con los permisos correspondientes..."
Start-Sleep -Seconds 1

# Función para mostrar diálogos
function Show-Message {
    param (
        [string]$Message
    )
    [System.Windows.Forms.MessageBox]::Show($Message, "Información", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
}

# Ejecutando como administrador
Show-Message "El script iniciará con las tareas de optimización..."
Show-Message "El script iniciará con las tareas de optimización..."

# Pausa
Start-Sleep -Seconds 1

# Habilita Puntos de Restauración 
Show-Message "Habilitando la creación de puntos de restauración..."
Write-Host "Habilitando la creación de puntos de restauración..."
Enable-ComputerRestore -Drive "C:\"

# Punto de restauración 
Show-Message "Creando un punto de restauración..."
Write-Host "Creando un punto de restauración..."
Checkpoint-Computer -Description "Punto de restauración antes de aplicar Essential Tweaks" -RestorePointType "MODIFY_SETTINGS"


# Ajustes Esenciales
Show-Message "Aplicando Essential Tweaks..."
Write-Host "Aplicando Essential Tweaks..."

# O&O Shutup
Show-Message "Ejecutando O&O Shutup con configuración recomendada..."
Write-Host "Ejecutando O&O Shutup con configuración recomendada..."
Import-Module BitsTransfer
Start-BitsTransfer -Source "https://raw.githubusercontent.com/andriuzha/win10debloat/master/ooshutup10.cfg" -Destination ooshutup10.cfg
Start-BitsTransfer -Source "https://dl5.oo-software.com/files/ooshutup10/OOSU10.exe" -Destination OOSU10.exe
Start-Process -FilePath .\OOSU10.exe -ArgumentList "ooshutup10.cfg /quiet" -Wait

# Ajustes del sistema
Show-Message "Aplicando System Tweaks..."
Write-Host "Aplicando System Tweaks..."
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" | Out-Null
Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\ProgramDataUpdater" | Out-Null
Disable-ScheduledTask -TaskName "Microsoft\Windows\Autochk\Proxy" | Out-Null
Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" | Out-Null
Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" | Out-Null
Disable-ScheduledTask -TaskName "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" | Out-Null

# Centro de Actividades
Show-Message "Deshabilitando el Centro de actividades..."
Write-Host "Deshabilitando Action Center..."
If (!(Test-Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer")) {
    New-Item -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" | Out-Null
}
Set-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "DisableNotificationCenter" -Type DWord -Value 1
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" -Name "ToastEnabled" -Type DWord -Value 0

# Modo Oscuro
Show-Message "Activando Modo Oscuro..."
Write-Host "Activando Dark Mode..."
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value 0

# Visual FX
Show-Message "Ajustando los efectos visuales para mejor rendimiento..."
Write-Host "Ajustando efectos visuales para mejor rendimiento..."
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "DragFullWindows" -Type String -Value 0
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Type String -Value 200
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Type Binary -Value ([byte[]](144,18,3,128,16,0,0,0))
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Type String -Value 0
Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "KeyboardDelay" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ListviewAlphaSelect" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ListviewShadow" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAnimations" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Type DWord -Value 3
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\DWM" -Name "EnableAeroPeek" -Type DWord -Value 0

# Aplicaciones en segundo plano
Show-Message "Deshabilitando las aplicaciones en segundo plano..."
Write-Host "Deshabilitando aplicaciones en segundo plano..."
Get-ChildItem -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Exclude "Microsoft.Windows.Cortana*" | ForEach {
    Set-ItemProperty -Path $_.PsPath -Name "Disabled" -Type DWord -Value 1
    Set-ItemProperty -Path $_.PsPath -Name "DisabledByUser" -Type DWord -Value 1
}

# OneDrive
Show-Message "Deshabilitando y eliminando OneDrive..."
Write-Host "Deshabilitando y eliminando OneDrive..."
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive")) {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" -Name "DisableFileSyncNGSC" -Type DWord -Value 1
Stop-Process -Name "OneDrive" -ErrorAction SilentlyContinue
Start-Sleep -s 2
$onedrive = "$env:SYSTEMROOT\SysWOW64\OneDriveSetup.exe"
If (!(Test-Path $onedrive)) {
    $onedrive = "$env:SYSTEMROOT\System32\OneDriveSetup.exe"
}
Start-Process $onedrive "/uninstall" -NoNewWindow -Wait
Start-Sleep -s 2
Stop-Process -Name "explorer" -ErrorAction SilentlyContinue
Start-Sleep -s 2
Remove-Item -Path "$env:USERPROFILE\OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path "$env:PROGRAMDATA\Microsoft OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path "$env:SYSTEMDRIVE\OneDriveTemp" -Force -Recurse -ErrorAction SilentlyContinue
If (!(Test-Path "HKCR:")) {
    New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null
}
Remove-Item -Path "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Recurse -ErrorAction SilentlyContinue

# Cortana
Show-Message "Deshabilitando Cortana..."
Write-Host "Deshabilitando Cortana..."
If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings")) {
    New-Item -Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" -Force | Out-Null
}
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" -Name "AcceptedPrivacyPolicy" -Type DWord -Value 0
If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization")) {
    New-Item -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Force | Out-Null
}
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Name "RestrictImplicitTextCollection" -Type DWord -Value 1
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Name "RestrictImplicitInkCollection" -Type DWord -Value 1
If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore")) {
    New-Item -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" -Force | Out-Null
}
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" -Name "HarvestContacts" -Type DWord -Value 0
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search")) {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Type DWord -Value 0

# Microsoft Store
Show-Message "Eliminando aplicaciones de Microsoft Store..."
Write-Host "Eliminando aplicaciones de Microsoft Store..."
Get-AppxPackage -AllUsers | Remove-AppxPackage

# Windows Update
Show-Message "Configurando Windows Update para solo actualizaciones de seguridad..."
Write-Host "Configurando Windows Update para solo actualizaciones de seguridad..."
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU")) {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoUpdate" -Type DWord -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "AUOptions" -Type DWord -Value 2

# Google Chrome
Show-Message "Instalando Google Chrome..."
Write-Host "Instalando Google Chrome..."
winget install -e Google.Chrome | Out-Host


# Política de ejecución 
Show-Message "Restaurando la política de ejecución a Restricta..."
Write-Host "Cambiando la política de ejecución a Restricta..."
Set-ExecutionPolicy Restricted -Force

# Mostrando aviso de éxito y reinicio en 10 segundos
Show-Message "https://github.com/andriuzha"
Write-Host "https://github.com/andriuzha"

# Pausa 
Start-Sleep -Seconds 2

# Mostrando aviso de éxito y reinicio en 10 segundos
Show-Message "La operación se realizó con éxito. El equipo se reiniciará en 10 segundos."
Write-Host "La operación se realizó con éxito. El equipo se reiniciará en 10 segundos."

# Pausa
Start-Sleep -Seconds 10

# Reiniciar el sistema
Restart-Computer -Force

