# Save-ChatLog.ps1
# Saves clipboard content to Documents folder with auto-incrementing filename
# Usage: Run this script after copying chat log to clipboard

# Configuration
$documentsPath = [Environment]::GetFolderPath("MyDocuments")
$baseFileName = "AIText"
$fileExtension = ".txt"

# Find next available number
$existingFiles = Get-ChildItem -Path $documentsPath -Filter "$baseFileName*$fileExtension" -ErrorAction SilentlyContinue
$maxNumber = 0

foreach ($file in $existingFiles) {
    # Extract number from filename (e.g., AIText01.txt -> 01)
    if ($file.Name -match "$baseFileName(\d+)$fileExtension") {
        $number = [int]$matches[1]
        if ($number -gt $maxNumber) {
            $maxNumber = $number
        }
    }
}

# Increment to next number
$nextNumber = $maxNumber + 1
$paddedNumber = $nextNumber.ToString("D2")  # Pad with zero (01, 02, etc.)
$newFileName = "$baseFileName$paddedNumber$fileExtension"
$fullPath = Join-Path -Path $documentsPath -ChildPath $newFileName

# Get clipboard content
try {
    $clipboardContent = Get-Clipboard -Raw
    
    if ([string]::IsNullOrWhiteSpace($clipboardContent)) {
        Write-Host "ERROR: Clipboard is empty!" -ForegroundColor Red
        Write-Host "Copy your chat log to clipboard first, then run this script." -ForegroundColor Yellow
        exit 1
    }
    
    # Save to file
    Set-Content -Path $fullPath -Value $clipboardContent -Encoding UTF8
    
    # Success message
    Write-Host ""
    Write-Host "✓ Chat log saved successfully!" -ForegroundColor Green
    Write-Host "  File: $newFileName" -ForegroundColor Cyan
    Write-Host "  Path: $fullPath" -ForegroundColor Gray
    Write-Host "  Size: $([math]::Round((Get-Item $fullPath).Length / 1KB, 2)) KB" -ForegroundColor Gray
    Write-Host ""
    
    # Ask if user wants to open the file
    $open = Read-Host "Open file? (Y/N)"
    if ($open -eq "Y" -or $open -eq "y") {
        Invoke-Item $fullPath
    }
    
} catch {
    Write-Host "ERROR: Failed to save chat log" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}
