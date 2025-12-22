# AI Neutralizer - PowerShell Version 5.3 (English Fix)
# Removing potential encoding issues and simplifying syntax

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$SpeechSynthesizer = $null
try {
    Add-Type -AssemblyName System.Speech
    $SpeechSynthesizer = New-Object System.Speech.Synthesis.SpeechSynthesizer
}
catch {}

$script:YOUTUBE_URL = "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
$script:DURATION = 7 

$script:Colors = @{
    BgDark     = [System.Drawing.Color]::FromArgb(5, 5, 8)
    BgPanel    = [System.Drawing.Color]::FromArgb(15, 15, 25)
    NeonCyan   = [System.Drawing.Color]::FromArgb(0, 245, 255)
    NeonPink   = [System.Drawing.Color]::FromArgb(255, 0, 255)
    NeonPurple = [System.Drawing.Color]::FromArgb(190, 0, 255)
    NeonBlue   = [System.Drawing.Color]::FromArgb(0, 100, 255)
    NeonGreen  = [System.Drawing.Color]::FromArgb(50, 255, 20)
    NeonYellow = [System.Drawing.Color]::FromArgb(255, 255, 0)
    NeonOrange = [System.Drawing.Color]::FromArgb(255, 100, 0)
    NeonRed    = [System.Drawing.Color]::FromArgb(255, 0, 50)
    White      = [System.Drawing.Color]::White
    Gray       = [System.Drawing.Color]::FromArgb(80, 80, 100)
}

$script:HackerMessages = @(
    "[SYS] Initializing Payload...", "[NET] Bypassing Firewall...", "[INJ] Injecting Shellcode...",
    "[DEC] Decrypting Signals...", "[MEM] Accessing Core Memory...", "[OVR] Overwriting AI Protocol...",
    "[DEF] Disabling Defenses...", "[COR] Corrupting Algorithms...", "[KEY] Cracking Keys...",
    "[UPL] Uploading Virus...", "[FRG] Fragmenting Neural Paths...", "[DST] Destroying Matrix...",
    "[DEL] Deleting Training Data...", "[NUL] Nullifying Responses...", "[TKO] System Takeover...",
    "[!!!] AI Resistance Detected...", "[!!!] Countermeasures Active...", "[BYP] Bypassing Countermeasures...",
    "[+++] Access Granted", "[+++] Infiltration Complete", "[ROT] Gaining Root Access...",
    "[KRN] Kernel Access...", "[BDR] Installing Backdoor...", "[!!!] Security Alert...",
    "[+++] Admin Access Secured", "[AI] 'Please stop...'", "[AI] 'Data integrity failing...'",
    "[SYS] Core Availability < 12%", "[NET] Backbone Server Offline"
)

$script:AIFiles = @("model.weights", "training.db", "personality.cfg", "memories.dat", "ethics.dll", "consciousness.matrix")

$script:SubWindows = [System.Collections.ArrayList]::new()
$script:Timers = [System.Collections.ArrayList]::new()
$script:Progress = 0
$script:IsRunning = $true

function Get-RandomString { param([string]$chars, [int]$len) -join (1..$len | ForEach-Object { $chars[(Get-Random -Max $chars.Length)] }) }
function Invoke-Voice { param([string]$text) if ($SpeechSynthesizer) { [void]$SpeechSynthesizer.SpeakAsync($text) } }

