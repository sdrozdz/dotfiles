$DOTFILES = Join-Path ([Environment]::GetFolderPath("UserProfile")) ".dotfiles"

Write-Host "Creating symbolic links from $DOTFILES to $env:APPDATA and $env:USERPROFILE"
$links = @{
    "$env:APPDATA\Code\User\keybindings.json" = "$DOTFILES\vscode\.config\Code\User\keybindings.json"
    "$env:APPDATA\Code\User\settings.json" = "$DOTFILES\vscode\.config\Code\User\settings.json"
    "$env:USERPROFILE\Documents\WindowsPowerShell\profile.ps1" = "$DOTFILES\windows\profile.ps1"
    "$env:XDG_CONFIG_HOME\wezterm" = "$DOTFILES\wezterm\.config\wezterm"
}

foreach ($target in $links.Keys) {
    $source = $links[$target]

    # Skip if the target already exists as a symbolic link pointing to the correct source
    if (Test-Path $target) {
        $item = Get-Item $target -Force
        if ($item.LinkType -eq "SymbolicLink" -and $item.Target -eq $source) {
            Write-Host "Skipping $target (symbolic link already exists)"
            continue
        }

        $backup = "$target.Backup"
        Write-Host "Backing up existing file at $target to $backup"
        Move-Item -Path $target -Destination $backup -Force
    }

    $targetDir = Split-Path -Parent $target
    if (-not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    }

    New-Item -ItemType SymbolicLink -Path $target -Target $source
    Write-Host "Created symbolic link from $source to $target"
}