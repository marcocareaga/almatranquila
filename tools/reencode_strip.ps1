param(
    [Parameter(Mandatory=$true)][string]$Src,
    [Parameter(Mandatory=$true)][string]$Dst,
    [double]$TargetWidth = 800,
    [int]$Quality = 60
)
Add-Type -AssemblyName System.Drawing

$in = [System.Drawing.Bitmap]::FromFile($Src)
$srcW = $in.Width
$srcH = $in.Height
$newW = $TargetWidth
$newH = [int][Math]::Round($srcH * ($TargetWidth / $srcW))

$out = [System.Drawing.Bitmap]::new([int]$newW, [int]$newH)
$g = [System.Drawing.Graphics]::FromImage($out)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g.DrawImage($in, 0, 0, $newW, $newH)
$g.Dispose()

$enc = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
$ep = New-Object System.Drawing.Imaging.EncoderParameters(1)
$ep.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [long]$Quality)
$out.Save($Dst, $enc, $ep)

$out.Dispose()
$in.Dispose()

$fi = Get-Item -LiteralPath $Dst
"$Src => $Dst  ${srcW}x${srcH} -> ${newW}x${newH}  len=$($fi.Length)"