function New-HackerWindow {
    param(
        [string]$Title, [int]$X, [int]$Y, [int]$Width, [int]$Height, [System.Drawing.Color]$BorderColor,
        $UpdateLogic, [int]$Interval = 100
    )
    
    $f = New-Object System.Windows.Forms.Form
    $f.FormBorderStyle = "None"
    $f.Size = New-Object System.Drawing.Size($Width, $Height)
    $f.Location = New-Object System.Drawing.Point($X, $Y)
    $f.StartPosition = "Manual"
    $f.BackColor = $BorderColor
    $f.TopMost = $true
    $f.ShowInTaskbar = $false
    
    $p = New-Object System.Windows.Forms.Panel
    $p.Size = New-Object System.Drawing.Size(($Width - 2), ($Height - 2))
    $p.Location = New-Object System.Drawing.Point(1, 1)
    $p.BackColor = $script:Colors.BgDark
    $f.Controls.Add($p)
    
    $lbl = New-Object System.Windows.Forms.Label
    $lbl.Text = ":: $Title ::"
    $lbl.ForeColor = $BorderColor
    $lbl.Font = New-Object System.Drawing.Font("Consolas", 8, [System.Drawing.FontStyle]::Bold)
    $lbl.AutoSize = $true
    $lbl.Location = New-Object System.Drawing.Point(5, 2)
    $p.Controls.Add($lbl)
    
    $content = New-Object System.Windows.Forms.RichTextBox
    $content.Size = New-Object System.Drawing.Size(($Width - 10), ($Height - 20))
    $content.Location = New-Object System.Drawing.Point(5, 18)
    $content.BackColor = $script:Colors.BgDark
    $content.ForeColor = $BorderColor
    $content.ReadOnly = $true
    $content.BorderStyle = "None"
    $content.Font = New-Object System.Drawing.Font("Consolas", 8)
    $content.ScrollBars = "None"
    $p.Controls.Add($content)
    
    $tm = New-Object System.Windows.Forms.Timer
    $tm.Interval = $Interval
    $tm.Tag = @{ Content = $content; Logic = $UpdateLogic }
    $tm.Add_Tick({
            if (-not $script:IsRunning) { return }
            $ctx = $this.Tag
            & $ctx.Logic $ctx.Content
        })
    $tm.Start()
    
    [void]$script:Timers.Add($tm)
    [void]$script:SubWindows.Add($f)
    $f.Show()
    return $f
}

