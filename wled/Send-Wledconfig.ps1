param(
    [string]$lampAddress        = "ninjacat-lamp.local",
    [string]$configFilesPath    = "/Users/koos/Repos/yellowhat-live/ninjacat-lamp/wled"
)

#
#   First set:
#   Maximum PSU Current: 900 mA
#   LED outputs - length: 94
#
# http://ninjacat-lamp.local/settings/leds

$configFiles        = Get-ChildItem $configFilesPath -Recurse | Where-Object {$_.Name -like "wledconfig*.json" } | Select-Object Name

Clear-Host
Write-Host "Retrieving configuration files from :"
Write-Host "$configFilesPath" -ForegroundColor DarkGray
foreach($configFile in $configFiles) {
    $configurationFile = "$configFilesPath\$($configFile.Name)"
    # Reading the configuration from the file
    $wledConfiguration  = Get-Content -Path $configurationFile -Raw
    # Contacting the WLED device to get the current configuration
    Write-Host "  └─ Sending the configuration in '$($configFile.Name)' to '$lampAddress'..."
    try {
        $response = Invoke-WebRequest -Uri "http://$($lampAddress)/json" -Method POST -Body $wledConfiguration -ContentType "application/json"
        if($response.StatusCode -eq 200) { 
            Write-Host "      └─ Done!" -ForegroundColor Green 
        } else { 
            Write-Host "      └─ Something went wrong :-( Response: $($response.StatusCode)" -ForegroundColor Red 
        }
    }
    catch {
        Write-Host "      └─ Something went wrong :-( The error message was: $($_.Exception.Message)" -ForegroundColor Red
    }
}