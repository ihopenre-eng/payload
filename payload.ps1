# ===============================
#  Multi-Window Popup Showcase
# ===============================

$ErrorActionPreference = "SilentlyContinue"

$yt = "https://www.youtube.com/watch?v=YOUR_VIDEO_ID"

function LaunchWindow($title, $lines, $delay=30) {
    $script = @"
`$Host.UI.RawUI.WindowTitle = '$title'
Clear-Host
foreach (`$l in @($($lines | ForEach-Object { "'$_'" } -join ","))) {
    Write-Host `$l
    Start-Sleep -Milliseconds $delay
}
Start-Sleep -Seconds 2
"@
    Start-Process powershell -ArgumentList "-NoExit","-ExecutionPolicy Bypass","-Command",$script
}

# 창 1
LaunchWindow "MODULE INIT" @(
    "[+] USB interface detected",
    "[+] Loading runtime",
    "[+] Allocating memory blocks",
    "[+] Environment OK"
) 40

Start-Sleep -Milliseconds 200

# 창 2
LaunchWindow "PIPELINE" @(
    "[*] Stage 1 started",
    "[*] Stage 2 started",
    "[*] Stage 3 started",
    "[*] Synchronizing streams"
) 25

Start-Sleep -Milliseconds 200

# 창 3
LaunchWindow "STREAM" @(
    "[>] Buffering output",
    "[>] Rendering console feed",
    "[>] Injecting visual layer",
    "[>] Channel stable"
) 20

Start-Sleep -Milliseconds 200

# 창 4 (프로그레스 전용)
$progressScript = @"
`$Host.UI.RawUI.WindowTitle = 'PROGRESS'
Clear-Host
for (`$i=0; `$i -le 100; `$i++) {
    `$bar = '#' * (`$i/2)
    `$space = ' ' * (50 - (`$i/2))
    Write-Host -NoNewline "`r[`$bar`$space] `$i% "
    Start-Sleep -Milliseconds (Get-Random -Minimum 20 -Maximum 50)
}
Start-Sleep -Seconds 2
"@
Start-Process powershell -ArgumentList "-NoExit","-ExecutionPolicy Bypass","-Command",$progressScript

Start-Sleep -Seconds 3

# 최종 SUCCESS 창
$finalScript = @"
`$Host.UI.RawUI.WindowTitle = 'RESULT'
Clear-Host
Write-Host ''
Write-Host '==============================='
Write-Host '          SUCCESSFUL           '
Write-Host '==============================='
Write-Host ''
Start-Sleep -Milliseconds 800
Start-Process '$yt'
"@
Start-Process powershell -ArgumentList "-NoExit","-ExecutionPolicy Bypass","-Command",$finalScript
