# Install Oh My Posh if not already installed
$ohMyPoshInstalled = winget list --id JanDeDobbeleer.OhMyPosh 2>$null | Select-String "JanDeDobbeleer.OhMyPosh"
if (-not $ohMyPoshInstalled) {
    Write-Host "Installing Oh My Posh..."
    winget install JanDeDobbeleer.OhMyPosh --source winget
} else {
    Write-Host "Oh My Posh is already installed."
}

# Download and extract themes if directory doesn't exist
$themesDir = Join-Path $env:USERPROFILE ".oh-my-posh\themes"
if (-not (Test-Path $themesDir)) {
    Write-Host "Downloading Oh My Posh themes..."
    
    $themesZipUrl = "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/heads/main.zip"
    $tempZip = Join-Path $env:TEMP "oh-my-posh-main.zip"
    $tempExtract = Join-Path $env:TEMP "oh-my-posh-extract"
    
    try {
        Invoke-WebRequest -Uri $themesZipUrl -OutFile $tempZip
        
        Write-Host "Extracting themes to $themesDir..."
        Expand-Archive -Path $tempZip -DestinationPath $tempExtract -Force
        
        # Create destination and copy themes
        New-Item -ItemType Directory -Path $themesDir -Force | Out-Null
        $sourceThemes = Join-Path $tempExtract "oh-my-posh-main\themes\*"
        Copy-Item -Path $sourceThemes -Destination $themesDir -Force -Recurse
        
        Write-Host "Oh My Posh themes installed."
    } finally {
        # Cleanup temp files
        if (Test-Path $tempZip) { Remove-Item -Path $tempZip -Force }
        if (Test-Path $tempExtract) { Remove-Item -Path $tempExtract -Recurse -Force }
    }
} else {
    Write-Host "Themes directory already exists, skipping download."
}

Install-Module -Name Terminal-Icons -Repository PSGallery