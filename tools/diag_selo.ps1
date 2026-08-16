$c = [IO.File]::ReadAllText('index.html',[Text.Encoding]::UTF8)

$pn = [regex]::Matches($c,'data:image/png;base64,')
Write-Host ('PNG count: ' + $pn.Count)
foreach ($m in $pn) {
    $s = [Math]::Max(0, $m.Index - 120)
    $len = [Math]::Min(120, $c.Length - $s)
    $ctx = $c.Substring($s, $len).Replace("`r",'').Replace("`n",' ')
    Write-Host ('PNG CTX: ...' + $ctx + '...')
}

$s2 = $c.IndexOf('class="guar-selo"')
if ($s2 -lt 0) { $s2 = $c.IndexOf('guar-selo') }
Write-Host ('---SELO INDEX: ' + $s2)
if ($s2 -ge 0) {
  $sub = $c.Substring($s2, [Math]::Min(160, $c.Length - $s2))
  $firstLine = ($sub -split "`n")[0]
  Write-Host ('SELO LINE: ' + $firstLine)
  $sub2 = $c.Substring([Math]::Max(0,$s2-40), [Math]::Min(160, $c.Length - [Math]::Max(0,$s2-40)))
  Write-Host ('SELO RAW: ' + $sub2.Replace("`r",'').Replace("`n",' '))
}