function Show-MainMenu {
    Clear-Host
    Write-Host 'Выберите пункт:
    1. Компьютер
    2. Пользователь
    3. Группа
    0. Выход из программы
    '

    $ContinuePrompt = "Нажмите Enter чтобы продолжить"

    $SelectedParameter = Read-Host
    switch ($SelectedParameter) {
        1 {
            [boolean]$trigger = $False
            while ($true) {
                if ($trigger -eq $false) {
                    $Identifier = Read-Host "Введите имя компьютера"
                    $trigger = $true
                }

                Clear-Host

                if (Get-SDComputerValidate $Identifier) {
                    if ((Show-ComputerMenu -Identifier $Identifier) -eq $true) { break }
                }
                else {
                    Write-Host "Такого компьютера нет в AD"
                }
            }
        }

        2 {
            [boolean]$trigger = $False
            while ($true) {
                if ($trigger -eq $false) {
                    $Identifier = Read-Host "Введите имя пользователя"
                    $trigger = $true
                }
                Clear-Host
                if ((Show-UserMenu -Identifier $Identifier) -eq $true) { break }
            }
        }

        3 {
            Clear-Host
            if ((Show-GroupMenu) -eq $true) { break }
        }
    

        0 { return $true }
    

        default { return $false }
    }
    return $false
}