function Get-SDUserGroups {
            
    <#
.Synopsis
    Вывод основной групп пользователя.

.Description
    Принимает полное ФИО или логин сотрудника. В зависимости, от атрибута Shtat, возвращает либо список групп пользователя, либо этот же список + группы из штаток сотрудника.
    
.Parameter Identifier

.Example
    Get-SDUserCommonInfo "Россамахин Роман Андреевич" 
    
.Example
    Get-SDUserCommonInfo "rossamakhin.ra"  
    
.Inputs
    Принимает через пайплайн объект типа String.

.Outputs
    Объект типа PSCustomObject.

.Link
    https://kb.ertelecom.ru/display/~rossamakhin.ra/SDHelperLibs
#>

    [CmdletBinding()]
    param(

        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [String]$Identifier,
        [switch]$Shtat
    )

    Try {

        $ReturnArray = @()

        $Groups = (
            (Get-ADUser (Get-SDUserValidate -Identifier $Identifier) -Properties MemberOF).MemberOF |
            Get-ADGroup -Properties info, description |
            Select-Object Name, info, description |
            Sort-Object -Property name
        )

        foreach ($Group in $Groups) {
            $ReturnArray += [PSCustomObject]@{
                Name        = $Group.Name;
                Info        = $Group.Info;
                Description = $Group.Description 
            }
        }

        if ($Shtat) {
            ForEach ($Group in $ReturnArray.Name) {
                if ($Group -like "Штат*") {

                    $ShtatGroups = @()
                    $ShtatGroups = Get-SDGroupsMembers $Group
                    foreach ($ShtatGroup in $ShtatGroups) {
                        $ReturnArray += [PSCustomObject]@{
                            Name        = $ShtatGroup.Name;
                            Info        = $ShtatGroup.Info;
                            Description = $ShtatGroup.Description 
                        }
                    }

                }
            }
        }

        return $ReturnArray
    }
    Catch {
        Write-Host "В AD нет такого пользователя"
    }
}

# Функция затычка, вскоре облагорожу и документирую
function Get-SDGroupsMembers {

    [CmdletBinding()]
    param(
    
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [String]$Identifier
    )
    try {

        $ReturnArray = (
        (Get-ADGroup -Identity $Identifier -Properties MemberOf).memberof |
            Get-ADGroup -Properties info, description |
            Select-Object Name, info, description |
            Sort-Object -Property name
        )
        
        return $ReturnArray | Sort-Object -Property Name, info, description

    }
    Catch {

    }
}
