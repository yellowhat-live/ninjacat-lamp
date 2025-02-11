param(
    [string]$lampAddress        = "ninjacat-lamp.local",
    [string]$configurationFile  = "wledconfig.json"
)

#### Function defined for displaying status messages in a nice and consistent way
function Write-Message {
  param (
    [String]    $type       = "header",   # user either 'header', 'item' or 'counter'
    [String]    $icon       = "-",        # icon to display in header. only used when $type = 'header'
    [Int32]     $level      = 0,          # defines the level of indentation
    [String]    $message,                 # message to display
    [Int32]     $count      = 0,          # defines second number and total items. i.e. 0/##. only used when $type = 'counter'
    [Int32]     $countMax   = 20,         # defines first number and current item. i.e. ##/20. only used when $type = 'counter'
    [String]    $color0     = "DarkGray", # color of brackets
    [String]    $color1     = "Magenta",  # color of brackets
    [String]    $color2     = "White",    # color of icons and numbers
    [String]    $color3     = "Gray",     # color of message
    [Switch]    $noNewLine                # if true, no new line will be added at the end of the message
  )

  # Generate leading spaces
  if ($level -gt 0) {
    $spaces = 0
    do {
      Write-Host "      " -ForegroundColor $Color0 -NoNewline;
      $spaces ++
    } until (
      $spaces -eq $level
    )
  }

  # Display message based on type
  Switch ($type) {
    'header'.ToLower() {
      Write-Host "[ " -ForegroundColor $color1 -NoNewline; Write-Host $icon -ForegroundColor $color2 -NoNewline; Write-Host " ] " -ForegroundColor $color1 -NoNewline;
    }
    'counter'.ToLower() {
      Write-Host "[ " -ForegroundColor $color1 -NoNewline; Write-Host $Count -ForegroundColor $color2 -NoNewline; Write-Host " / " -ForegroundColor $color2 -NoNewline; Write-Host $CountMax -ForegroundColor $color2 -NoNewline; Write-Host " ] " -ForegroundColor $color1 -NoNewline;
    }
    'item'.ToLower() {
      Write-Host "  └─  " -ForegroundColor $Color0 -NoNewline;
    }
  }
  # Display message
  Write-Host "$message" -ForegroundColor $color3 -NoNewline:($noNewLine -eq $true)
}

