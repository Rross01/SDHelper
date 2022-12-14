function Show-UserMenu {

    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)]
        [string]
        $Identifier
    )

    Write-Host "Выбран пользователь $Identifier" -BackgroundColor White -ForegroundColor Red
    Write-Host 'Выберите пункт:
    1. Основная информация о пользователе
    2. Список групп
    3. Список групп, включая группы в штате
    4. Список компьютеров, где пользователть авторизован
    5. Разблокировать (в разработке)
    0. Предыдущее меню
    '

    if ($identifier -eq "") {
        return $true
    }

    $SelectedParameter = Read-Host

    switch ($SelectedParameter) {
        1 {
            Write-Progress "Выполняю запрос..."
            Get-SDUserCommonInfo $Identifier | Out-String | Write-Host
            Write-Host $ContinuePrompt
            Read-Host
        }
        
        2 {
            Write-Progress "Выполняю запрос..."
            Get-SDUserGroups $Identifier | Out-GridView
            Write-Host $ContinuePrompt
            Read-Host
        }
        
        3 {
            Write-Progress "Выполняю запрос..."
            Get-SDUserGroups $Identifier -Shtat | Out-GridView
            Write-Host $ContinuePrompt
            Read-Host
        }

        4 {
            Write-Progress "Выполняю запрос..."
            $Computers = Get-SDUserComputers $Identifier
            Write-Progress " " -Completed

            # Костыль с проверкой количества объектов в массиве, ибо массив,
            # состоящий из PSCustomObject перестаёт быть массивом, когда в нём 1 объект.
            # в следствии чего пропадает метод Count и Lenght.
            if ($Computers.ComputerName.Count -eq 1) {
                Write-Host '1 -' $Computers.ComputerName $Computers.CurrentUser
            }

            else {
                for ($i = 0; $i -lt $Computers.ComputerName.Count; $i++) {
                    Write-Host ($i + 1) '-' $Computers[$i].ComputerName $Computers[$i].CurrentUser
                }
            }

            $SelectedNumber = Read-Host "Выберите компьютер (0 для отмены)"
            if ($SelectedNumber -eq 0) {}
            elseif ($SelectedNumber -in 1..$Computers.ComputerName.Count) {
                Clear-Host
                Set-Clipboard -Value "$($Computers[($SelectedNumber - 1)].ComputerName)"
                Invoke-SDBanner `
                    -Title "SDHelper" `
                    -Text "Имя $($Computers[($SelectedNumber - 1)].ComputerName) добавлено в буфер обмена."
                Show-ComputerMenu $Computers[($SelectedNumber - 1)].ComputerName
            }
            else {
                Write-host "Неверный ввод"
            }
        }
        
        0 { return $true }

        default { return $false }
    }
    return $false
}