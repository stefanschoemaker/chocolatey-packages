﻿$checksum = 'baa6a3276462fbc769e74cd98975b4c8b7505069262129ebd1b963d160a14a01'
$url = 'https://downloads.plex.tv/plex-media-server/1.12.0.4829-6de959918/Plex-Media-Server-1.12.0.4829-6de959918.exe'

if ((get-process "Plex Media Server" -ea SilentlyContinue) -eq $Null){ 
    $PMSRunning="False" # Always false on new install.
   } else { 
    $PMSRunning="True"
    Write-Host "Plex Media Server found running." -foreground magenta 
}

$packageArgs = @{
  packageName   = 'plexmediaserver'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = $url
  silentArgs    = '/quiet'
  validExitCodes= @(0)
  softwareName  = 'plexmediaserver*'
  checksum      = $checksum
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs

if ($PMSRunning -eq "True"){
    $bits = Get-ProcessorBits
	Write-Host "Running Plex Media Server" -foreground magenta 
    if ($bits -eq 64){
	& "${env:PROGRAMFILES(x86)}\Plex\Plex Media Server\Plex Media Server.exe"
       } else {
        & "$env:PROGRAMFILES\Plex\Plex Media Server\Plex Media Server.exe"
       }
}
