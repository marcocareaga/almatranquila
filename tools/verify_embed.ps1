$ErrorActionPreference = 'Stop'
$html = Join-Path $PSScriptRoot '..\index.html'
$c = [IO.File]::ReadAllText($html, [Text.Encoding]::UTF8)

Write-Host ("size: " + (Get-Item $html).Length)
Write-Host ("starts `<!DOCTYPE html>`: " + $c.StartsWith('<!DOCTYPE html>'))
Write-Host ("img count: " + ([regex]'<img').Matches($c).Count)
Write-Host ("guar-selo imgs: " + ([regex]'class="guar-selo"').Matches($c).Count)
Write-Host ("guar-selo has png b64: " + ([regex]'class="guar-selo" src="data:image/png;base64,[^'']+').Matches($c).Count)
Write-Host ("background-image jpeg b64: " + ([regex]'background-image:url\(''data:image/jpeg;base64,[^'']+''\)').Matches($c).Count)
Write-Host ("png data URIs total: " + ([regex]'data:image/png;base64,').Matches($c).Count)
Write-Host ("jpeg data URIs total: " + ([regex]'data:image/jpeg;base64,').Matches($c).Count)
Write-Host ("remaining data:image/(?!jpeg|png): " + ([regex]'data:image/(?!jpeg|png)').Matches($c).Count)
Write-Host ("null bytes: " + (([IO.File]::ReadAllBytes($html) | Where-Object { $_ -eq 0 }).Count))