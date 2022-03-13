# get latest release
$release_url = "https://api.github.com/repos/scmn-dev/secman/releases"
$tag = (Invoke-WebRequest -Uri $release_url -UseBasicParsing | ConvertFrom-Json)[0].tag_name
$loc = "$HOME\AppData\Local\secman"
$url = ""
$arch = $env:PROCESSOR_ARCHITECTURE
$releases_api_url = "https://github.com/scmn-dev/secman/releases/download/$tag/secman_windows_${tag}"

if ($arch -eq "AMD64") {
    $url = "${releases_api_url}_amd64.zip"
} elseif ($arch -eq "x86") {
    $url = "${releases_api_url}_386.zip"
} elseif ($arch -eq "arm") {
    $url = "${releases_api_url}_arm.zip"
} elseif ($arch -eq "arm64") {
    $url = "${releases_api_url}_arm64.zip"
}

if (Test-Path -path $loc) {
    Remove-Item $loc -Recurse -Force
}

Write-Host "Installing secman version $tag" -ForegroundColor DarkCyan

Invoke-WebRequest $url -outfile secman_windows.zip

Expand-Archive secman_windows.zip

New-Item -ItemType "directory" -Path $loc

Move-Item -Path secman_windows\bin -Destination $loc

Remove-Item secman_windows* -Recurse -Force

[System.Environment]::SetEnvironmentVariable("Path", $Env:Path + ";$loc\bin", [System.EnvironmentVariableTarget]::User)

if (Get-Command npm -errorAction SilentlyContinue) {
    Write-Host "Installing secman core cli..." -ForegroundColor DarkCyan
    npm install -g @secman/scc
}

if (Test-Path -path $loc) {
    Write-Host "
███████╗ ███████╗  ██████╗ ███╗   ███╗  █████╗  ███╗   ██╗
██╔════╝ ██╔════╝ ██╔════╝ ████╗ ████║ ██╔══██╗ ████╗  ██║
███████╗ █████╗   ██║      ██╔████╔██║ ███████║ ██╔██╗ ██║
╚════██║ ██╔══╝   ██║      ██║╚██╔╝██║ ██╔══██║ ██║╚██╗██║
███████║ ███████╗ ╚██████╗ ██║ ╚═╝ ██║ ██║  ██║ ██║ ╚████║
╚══════╝ ╚══════╝  ╚═════╝ ╚═╝     ╚═╝ ╚═╝  ╚═╝ ╚═╝  ╚═══╝"

    Write-Host "Thanks for installing Secman! Now Refresh your powershell" -ForegroundColor DarkGreen
    Write-Host "If this is your first time using the CLI, be sure to run 'secman --help' first." -ForegroundColor DarkGreen
} else {
    Write-Host "Download failed" -ForegroundColor Red
    Write-Host "Please try again later" -ForegroundColor Red
}
