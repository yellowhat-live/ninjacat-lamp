param(
    [string]$lampAddress        = "ninjacat-lamp.local",
    [string]$configurationFile  = "wledconfig.json"
)

$configurations     = @("state")

Clear-Host
# Contacting the WLED device to get the current configuration
Write-Host "Retrieving the current configuration from '$lampAddress'..."
$response = Invoke-WebRequest -Uri "http://$($lampAddress)/json" -Method Get
# Write the current configuration to files
foreach($config in $configurations) {
    $filename = $configurationFile.Replace('.json', "-$config.json")
    Write-Host "  └─ Writing the current configuration '$config' to '$filename'..."
    Set-Content -Path $filename -Value ($response.Content | ConvertFrom-Json | Select-Object -ExpandProperty $config | ConvertTo-Json -Depth 99)
    Write-Host "      └─ Done!" -ForegroundColor Green
}