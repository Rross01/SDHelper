function Invoke-SDComputerRemoteConnection {
    
    <#
.Synopsis
    Функция удалённого подключения к компьютеру через CmRcViewer.

.Description
    Функция принимает имя компьютера, и передаёт его в программу CmRcViewer.

    Важно! Для работы требуется установленная консоль администрирования Microsoft Configuration Manager, так как с ним идут библиотеки для Powershell.
    
.Parameter Identifier
    Объект типа String.

.Example
    Invoke-SDComputerRemoteConnection "test-pc" 
    
.Inputs
    Принимает через пайплайн объект типа String.

.Outputs
    Объект типа bool, $true в случае удачной валидации компьютера.

.Link
    https://kb.ertelecom.ru/display/~rossamakhin.ra/SDHelperLibs
#>

    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)]
        [string]
        $ComputerName
    )
    try {
        Start-Process -filepath `
            "${env:ProgramFiles(x86)}\Microsoft Configuration Manager\AdminConsole\bin\i386\CmRcViewer.exe" `
            -ArgumentList "$ComputerName"
        return 1
    }
    catch {
        Write-Host "Не удалось подключиться через CmRcViewer"
        return 0
    }
}