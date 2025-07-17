$ErrorActionPreference = 'Stop' # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url64       = 'https://downloads.ultraedit.com/main/uc/win/uc_english_64.exe'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url64bit      = $url64
  softwareName  = 'UltraCompare'
  checksum64    = '355A5B4710721982BFF7A4C482C11624317CEA377166CA4F36778B146926F826'
  checksumType64= 'sha256'
  silentArgs    = "/S"
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs