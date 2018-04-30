Param(
    [int] [Parameter(Mandatory=$true)] $teamNum,
    [int] [Parameter(Mandatory=$true)] $servicesPerTeam
)

$template = Get-Content 'template.txt' -Raw
$subtemplate = Get-Content 'subtemplate.txt' -Raw

$services = ""

For ($teamId=1; $teamId -le $teamNum; $teamId++) {
    For ($id=1; $id -le $servicesPerTeam; $id++){
        $serviceId = $teamId.ToString("00") + $id.ToString("00")
        $subExpand = Invoke-Expression "@`"`r`n$subtemplate`r`n`"@"

        $endpoint = (Get-AzureKeyVaultSecret -VaultName ohkey -Name ("Team" + $teamId.ToString("00") + "-Endpoint" + $id.ToString("00"))).SecretValueText
        # Write-Host $subexpand
        $services = -join($services, $subExpand)
        # Write-Host $services
    }
}

$expand = Invoke-Expression "@`"`r`n$template`r`n`"@"
Write-Host $expand
$expand | Out-File Values.yaml -Encoding UTF8