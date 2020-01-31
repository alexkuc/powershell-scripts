<#
    a collection of (possibly) useful functions to automate
    administration of Sage 50 Accounts UK version
#>

#
# following cmdlets assume cwd to be c:\Sage50
#

# move any non-company folders
Get-ChildItem -Directory | Where-Object Name -notlike "COMPANY.*" | Move-Item -Destination ".\to_be_deleted"

# 1. read file with company number each per line e.g. "1<newline>2<newline>3" etc.
# 2. convert read lines into PS objects; also appends "COMPANY." before company number
# 3. move matching company folders into "to_be_deleted"
Get-Content .\arr | Get-Item -Path {".\Accounts\COMPANY.$_"} | Move-Item -Destination ".\to_be_deleted"

# generate COMPANY file
Get-ChildItem -Directory | Where-Object name -like "COMPANY.*" | Select-Object -ExpandProperty FullName | Out-File COMPANY

# check for collisions (definition)
# this function is aimed at checking if the company folder exists in the destination
# it checks this by comparing the last 3 digits (company number)
function Test-ForCollisions {
    param([string] $relativePath, [array] $CompanyListArr)
    Get-ChildItem -Path ".\$relativePath" | Where-Object Name -Like "company*" | ForEach-Object {
        $comp_num = $_.Name.Substring($_.Name.Length - 3 , 3)
        If ($CompanyListArr -contains $comp_num) { Write-Host -ForegroundColor Red -NoNewline "Collision with "; Write-Host -ForegroundColor Yellow -NoNewline "$_"; Write-Host -ForegroundColor Red -NoNewline " in folder $relativePath!" }
    }
}

# check for collisions (concrete example)
Set-Location C:\Sage50
$to_be_deleted = 154,199,224,357,375,607,619,621,622,623,624,632,688,689,718,719,720,721,735,736,888
Test-ForCollisions -relativePath "to_be_deleted" -CompanyListArr $to_be_deleted
