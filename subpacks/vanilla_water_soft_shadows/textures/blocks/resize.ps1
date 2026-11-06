# Tạo thư mục đầu ra
$outDir = "resized"
if (!(Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir }

# Lấy tất cả file png và tga
$files = Get-ChildItem -Include *.png, *.tga -Recurse

# Sử dụng .NET System.Drawing để resize (Cách này không cần cài ImageMagick)
Add-Type -AssemblyName System.Drawing

foreach ($file in $files) {
    $img = [System.Drawing.Image]::FromFile($file.FullName)
    $bmp = new-object System.Drawing.Bitmap(16, 16)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    
    # Thiết lập chất lượng (NearestNeighbor cho pixel art)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
    $g.DrawImage($img, 0, 0, 16, 16)
    
    $bmp.Save("$outDir\$($file.Name)")
    $g.Dispose()
    $img.Dispose()
    $bmp.Dispose()
    Write-Host "Completed: $($file.Name)"
}