$ErrorActionPreference = 'Stop'

$packageName = 'ultracompare'

$uninstalled = $false
[array]$key = Get-UninstallRegistryKey -SoftwareName 'UltraCompare'

if ($key.Count -eq 1) {
  $key | ForEach-Object {
    $uninstallCmd = $_.UninstallString

    # Use regex to split executable and arguments
    if ($uninstallCmd -match '^"([^"]+)"\s+(.*)$') {
      $exePath = $matches[1]
      $arguments = $matches[2]
    } else {
      $exePath, $arguments = $uninstallCmd -split '\s+', 2
    }

    if (-not (Test-Path $exePath)) {
      throw "Uninstall executable not found: $exePath"
    }

    Write-Host "Using uninstall file: $exePath"
    Write-Host "With arguments: $arguments"

    $packageArgs = @{
      packageName    = $packageName
      fileType       = 'EXE'
      silentArgs     = "$($arguments) /S"
      validExitCodes = @(0)
      file           = $exePath
    }

    Uninstall-ChocolateyPackage @packageArgs
  }
}
elseif ($key.Count -eq 0) {
  Write-Warning "$packageName has already been uninstalled by other means."
}
elseif ($key.Count -gt 1) {
  Write-Warning "$($key.Count) matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert package maintainer the following keys were matched:"
  $key | % { Write-Warning "- $($_.DisplayName)" }
}