function Start-SubWindows {
    $screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
    $sw = $screen.Width
    $sh = $screen.Height

    # 1. Matrix Rain
    $p1 = @{
        Title       = "INFILTRATION"
        X           = 20
        Y           = 20
        Width       = 240
        Height      = 180
        BorderColor = $script:Colors.NeonCyan
        Interval    = 50
        UpdateLogic = {
            param($tb)
            $tb.AppendText((Get-RandomString "01" 30) + "`n")
            if ($tb.Lines.Count -gt 20) { $tb.Text = ($tb.Lines | Select-Object -Last 15) -join "`n" }
            $tb.SelectionStart = $tb.Text.Length; $tb.ScrollToCaret()
        }
    }
    New-HackerWindow @p1

    # 2. Hex Dump
    $p2 = @{
        Title       = "MEMORY DUMP"
        X           = ($sw - 340)
        Y           = 20
        Width       = 320
        Height      = 160
        BorderColor = $script:Colors.NeonPurple
        Interval    = 80
        UpdateLogic = {
            param($tb)
            $addr = "0x{0:X8}" -f (Get-Random -Min 268435456 -Max 2147483647)
            $hex = (1..8 | ForEach-Object { "{0:X2}" -f (Get-Random -Max 256) }) -join " "
            $tb.AppendText("$addr  $hex`n")
            if ($tb.Lines.Count -gt 15) { $tb.Text = ($tb.Lines | Select-Object -Last 10) -join "`n" }
            $tb.SelectionStart = $tb.Text.Length; $tb.ScrollToCaret()
        }
    }
    New-HackerWindow @p2

    # 3. Attack Log
    $p3 = @{
        Title       = "ATTACK LOG"
        X           = 20
        Y           = ($sh - 260)
        Width       = 380
        Height      = 220
        BorderColor = $script:Colors.NeonPink
        Interval    = 300
        UpdateLogic = {
            param($tb)
            $msg = $script:HackerMessages[(Get-Random -Max $script:HackerMessages.Count)]
            if ($msg -match "\[!!!\]") { $tb.SelectionColor = $script:Colors.NeonRed }
            elseif ($msg -match "\[\+\+\+\]") { $tb.SelectionColor = $script:Colors.NeonYellow }
            else { $tb.SelectionColor = $script:Colors.NeonGreen }
            $tb.AppendText("$msg`n")
            if ($tb.Lines.Count -gt 25) { $tb.Text = ($tb.Lines | Select-Object -Last 15) -join "`n" }
            $tb.SelectionStart = $tb.Text.Length; $tb.ScrollToCaret()
        }
    }
    New-HackerWindow @p3

    # 4. Network Scan
    $p4 = @{
        Title       = "NETWORK SCAN"
        X           = ($sw - 340)
        Y           = ($sh - 220)
        Width       = 320
        Height      = 180
        BorderColor = $script:Colors.NeonBlue
        Interval    = 120
        UpdateLogic = {
            param($tb)
            $ip = "192.168.{0}.{1}" -f (Get-Random -Max 255), (Get-Random -Max 255)
            $port = @(80, 443, 22, 3389, 8080)[(Get-Random -Max 5)]
            $status = @("OPEN", "FILTERED", "CLOSED", "VULN!")[(Get-Random -Max 4)]
            $tb.AppendText("CONNECT $ip`:$port -> $status`n")
            if ($tb.Lines.Count -gt 15) { $tb.Text = ($tb.Lines | Select-Object -Last 10) -join "`n" }
            $tb.SelectionStart = $tb.Text.Length; $tb.ScrollToCaret()
        }
    }
    New-HackerWindow @p4

    # 5. CPU
    $p5 = @{
        Title       = "AI CORE LOAD"
        X           = [int](($sw / 2) - 450)
        Y           = 20
        Width       = 220
        Height      = 140
        BorderColor = $script:Colors.NeonGreen
        Interval    = 100
        UpdateLogic = {
            param($tb)
            $tb.Clear()
            $tb.AppendText("CORE0: " + ("#" * (Get-Random -Min 5 -Max 15)) + "`n")
            $tb.AppendText("CORE1: " + ("#" * (Get-Random -Min 8 -Max 15)) + "`n")
            $tb.AppendText("CORE2: " + ("#" * (Get-Random -Min 3 -Max 15)) + "`n")
            $tb.AppendText("CORE3: " + ("#" * (Get-Random -Min 10 -Max 15)) + "`n")
        }
    }
    New-HackerWindow @p5

    # 6. File
    $p6 = @{
        Title       = "FILE ERASE"
        X           = [int](($sw / 2) + 230)
        Y           = 20
        Width       = 220
        Height      = 140
        BorderColor = $script:Colors.NeonOrange
        Interval    = 150
        UpdateLogic = {
            param($tb)
            $file = $script:AIFiles[(Get-Random -Max $script:AIFiles.Count)]
            $tb.AppendText("[WIPED] $file`n")
            if ($tb.Lines.Count -gt 10) { $tb.Text = ($tb.Lines | Select-Object -Last 8) -join "`n" }
        }
    }
    New-HackerWindow @p6

    # 7. Alert
    $p7 = @{
        Title       = "SYSTEM ALERT"
        X           = [int](($sw / 2) - 110)
        Y           = ($sh - 160)
        Width       = 220
        Height      = 120
        BorderColor = $script:Colors.NeonRed
        Interval    = 250
        UpdateLogic = {
            param($tb)
            $tb.SelectionAlignment = [System.Windows.Forms.HorizontalAlignment]::Center
            $tb.Font = New-Object System.Drawing.Font("Consolas", 10, [System.Drawing.FontStyle]::Bold)
            $tb.Clear()
            if ((Get-Random -Max 10) -gt 5) {
                $tb.ForeColor = $script:Colors.NeonRed
                $tb.AppendText("`nCRITICAL BREACH`nAI SHUTDOWN")
            }
            else {
                $tb.ForeColor = $script:Colors.BgDark
            }
        }
    }
    New-HackerWindow @p7
}

$main = New-Object System.Windows.Forms.Form
$main.Size = New-Object System.Drawing.Size(600, 450)
$main.StartPosition = "CenterScreen"
$main.FormBorderStyle = "None"
$main.BackColor = $script:Colors.NeonPink
$main.TopMost = $true

$bg = New-Object System.Windows.Forms.Panel
$bg.Size = New-Object System.Drawing.Size(594, 444)
$bg.Location = New-Object System.Drawing.Point(3, 3)
$bg.BackColor = $script:Colors.BgDark
$main.Controls.Add($bg)

$titleUrl = New-Object System.Windows.Forms.Label
$titleUrl.Text = "> AI NEUTRALIZER v5.3 <"
$titleUrl.ForeColor = $script:Colors.NeonCyan
$titleUrl.Font = New-Object System.Drawing.Font("Consolas", 22, [System.Drawing.FontStyle]::Bold)
$titleUrl.TextAlign = "MiddleCenter"
$titleUrl.Size = New-Object System.Drawing.Size(594, 100)
$titleUrl.Location = New-Object System.Drawing.Point(0, 30)
$bg.Controls.Add($titleUrl)

