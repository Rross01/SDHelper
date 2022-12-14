function Show-ComputerMenu {

    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)]
        [string]
        $Identifier
    )

    Write-Host "Выбран компьютер $Identifier, текущий пользователь $(Get-SDComputerCurrentUser -ComputerName $Identifier)" -BackgroundColor White -ForegroundColor Red
    Write-Host 'Выберите пункт:
    1. Основная информация
    2. Аптайм
    3. Список установленного ПО
    4. Подключиться к компьютеру
    5. Вывести лог входящих подключений по RDP
    6. Вывести все кумулятивные обновления
    7. Вывести список активных сессий (требуется доступ через psexec. Шакальная функция, используйте на свой страх и риск)
    8. Разрешить пользователю устанавливать драйвер принтера (требуется доступ через psexec. Тоже шакальная функция).
    0. Предыдущее меню
    '

    if ($identifier -eq "") {
        return $true
    }

    $SelectedParameter = Read-Host

    switch ($SelectedParameter) {
        1 {
            Write-Progress "Выполняю запрос..."
            Get-SDComputerCommonInfo $Identifier | Out-String | Write-Host
            Write-Progress " " -Completed
            Write-Host $ContinuePrompt
            Read-Host
        }
        
        2 {
            Write-Progress "Выполняю запрос..."
            Get-SDComputerUptime $Identifier | Out-String | Write-Host
            Write-Progress " " -Completed
            Write-Host $ContinuePrompt
            Read-Host
        }

        3 {
            Write-Progress "Выполняю запрос..."
            Get-SDComputerInstalledSoft $Identifier | Out-GridView
            Write-Progress " " -Completed
            Read-Host
        }

        4 {
            Write-Progress "Выполняю запрос..."
            Invoke-SDComputerRemoteConnection $Identifier | Out-String | Write-Host
            Write-Progress " " -Completed
            Write-Host $ContinuePrompt
            Read-Host
        }

        5 {
            Write-Progress "Выполняю запрос..."
            Get-SDComputerRDPLog $Identifier | Out-GridView
            Write-Progress " " -Completed
            Write-Host $ContinuePrompt
            Read-Host
        }

        6 {
            Write-Progress "Выполняю запрос..."
            Get-SDComputerQuickFix $Identifier | Out-GridView
            Write-Progress " " -Completed
            Write-Host $ContinuePrompt
            Read-Host
        }

        7 {
            Write-Progress "Выполняю запрос..."
            Get-SDComputerActiveSessions $Identifier | Out-GridView
            Write-Progress " " -Completed
            Write-Host $ContinuePrompt
            Read-Host
        }

        8 {
            Write-Progress "Выполняю запрос..."
            $expression1 = "New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers\PointAndPrint' -Name 'RestrictDriverInstallationToAdministrators' -PropertyType DWORD -Value 0 -Force"
            $commandBytes1 = [System.Text.Encoding]::Unicode.GetBytes($expression1)
            $encodedCommand1 = [Convert]::ToBase64String($commandBytes1)
            psexec.exe \\$Identifier cmd /c "echo . | powershell -EncodedCommand $encodedCommand1"
            Write-Progress " " -Completed
            Write-Host $ContinuePrompt
            Read-Host
        }
        
        0 { return $true }

        default { return $false }
    }
}
