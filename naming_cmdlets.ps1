<#
    create name from a given string following acronym of
    first letter, middle letter and last letter; optional
    switch allows to skip middle letter; additionally
    example of exceptions are shown
#>
function New-Name {

    param(
        [parameter(Mandatory=$True)]
        [string] $NameArg,
        [switch] $MiddleLeft = $False
    )

    [string] $NameArg = $NameArg.ToUpper()
    [string[]] $NameArr = $NameArg.Split(" ")

    if ($NameArg -eq "MARKETING") { return "MKT" } #exception to the rule

    if( $NameArr.Count -gt 1 ) {
        foreach ($i in $NameArr){
            [string] $NewName = "$($NewName)$($i[0])"
        }
        return $NewName
    }
    else {
        [string] $First = $NameArg[0]
        $MiddlePos = [math]::Round($NameArg.Length / 2,0)
        if($MiddleLeft -eq $True) { $MiddlePos = $MiddlePos - 1 }
        $Middle = $NameArg[$MiddlePos]
        $Last = $NameArg[$NameArg.Length - 1]

        return $NewName = "$($First)$($Middle)$($Last)"
    }

}