# Generate Startup Logo
function Show-Logo {
  param (
    [String]    $ForeGroundColor  = "White", # color of the logo
    [String]    $TextColor        = "Yellow" # color of the text
  )

  Write-Host ""
  Write-Host "                       ░░ ▓▓▓▓▓▓▓▓▓▓▓▓▓░░                " -ForegroundColor $ForeGroundColor
  Write-Host "                   ░░ █▒▓▓▓▓▒░▒░░░░▒░▒▓▓▒▓▓░             " -ForegroundColor $ForeGroundColor
  Write-Host "                 ░░▓▓▓▓▓▒ ░         ░  ░░▒▓▓▓▒           " -ForegroundColor $ForeGroundColor
  Write-Host "               ░░▓▓▓▓▓ ░                 ░ ░▒▓▓▒         " -ForegroundColor $ForeGroundColor
  Write-Host "             ░░ ▓▓▓▒░                     ░ ░▒▒▓▓░       " -ForegroundColor $ForeGroundColor
  Write-Host "            ░░ █▓▒▓░  ░ ░█▓░          ░░░▓▓▓  ░▒▓▓▒      " -ForegroundColor $ForeGroundColor
  Write-Host "           ░ ░▓▓▓▒    ░ ░▓▓▒▓░░▒█▓▓▓▓▓▓▓▓▓▓▓ ░  ▒▓▓▓     " -ForegroundColor $ForeGroundColor
  Write-Host "          ░░░▓▓▓▒     ░ ░▓▓▓▓▒▓▓▓▒▓▓▓▒▓▒▓▒▓▓  ░  ▒▓▒▓    " -ForegroundColor $ForeGroundColor
  Write-Host "          ░ ▓▓▓▓░     ░ ░▓▓▓▓▓▓▒▓▓▓▒▓▓▓▓▓▓▓▒   ░░ ▒▓▓░   " -ForegroundColor $ForeGroundColor -NoNewLine; Write-Host "    _______   .__              __                          __   " -ForegroundColor $TextColor
  Write-Host "         ░ ░▓▓▓░       ░ ▓▓▒▓▒▓▓▒░▒▒▒░▒░▒░▒▓   ░ ░░▒▓▓   " -ForegroundColor $ForeGroundColor -NoNewLine; Write-Host "    \      \  |__|  ____      |__|_____     ____  _____  _/  |_ " -ForegroundColor $TextColor
  Write-Host "         ░░ █▓▓░       ░░▒█▓▓▓▓▓▓▓▓▒▓▓▓▓▓▓▒▓▓   ░ ░ ▓▓▒  " -ForegroundColor $ForeGroundColor -NoNewLine; Write-Host "    /   |   \ |  | /    \     |  |\__  \  _/ ___\ \__  \ \   __\" -ForegroundColor $TextColor
  Write-Host "        ░ ░▓▓▓▒       ░ ░▓▒▓▒▓░ ░▓▓▓▓▓░ ░▓▓▓▓     ░░▒▓▓  " -ForegroundColor $ForeGroundColor -NoNewLine; Write-Host "   /    |    \|  ||   |  \    |  | / __ \_\  \___  / __ \_|  |  " -ForegroundColor $TextColor
  Write-Host "        ░ ░▓▓▓▓░ ▓▓░  ░ ░▓▓▒▓▒▓░░▒▓▒▓▒▒▓▒▒▓▓▓▒   ░ ░▓▓▒░ " -ForegroundColor $ForeGroundColor -NoNewLine; Write-Host "   \____|__  /|__||___|  //\__|  |(____  / \___  >(____  /|__|  " -ForegroundColor $TextColor
  Write-Host "        ░ ░▒█▒▓ ░░▓▓▓▓▓▓▒▓▓▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒    ░ ░▒▓▓░ " -ForegroundColor $ForeGroundColor -NoNewLine; Write-Host "           \/  .____   \/ \______|     \/      \/      \/       " -ForegroundColor $TextColor
  Write-Host "        ░ ░▓▓▓▓     ▒░░▓▓▓▓▓▓▓▒▓▒▓▓▓▓▒▓▒▓▓▒▓▓    ░ ░ █▓  " -ForegroundColor $ForeGroundColor -NoNewLine; Write-Host "               |    |    _____      _____  ______               " -ForegroundColor $TextColor
  Write-Host "         ░ ░▓▓▓   ░░ █▓▓▓  ▒▓▒▓▓▓▓▒▓▓▓▓▓▒▓▓▓     ░ ░▓▓▓░ " -ForegroundColor $ForeGroundColor -NoNewLine; Write-Host "               |    |    \__  \   /     \ \____ \               " -ForegroundColor $TextColor
  Write-Host "          ░ ▓▒▓▒░░▒▓▓▓▒▒  ░ ░▒▓▓▒▓▓▓▒▓▓▓▓▓▓▒     ░░ ▓▓▓  " -ForegroundColor $ForeGroundColor -NoNewLine; Write-Host "               |    |___  / __ \_|  Y Y  \|  |_> >              " -ForegroundColor $TextColor
  Write-Host "         ░ ░ ▓▓▓    ░░     ░ ░█▓▓▓▓▓▓▒▓▒▓▒▓▓▓   ░ ░░█▒▓  " -ForegroundColor $ForeGroundColor -NoNewLine; Write-Host "               |_______ \(____  /|__|_|  /|   __/               " -ForegroundColor $TextColor
  Write-Host "          ░ ░▓▓▓▓         ░ ░▓▓▒▓▒▓▒▓▓▓▓▓▓▓▓▓▓  ░ ░▓▒▓░  " -ForegroundColor $ForeGroundColor -NoNewLine; Write-Host "                       \/     \/       \/ |__|                  " -ForegroundColor $TextColor
  Write-Host "           ░  ▓▓▒▒       ░ ░▓▓▓▓▓▓▓▓▓▓▒▓▓░▓▓▓▓▓ ░░▒█▓▓   " -ForegroundColor $ForeGroundColor
  Write-Host "           ░ ░ ▓▓▓▒      ░░ █▓▒▓▓▒▓▓▒▓▓▓▓▓▓▓▓▓▒▓ ░▓▓▓    " -ForegroundColor $ForeGroundColor
  Write-Host "             ░ ░▓▓▓▓░   ░ ░▓▓▓▓▓▓▓▓▒▓▒▓▒▓▓▓▓▒▓▓▓▓█▓▓     " -ForegroundColor $ForeGroundColor
  Write-Host "              ░  ▒▒▓▓▒  ░ ░▓▒▓▒▓▒▓▒▓▓▒▓▓▓▒▓▒▓▓▓▓▓▒▓      " -ForegroundColor $ForeGroundColor
  Write-Host "               ░ ░ ▓▒▓▓▒░ ░▓▓▓▓▓▓▓▓▓▒▒▓▓▓▒▓▓▓▒▓▓▓░       " -ForegroundColor $ForeGroundColor
  Write-Host "                  ░ ░▒▓▓▓▓░▒▓▒▓▓▒▓▒▓▓▓▓▒▓▓▓▓▓▓▓░         " -ForegroundColor $ForeGroundColor
  Write-Host "                     ░ ░▒▓▓▓▓▓▒▓▓▓▓▓▒▓▓▓▓▓▒▓▓            " -ForegroundColor $ForeGroundColor
  Write-Host "                       ░  ░▒▒▓▓▓▒▓▓▓▓▓▓▓▒▒░              " -ForegroundColor $ForeGroundColor
  Write-Host "                             ░ ░░  ░  ░                  " -ForegroundColor $ForeGroundColor
  Write-Host ""
}

$configurations     = @("state", "info")

Clear-Host
Show-Logo -ForeGroundColor "White" -TextColor "Yellow"
# Contacting the WLED device to get the current configuration
Write-Message -icon "🐱" -message "Retrieving the current configuration from '$lampAddress'..."
$response = Invoke-WebRequest -Uri "http://$($lampAddress)/json" -Method Get
# Write the current configuration to files
foreach($config in $configurations) {
    $filename = $configurationFile.Replace('.json', "-$config.json")
    Write-Message -type "item" -level 1 -message "Writing the current configuration '$config' to '$filename'..."
    Set-Content -Path $filename -Value ($response.Content | ConvertFrom-Json | Select-Object -ExpandProperty $config | ConvertTo-Json -Depth 99)
    Write-Message -type "item" -level 2 -message "Done!" -color3 "Green"
}