import-module au

$url64 = 'https://downloads.ultraedit.com/main/uc/win/uc_english_64.exe'

function global:au_GetLatest {
    # download the exe to a temp path
    $tempExe = Join-Path $env:TEMP 'ultracompare-latest.exe'
    Invoke-WebRequest -Uri $url64 -OutFile $tempExe -UseBasicParsing

    # extract the file-version
    $info = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($tempExe)
    $ver  = $info.FileVersion

    # compute the sha256 on the local file
    $hash = Get-FileHash -Path $tempExe -Algorithm SHA256 | Select-Object -ExpandProperty Hash

    # clean up
    Remove-Item $tempExe -ErrorAction SilentlyContinue

    return @{
      Version    = $ver
      Url64      = $url64
      Checksum64 = $hash
    }
}

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(?m)^\s*checksum64\s*=.*"= "  checksum64    = '$($Latest.Checksum64)'"
    }
  }
}

update -ChecksumFor 64