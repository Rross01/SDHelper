function Invoke-SDMsiInstall {
    
    <#
.Synopsis
    Функция удалённой установки любого msi пакета.

.Description
    Функция принимает имя компьютера, и путь к msi пакету.

    Важно! У вас должен быть доступ к этому пути (спасибо, Кэп).
    
.Parameter ComputerName
    Объект типа String.

.Parameter Path
    Объект типа String.

.Example
    SDMsiInstall "ekat-" 
    
.Outputs
    Объект типа bool, $true в случае удачной валидации компьютера.

.Link
    https://kb.ertelecom.ru/display/~rossamakhin.ra/SDHelperLibs
#>

    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)]
        [string]
        $ComputerName,
        [parameter(Mandatory = $true)]
        [string]
        $Path
    )
    try {

        # Парсинг пути с разделением на папку, и имя.
        # Всё из-за странного синтаксиса Robocopy.
        $filename = $Path.Split("\")[-1]
        $folder = $Path.Replace($filename, "")

        # Копируем в c:\temp
        robocopy $folder "$ComputerName\c$\temp" $filename /mt /z

        # Костыль для нормального выполнения удалённой команды.
        $destinationPath = "$ComputerName\c$\temp\$filename"
        $expression = "msiexec /i $destinationPath /quiet"
        $commandBytes = [System.Text.Encoding]::Unicode.GetBytes($expression)
        $encodedCommand = [Convert]::ToBase64String($commandBytes)
        psexec.exe \\$ComputerName cmd /c "echo . | powershell -EncodedCommand $encodedCommand"
    }
    catch {
        Write-Host "Не удалось подключиться через CmRcViewer"
        return 0
    }
}