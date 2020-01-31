<#
    call executable with parameters (if service is running)
    return service status and version of executable
#>
function Call-ExecutableWithParams {

    param( #parameters
        [Parameter(Mandatory=$true)] [string] $svc, #service name
        [string] $exe, #path to executable
        [string] ${exe-prefix} = "$(${env:ProgramFiles(x86)})\FireEye\", #path prefix
        [string] ${exe-sw} #parameters for executable
    )

    $status = (Get-Service -Name $svc -ErrorVariable err -ErrorAction SilentlyContinue).Status #service status

    if ([string]::IsNullOrEmpty($err)) { #$err is empty ergo service is present
        try { $version = & "$(${exe-prefix})$($exe)" ${exe-sw} } catch { } #launching exec with arguments from ${exe-sw}
    } else { $status = 'Unknown' } #exception caught

    if ([string]::IsNullOrEmpty($version)) { $version = 'Unknown' } #failed to get version

    return New-Object PSObject -Property @{status=$status;version=$version} #returning object with properties $status and $version

}

<#
    call multiple executables with (the same) parameters
#>
function Call-MultipleExecutablesWithParams {

    param( #parameters
        [Parameter(Mandatory=$true)] [string[]] $dest, #path to executable
        [string] ${dest-prefix} = "$(${env:ProgramFiles(x86)})\McAfee\", #path prefix
        [Parameter(Mandatory=$true)] [string[]] $args #parameters for executable
    )

    foreach($d in $dest){ #iteration for $dest
        try { & "$(${dest-prefix})$($d)" "$($args[0]) $($args[1]) $($args[2])" } catch { } #for each $d, launching executable with parameters from $arg[2]
    }

}
