function Show-GroupMenu {

    Write-Host 'Выберите пункт:
    1. Поиск группы по маске
    0. Предыдущее меню
    '

    $SelectedParameter = Read-Host

    switch ($SelectedParameter) {
        1 {
            $Identifier = Read-Host "Введите маску группы"
            Write-Progress "Выполняю запрос..."
            Get-SDGroupsByMask $Identifier | Out-GridView
            Write-Progress " " -Completed
            Write-Host $ContinuePrompt
            Read-Host
            Clear-Host

        }
        
        0 { return $true }

        default { return $false }
    }
    return $false
}