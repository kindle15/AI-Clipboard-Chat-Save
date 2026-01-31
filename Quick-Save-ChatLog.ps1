# Quick-Save-ChatLog.ps1
# One-click version - just run this after copying chat to clipboard
# No prompts, saves and displays confirmation only

$docs = [Environment]::GetFolderPath("MyDocuments")
$base = "AIText"
$ext = ".txt"

$max = 0
Get-ChildItem "$docs\$base*$ext" -ErrorAction SilentlyContinue | ForEach-Object {
    if ($_.Name -match "$base(\d+)$ext") { 
        $num = [int]$matches[1]
        if ($num -gt $max) { $max = $num }
    }
}

$next = ($max + 1).ToString("D2")
$file = "$docs\$base$next$ext"

$clip = Get-Clipboard -Raw
if ($clip) {
    Set-Content $file $clip -Encoding UTF8
    Write-Host "Saved: $base$next$ext ($([math]::Round((Get-Item $file).Length/1KB,2)) KB)" -ForegroundColor Green
} else {
    Write-Host "Clipboard is empty!" -ForegroundColor Red
}
