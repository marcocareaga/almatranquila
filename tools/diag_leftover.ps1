$ErrorActionPreference = 'Stop'
$c = [IO.File]::ReadAllText((Join-Path $PSScriptRoot '..\index.html'), [Text.Encoding]::UTF8)
$rx = [regex]::new('data:image/(?!jpeg|png)[^'']*')
$m = $rx.Match($c)
if (-not $m.Success) { Write-Host 'none'; exit }
$i = $c.IndexOf($m.Value)
$s = [Math]::Max(0, $i - 60)
Write-Host ("match: " + $m.Value.Substring(0, [Math]::Min(60, $m.Value.Length)))
Write-Host ("len: " + $m.Value.Length)
Write-Host ("ctx: " + $c.Substring($s, [Math]::Min(200, $c.Length - $s)))