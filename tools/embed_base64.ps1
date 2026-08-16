$ErrorActionPreference = 'Stop'
$temp = Join-Path $env:TEMP 'opencode'

function Get-B64 {
    param([string]$Path)
    return [Convert]::ToBase64String([IO.File]::ReadAllBytes($Path))
}

$jpegs = @(
    (Join-Path $temp 'figua1.jpg'),
    (Join-Path $temp 'figura2.jpg'),
    (Join-Path $temp 'figura3.jpg'),
    (Join-Path $temp 'figura4.jpg'),
    (Join-Path $temp 'figura5.jpg'),
    (Join-Path $temp 'figura6.jpg'),
    (Join-Path $temp 'figura7.jpg'),
    (Join-Path $temp 'figura8.jpg')
)
$seloPng = Join-Path $PSScriptRoot '..\public\selo_transparente.png'

foreach ($j in $jpegs) { if (-not (Test-Path $j)) { throw "Missing jpeg: $j" } }
if (-not (Test-Path $seloPng)) { throw "Missing selo: $seloPng" }

# occurrence map: 0-6 -> jpegs[0..6], 7 -> png, 8 -> jpegs[7]
$map = New-Object System.Collections.Generic.List[string]
for ($i = 0; $i -lt 7; $i++) { $map.Add('data:image/jpeg;base64,' + (Get-B64 $jpegs[$i])) }
$map.Add('data:image/png;base64,' + (Get-B64 $seloPng))
$map.Add('data:image/jpeg;base64,' + (Get-B64 $jpegs[7]))

$c = [IO.File]::ReadAllText('index.html', [Text.Encoding]::UTF8)
$regex = [regex]'data:image/(jpeg|png|gif|svg\+xml);base64,[^''"]*'
$ms = $regex.Matches($c)
if ($ms.Count -ne 9) { throw "Expected 9 data URIs, found $($ms.Count); aborting" }

$sb = New-Object System.Text.StringBuilder
$pos = 0
$k = 0
foreach ($m in $ms) {
    [void]$sb.Append($c.Substring($pos, $m.Index - $pos))
    [void]$sb.Append($map[$k])
    $pos = $m.Index + $m.Length
    $k++
}
[void]$sb.Append($c.Substring($pos))

[IO.File]::WriteAllText('index.html', $sb.ToString(), [Text.Encoding]::UTF8)
Write-Host ('replaced occurrences: ' + $k)
Write-Host ('new size: ' + (Get-Item 'index.html').Length)