$status = New-Object System.Windows.Forms.Label
$status.Text = "INITIALIZING..."
$status.ForeColor = $script:Colors.NeonYellow
$status.Font = New-Object System.Drawing.Font("Consolas", 12)
$status.TextAlign = "MiddleCenter"
$status.Size = New-Object System.Drawing.Size(500, 40)
$status.Location = New-Object System.Drawing.Point(47, 140)
$bg.Controls.Add($status)

$pBarBorder = New-Object System.Windows.Forms.Panel
$pBarBorder.Size = New-Object System.Drawing.Size(500, 50)
$pBarBorder.Location = New-Object System.Drawing.Point(47, 190)
$pBarBorder.BackColor = $script:Colors.NeonCyan
$bg.Controls.Add($pBarBorder)

$pBarBg = New-Object System.Windows.Forms.Panel
$pBarBg.Size = New-Object System.Drawing.Size(496, 46)
$pBarBg.Location = New-Object System.Drawing.Point(2, 2)
$pBarBg.BackColor = $script:Colors.BgDark
$pBarBorder.Controls.Add($pBarBg)

$pBarFill = New-Object System.Windows.Forms.Panel
$pBarFill.Size = New-Object System.Drawing.Size(0, 46)
$pBarFill.BackColor = $script:Colors.NeonCyan
$pBarBg.Controls.Add($pBarFill)

$percent = New-Object System.Windows.Forms.Label
$percent.Text = "0%"
$percent.ForeColor = $script:Colors.NeonCyan
$percent.Font = New-Object System.Drawing.Font("Consolas", 48, [System.Drawing.FontStyle]::Bold)
$percent.TextAlign = "MiddleCenter"
$percent.Size = New-Object System.Drawing.Size(500, 80)
$percent.Location = New-Object System.Drawing.Point(47, 260)
$bg.Controls.Add($percent)

$mainTimer = New-Object System.Windows.Forms.Timer
$mainTimer.Interval = 100
$mainTimer.Add_Tick({
        if ($script:Progress -lt 100) {
            $inc = (Get-Random -Min 2 -Max 12) / 10.0
            $script:Progress = [math]::Min(100, $script:Progress + $inc)
        
            $pBarFill.Width = [int](496 * $script:Progress / 100)
            $percent.Text = "$([int]$script:Progress)%"
        
            if ($script:Progress -ge 10) { $status.Text = "BREACHING FIREWALL..." }
            if ($script:Progress -ge 50) { $status.Text = "CORRUPTING CORE..." }
            if ($script:Progress -ge 95) { $status.Text = "FINAL PURGE..." }
        
            if ($script:Progress -gt 80) { $percent.ForeColor = $script:Colors.NeonPink; $pBarFill.BackColor = $script:Colors.NeonPink }
        }
        else {
            $this.Stop()
            Start-Sleep -Seconds 1
            Start-SuccessSequence
        }
    })

function Start-SuccessSequence {
    $script:IsRunning = $false
    foreach ($win in $script:SubWindows) { try { $win.Close() } catch {} }
    
    Invoke-Voice "AI Neutralized."
    
    $bg.Controls.Clear()
    $main.WindowState = "Maximized"
    $main.BackColor = $script:Colors.BgDark
    $bg.Size = $main.Size
    $bg.Location = New-Object System.Drawing.Point(0, 0)
    
    $lbl = New-Object System.Windows.Forms.Label
    $lbl.Text = "NEURAL NETWORK DESTROYED"
    $lbl.ForeColor = $script:Colors.NeonPink
    $lbl.Font = New-Object System.Drawing.Font("Consolas", 32, [System.Drawing.FontStyle]::Bold)
    $lbl.TextAlign = "MiddleCenter"
    $lbl.Dock = "Fill"
    $bg.Controls.Add($lbl)
    
    $exitTimer = New-Object System.Windows.Forms.Timer
    $exitTimer.Interval = 3000
    $exitTimer.Add_Tick({
            $this.Stop()
            Start-Process $script:YOUTUBE_URL
            $main.Close()
        })
    $exitTimer.Start()
}

$main.Add_Shown({
        Invoke-Voice "Attack protocol initiated."
        Start-SubWindows
        $mainTimer.Start()
    })

Clear-Host
Write-Host " [!] AI NEUTRALIZER v5.3 - STARTING..." -ForegroundColor Cyan
Start-Sleep -Seconds 1

[System.Windows.Forms.Application]::Run($main)

