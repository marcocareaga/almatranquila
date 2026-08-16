Add-Type -AssemblyName System.Drawing

$src = "C:\Users\USER\Documents\LP\Alma\public\selo.jpg"
$dst = "C:\Users\USER\Documents\LP\Alma\public\selo_transparente.png"

$in = [System.Drawing.Bitmap]::FromFile($src)
$w = $in.Width
$h = $in.Height

$out = New-Object System.Drawing.Bitmap($w, $h, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

for ($y = 0; $y -lt $h; $y++) {
    for ($x = 0; $x -lt $w; $x++) {
        $c = $in.GetPixel($x, $y)
        $white = [Math]::Min([Math]::Min($c.R, $c.G), $c.B)
        if ($white -ge 240) {
            $alpha = 0
        } elseif ($white -ge 225) {
            $alpha = [int](((240 - $white) / 15.0) * 255)
        } else {
            $alpha = 255
        }
        if ($alpha -gt 0) {
            # posterize opaque pixels to cut color variety and shrink PNG
            $r = [byte]([Math]::Floor($c.R / 8) * 8)
            $g = [byte]([Math]::Floor($c.G / 8) * 8)
            $b = [byte]([Math]::Floor($c.B / 8) * 8)
        } else {
            $r = [byte]0; $g = [byte]0; $b = [byte]0
        }
        $nc = [System.Drawing.Color]::FromArgb($alpha, $r, $g, $b)
        $out.SetPixel($x, $y, $nc)
    }
}

$out.Save($dst, [System.Drawing.Imaging.ImageFormat]::Png)
$out.Dispose()
$in.Dispose()

$fi = Get-Item -LiteralPath $dst
"selo transparente PNG gerado: len=$($fi.Length)"