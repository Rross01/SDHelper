## Описание

Представляет из себя набор полезных для техподдержки скриптов, обёрнутых в модуль для PowerShell.

## Требования

Писалось и тестировалось на версии Powershell 5.1. Проверить установленную у вас версию можно выполнив команду *\$PSVersionTable.PSVersion*.

## Использование

### Модуль SDHelperLibs

```powershell
Import-Module '\*расположение*\SDHelper\SDHelperLibs\SDHelperLibs.psm1'
```
### Запуск TUI
```powershell
& '\*расположение*\SDHelper\TUI\Start.ps1'
```
В этом случае импорт модулей произойдёт автоматически.

Каждая функция именована по концепции PowerShell, следуя шаблону глагол-существительное (Get-ADUser, Get-ADGroup и т.д.). Перед каждым существительным стоит SD, во избежании пересечений с встроенными командами.

При импорте в консоль выводится список всех подгруженных функций, которые располагаются в папке *SDHelperLibs\Libs*. При добавлении модуля прогоняются все *\*.ps1* файлы, находящиеся в этой папке. Каждая функция разнесена по отдельным файлам для удобства.

## Внутрення документация
Вывести все доступные функции можно командой *Get-Command -Module SDHelperLibs*. Функционал каждой функции  документирован встроенными в PowerShell инструментами, и для вывода подробной справки о функции можно воспользоваться командой *Get-Help \*имя функции\* -Detailed*.