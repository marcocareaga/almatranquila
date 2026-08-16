$c = [IO.File]::ReadAllText('index.html',[Text.Encoding]::UTF8)
$ms = [regex]::Matches($c, 'data:image/(jpeg|png|gif|svg\+xml);base64,')
Write-Host ('total data:image occurrences: ' + $ms.Count)
$n = 0
foreach ($m in $ms) {
    $ctx = ''
    if ($m.Index -ge 80) { $ctx = $c.Substring($m.Index - 80, 80) }
    $ctx = $ctx.Replace("`r",'').Replace("`n",' ')
    # payload length until closing quote
    $b = $m.Index + $m.Length
    $e = $b
    while ($e -lt $c.Length -and $c[$e] -ne "'" -and $c[$e] -ne '"') { $e++ }
    Write-Host ("[$n] type=$($m.Groups[1].Value) idx=$($m.Index) datalen=$($e-$b)")
    Write-Host ("    CTX> ..." + $ctx.Substring([Math]::Max(0,[Math]::Min(70,$ctx.Length))) + " <bool>" )
    $n++
}