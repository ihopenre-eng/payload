

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$SpeechSynthesizer = $null
try {
    Add-Type -AssemblyName System.Speech
    $SpeechSynthesizer = New-Object System.Speech.Synthesis.SpeechSynthesizer
}
catch {}

$script:YOUTUBE_URL = "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
$script:DURATION = 4 

$script:Colors = @{
    BgDark     = [System.Drawing.Color]::FromArgb(5, 5, 8)
    BgPanel    = [System.Drawing.Color]::FromArgb(5, 10, 15)
    NeonCyan   = [System.Drawing.Color]::FromArgb(0, 255, 255) 
    NeonBlue   = [System.Drawing.Color]::FromArgb(30, 144, 255) 
    NeonGreen  = [System.Drawing.Color]::FromArgb(50, 255, 50)  
    NeonRed    = [System.Drawing.Color]::FromArgb(255, 50, 50)  
    NeonOrange = [System.Drawing.Color]::FromArgb(255, 140, 0)
    NeonYellow = [System.Drawing.Color]::FromArgb(255, 215, 0)
    White      = [System.Drawing.Color]::White
    Gray       = [System.Drawing.Color]::FromArgb(60, 60, 80)
    TargetRed  = [System.Drawing.Color]::FromArgb(255, 20, 20)
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

$script:SubWindows = [System.Collections.ArrayList]::new()
$script:Timers = [System.Collections.ArrayList]::new()
$script:Progress = 0
$script:IsRunning = $true

function Get-RandomString { param([string]$chars, [int]$len) -join (1..$len | ForEach-Object { $chars[(Get-Random -Max $chars.Length)] }) }
function Invoke-Voice { param([string]$text) if ($SpeechSynthesizer) { [void]$SpeechSynthesizer.SpeakAsync($text) } }

# --- Base Window Creator ---
function New-BaseWindow {
    param([string]$Title, [int]$X, [int]$Y, [int]$Width, [int]$Height, [System.Drawing.Color]$BorderColor, [bool]$Transparent = $false)
    
    $f = New-Object System.Windows.Forms.Form
    $f.FormBorderStyle = "None"
    $f.Size = New-Object System.Drawing.Size($Width, $Height)
    $f.Location = New-Object System.Drawing.Point($X, $Y)
    $f.StartPosition = "Manual"
    if ($Transparent) { $f.Opacity = 0.85 }
    $f.BackColor = $BorderColor
    $f.TopMost = $false
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
    $lbl.Location = New-Object System.Drawing.Point(3, 2)
    $p.Controls.Add($lbl)

    return @{ Form = $f; Panel = $p }
}

# --- Text based Hacker Window ---
function New-HackerWindow {
    param(
        [string]$Title, [int]$X, [int]$Y, [int]$Width, [int]$Height, [System.Drawing.Color]$BorderColor,
        $UpdateLogic, [int]$Interval = 100, [bool]$IsBackground = $false
    )
    
    $base = New-BaseWindow -Title $Title -X $X -Y $Y -Width $Width -Height $Height -BorderColor $BorderColor -Transparent $IsBackground
    $f = $base.Form
    $p = $base.Panel
    
    if ($IsBackground) { $f.SendToBack() } else { $f.TopMost = $true }

    $content = New-Object System.Windows.Forms.RichTextBox
    $content.Size = New-Object System.Drawing.Size(($Width - 12), ($Height - 30))
    $content.Location = New-Object System.Drawing.Point(5, 20)
    $content.BackColor = $script:Colors.BgDark
    $content.ForeColor = $BorderColor
    $content.ReadOnly = $true
    $content.BorderStyle = "None"
    $content.ScrollBars = "None"
    $content.WordWrap = $false
    $content.Font = New-Object System.Drawing.Font("Consolas", 8)
    $p.Controls.Add($content)
    
    $tm = New-Object System.Windows.Forms.Timer
    $tm.Interval = $Interval
    $tm.Tag = @{ Content = $content; Logic = $UpdateLogic; Form = $f }
    $tm.Add_Tick({
            $t = $this.Tag
            if ($null -eq $t -or $t.Form.IsDisposed -or -not $script:IsRunning) {
                $this.Stop()
                return
            }
            try {
                if (-not $t.Content.IsDisposed) {
                    & $t.Logic $t.Content
                }
            }
            catch {}
        })
    
    [void]$script:Timers.Add($tm)
    [void]$script:SubWindows.Add($f)
    $f.Show()
    $tm.Start()
}

# --- Graphical/Radar Window ---
function New-GraphicWindow {
    param(
        [string]$Title, [int]$X, [int]$Y, [int]$Width, [int]$Height, [System.Drawing.Color]$BorderColor,
        [string]$Type, [int]$Interval = 50
    )

    $base = New-BaseWindow -Title $Title -X $X -Y $Y -Width $Width -Height $Height -BorderColor $BorderColor
    $f = $base.Form
    $f.TopMost = $true
    $p = $base.Panel

    $canvas = New-Object System.Windows.Forms.PictureBox
    $canvas.Size = New-Object System.Drawing.Size(($Width - 4), ($Height - 25))
    $canvas.Location = New-Object System.Drawing.Point(2, 20)
    $canvas.BackColor = $script:Colors.BgDark
    $p.Controls.Add($canvas)

    $ctx = @{
        Angle  = 0
        Points = [System.Collections.ArrayList]::new()
        Type   = $Type
        Color  = $BorderColor
    }

    if ($Type -eq "WAVE") { 0..40 | % { [void]$ctx.Points.Add(0.0) } }
    if ($Type -eq "RADAR") {
        0..6 | % {  
            [void]$ctx.Points.Add(@{ 
                    X = (Get-Random -Min 20 -Max ($canvas.Width - 20)); 
                    Y = (Get-Random -Min 20 -Max ($canvas.Height - 20));
                })
        }
    }
    if ($Type -eq "BARS") { 0..15 | % { [void]$ctx.Points.Add([int]50) } }
    if ($Type -eq "GRID") {
        # Grid for server status (8x8)
        0..63 | % { [void]$ctx.Points.Add([bool]($true)) }
    }

    $canvas.Tag = $ctx

    $canvas.Add_Paint({
            param($sender, $e)
            $g = $e.Graphics
            $c = $sender.Tag
            $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
        
            $penColor = $c.Color
            $w = $sender.Width
            $h = $sender.Height

            if ($c.Type -eq "RADAR") {
                $cx = $w / 2
                $cy = $h / 2
                $r = [Math]::Min($cx, $cy) - 10
            
                $gridPen = New-Object System.Drawing.Pen($script:Colors.Gray, 1)
                $g.DrawEllipse($gridPen, [int]($cx - $r), [int]($cy - $r), [int]($r * 2), [int]($r * 2))
                $g.DrawEllipse($gridPen, [int]($cx - $r * 0.66), [int]($cy - $r * 0.66), [int]($r * 1.33), [int]($r * 1.33))
            
                $angleRad = $c.Angle * [Math]::PI / 180.0
                $lx = $cx + [Math]::Cos($angleRad) * $r
                $ly = $cy + [Math]::Sin($angleRad) * $r
            
                $sweepPen = New-Object System.Drawing.Pen($penColor, 3)
                $g.DrawLine($sweepPen, [int]$cx, [int]$cy, [int]$lx, [int]$ly)

                $brush = New-Object System.Drawing.SolidBrush($script:Colors.TargetRed)
                foreach ($pt in $c.Points) { $g.FillEllipse($brush, [int]$pt.X, [int]$pt.Y, 8, 8) }
            }
            elseif ($c.Type -eq "WAVE") {
                $wavePen = New-Object System.Drawing.Pen($penColor, 2)
                $midY = $h / 2
                $stepX = $w / ($c.Points.Count - 1)
                for ($i = 0; $i -lt $c.Points.Count - 1; $i++) {
                    $y1 = $midY + ($c.Points[$i] * 30)
                    $y2 = $midY + ($c.Points[$i + 1] * 30)
                    $g.DrawLine($wavePen, [float]($i * $stepX), [float]$y1, [float](($i + 1) * $stepX), [float]$y2)
                }
            }
            elseif ($c.Type -eq "BARS") {
                $barW = $w / $c.Points.Count
                $brush = New-Object System.Drawing.SolidBrush($penColor)
                for ($i = 0; $i -lt $c.Points.Count; $i++) {
                    $val = $c.Points[$i]
                    $barH = ($h * $val) / 100
                    $g.FillRectangle($brush, [float]($i * $barW), [float]($h - $barH), [float]($barW - 2), [float]$barH)
                }
            }
            elseif ($c.Type -eq "GRID") {
                $cols = 8
                $rows = 8
                $cellW = $w / $cols
                $cellH = $h / $rows
                $onBrush = New-Object System.Drawing.SolidBrush($penColor)
                $offBrush = New-Object System.Drawing.SolidBrush($script:Colors.Gray)
            
                for ($i = 0; $i -lt $c.Points.Count; $i++) {
                    $r = [Math]::Floor($i / $cols)
                    $c_idx = $i % $cols
                    $brush = if ($c.Points[$i]) { $onBrush } else { $offBrush }
                    $g.FillRectangle($brush, [float]($c_idx * $cellW + 2), [float]($r * $cellH + 2), [float]($cellW - 4), [float]($cellH - 4))
                }
            }
        })

    $tm = New-Object System.Windows.Forms.Timer
    $tm.Interval = $Interval
    $tm.Tag = @{ Canvas = $canvas; Form = $f; Time = 0.0 }
    $tm.Add_Tick({
            $t = $this.Tag
            if ($null -eq $t -or $t.Form.IsDisposed -or -not $script:IsRunning) {
                $this.Stop()
                return
            }
            $ctx = $t.Canvas.Tag
            $t.Time += 0.2
            
            if ($ctx.Type -eq "RADAR") {
                $ctx.Angle = ($ctx.Angle + 12) % 360 
                $t.Canvas.Invalidate()
            }
            elseif ($ctx.Type -eq "WAVE") {
                $ctx.Points.RemoveAt(0)
                $noise = [Math]::Sin($t.Time) * [Math]::Cos($t.Time * 2.5)
                $ctx.Points.Add($noise)
                $t.Canvas.Invalidate()
            }
            elseif ($ctx.Type -eq "BARS") {
                for ($i = 0; $i -lt $ctx.Points.Count; $i++) {
                    if ((Get-Random -Max 10) -gt 7) {
                        $ctx.Points[$i] = Get-Random -Min 5 -Max 95
                    }
                }
                $t.Canvas.Invalidate()
            }
            elseif ($ctx.Type -eq "GRID") {
                # Flicker random bits
                $idx = Get-Random -Max $ctx.Points.Count
                $ctx.Points[$idx] = -not $ctx.Points[$idx]
                $t.Canvas.Invalidate()
            }
        })

    [void]$script:Timers.Add($tm)
    [void]$script:SubWindows.Add($f)
    $f.Show()
    $tm.Start()
}

function Start-SubWindows {
    $screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
    $sw = $screen.Width
    $sh = $screen.Height
    
    $CenterX = $sw / 2
    $CenterY = $sh / 2
    
    # === LAYER 1: Background Data Streams (Coverage) ===
    # Left Side Stream
    New-HackerWindow -Title "DATA_STREAM_01" -X 10 -Y 10 -Width 350 -Height ($sh - 50) -BorderColor $script:Colors.Gray -Interval 20 -IsBackground $true -UpdateLogic {
        param($tb)
        $tb.ForeColor = [System.Drawing.Color]::FromArgb(40, 60, 40) # Very Dark Green
        $tb.AppendText((Get-RandomString "01  " 50) + "`n")
        if ($tb.Lines.Count -gt 50) { $tb.Text = ($tb.Lines | Select-Object -Last 40) -join "`n" }
    }
    # Right Side Stream
    New-HackerWindow -Title "DATA_STREAM_02" -X ($sw - 360) -Y 10 -Width 350 -Height ($sh - 50) -BorderColor $script:Colors.Gray -Interval 25 -IsBackground $true -UpdateLogic {
        param($tb)
        $tb.ForeColor = [System.Drawing.Color]::FromArgb(40, 60, 40)
        $tb.AppendText((Get-RandomString "01  " 50) + "`n")
        if ($tb.Lines.Count -gt 50) { $tb.Text = ($tb.Lines | Select-Object -Last 40) -join "`n" }
    }

    # === LAYER 2: Hero Graphics (Fixed Positions) ===
    New-GraphicWindow -Title "GLOBAL SCAN" -X 50 -Y 80 -Width 320 -Height 320 -BorderColor $script:Colors.NeonGreen -Type "RADAR" -Interval 40
    New-GraphicWindow -Title "SIGNAL ANALYSIS" -X ($sw / 2 - 250) -Y ($sh - 200) -Width 500 -Height 180 -BorderColor $script:Colors.NeonBlue -Type "WAVE" -Interval 30
    New-GraphicWindow -Title "CORE VITALS" -X 50 -Y ($sh - 250) -Width 300 -Height 200 -BorderColor $script:Colors.NeonOrange -Type "BARS" -Interval 60
    
    # NEW: SERVER GRID (Top Mid-Left gap filler)
    New-GraphicWindow -Title "SERVER NODES" -X 380 -Y 80 -Width 200 -Height 200 -BorderColor $script:Colors.NeonYellow -Type "GRID" -Interval 80

    # === LAYER 3: Main Status Windows (Fixed) ===
    # Infiltration column (Right side)
    New-HackerWindow -Title "INFILTRATION" -X ($sw - 300) -Y 50 -Width 250 -Height 400 -BorderColor $script:Colors.NeonCyan -Interval 40 -UpdateLogic {
        param($tb)
        $tb.AppendText((Get-RandomString "01  " 20) + "`n")
        if ($tb.Lines.Count -gt 25) { $tb.Text = ($tb.Lines | Select-Object -Last 20) -join "`n" }
    }
    # Memory Map (Bottom Left)
    New-HackerWindow -Title "MEMORY MAP" -X 50 -Y 450 -Width 320 -Height 150 -BorderColor $script:Colors.NeonBlue -Interval 60 -UpdateLogic {
        param($tb)
        $addr = "0x{0:X4}" -f (Get-Random -Max 65535)
        $hex = (1..6 | ForEach-Object { "{0:X2}" -f (Get-Random -Max 256) }) -join " "
        $tb.AppendText("$addr $hex`n")
        if ($tb.Lines.Count -gt 15) { $tb.Text = ($tb.Lines | Select-Object -Last 10) -join "`n" }
    }
    # Attack Events (Bottom Right)
    New-HackerWindow -Title "ATTACK EVENTS" -X ($sw - 420) -Y ($sh - 300) -Width 380 -Height 250 -BorderColor $script:Colors.NeonRed -Interval 150 -UpdateLogic {
        param($tb)
        $msg = $script:HackerMessages[(Get-Random -Max $script:HackerMessages.Count)]
        if ($msg -match "!!!") { $tb.SelectionColor = $script:Colors.NeonRed }
        elseif ($msg -match "\+\+\+") { $tb.SelectionColor = $script:Colors.NeonYellow }
        else { $tb.SelectionColor = $script:Colors.NeonGreen }
        $tb.AppendText("$msg`n")
        if ($tb.Lines.Count -gt 15) { $tb.Text = ($tb.Lines | Select-Object -Last 12) -join "`n" }
        $tb.SelectionStart = $tb.Text.Length; $tb.ScrollToCaret()
    }
    # Link (Far Right)
    New-HackerWindow -Title "LINK" -X ($sw - 80) -Y 100 -Width 60 -Height 500 -BorderColor $script:Colors.White -Interval 100 -UpdateLogic {
        param($tb)
        $tb.AppendText("|`n")
        if ($tb.Lines.Count -gt 30) { $tb.Text = ($tb.Lines | Select-Object -Last 20) -join "`n" }
    }
    # CPU (Top Right-Center)
    New-HackerWindow -Title "CPU" -X ($sw / 2 + 250) -Y 60 -Width 180 -Height 150 -BorderColor $script:Colors.NeonOrange -Interval 80 -UpdateLogic {
        param($tb)
        $tb.Clear()
        1..5 | % { $tb.AppendText("C$_ [" + ("#" * (Get-Random -Min 2 -Max 8)) + "]`n") }
    }
    # NEW: Decrypt (Mid Right Gap)
    New-HackerWindow -Title "DECRYPT" -X ($sw - 550) -Y 300 -Width 180 -Height 100 -BorderColor $script:Colors.NeonBlue -Interval 40 -UpdateLogic {
        param($tb)
        $tb.Text = (Get-RandomString "X0" 30)
    }

    # === LAYER 4: FILLER POPUPS (8 Windows) ===
    # We define 4 safe corners (TopLeft, TopRight, BotLeft, BotRight)
    # We spawn 2 windows in each quadrant to ensure coverage
    
    $corners = @(
        @{X1 = 50; Y1 = 50; X2 = $CenterX - 100; Y2 = $CenterY - 100 },      # TL
        @{X1 = $CenterX + 100; Y1 = 50; X2 = $sw - 50; Y2 = $CenterY - 100 },  # TR
        @{X1 = 50; Y1 = $CenterY + 100; X2 = $CenterX - 100; Y2 = $sh - 100 }, # BL
        @{X1 = $CenterX + 100; Y1 = $CenterY + 100; X2 = $sw - 50; Y2 = $sh - 100 } # BR
    )
    
    foreach ($c in $corners) {
        1..2 | % {
            $w = Get-Random -Min 200 -Max 300
            $h = Get-Random -Min 150 -Max 200
            
            # Safe checking
            if ($c.X2 -le $c.X1) { $c.X2 = $c.X1 + 10 }
            if ($c.Y2 -le $c.Y1) { $c.Y2 = $c.Y1 + 10 }
            
            $maxX = $c.X2 - $w
            if ($maxX -le $c.X1) { $maxX = $c.X1 + 10 }
            
            $maxY = $c.Y2 - $h
            if ($maxY -le $c.Y1) { $maxY = $c.Y1 + 10 }

            $x = Get-Random -Min $c.X1 -Max $maxX
            $y = Get-Random -Min $c.Y1 -Max $maxY
            
            $cols = @($script:Colors.NeonGreen, $script:Colors.NeonCyan, $script:Colors.NeonBlue)
            $col = $cols[(Get-Random -Max 3)]
            
            New-HackerWindow -Title ("NODE_" + (Get-Random -Min 100 -Max 999)) -X $x -Y $y -Width $w -Height $h -BorderColor $col -Interval (Get-Random -Min 50 -Max 150) -UpdateLogic {
                param($tb)
                $tb.AppendText("0x" + (Get-RandomString "F0" 8) + "`n")
                if ($tb.Lines.Count -gt 10) { $tb.Text = ($tb.Lines | Select-Object -Last 8) -join "`n" }
            }
        }
    }
}

$main = New-Object System.Windows.Forms.Form
$main.Size = New-Object System.Drawing.Size(600, 450)
$main.StartPosition = "CenterScreen"
$main.FormBorderStyle = "None"
$main.BackColor = $script:Colors.NeonBlue
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
$mainTimer.Interval = 30  
$mainTimer.Add_Tick({
        if ($script:Progress -lt 100) {
            $inc = (Get-Random -Min 5 -Max 25) / 10.0 
            $script:Progress = [math]::Min(100, $script:Progress + $inc)
        
            $pBarFill.Width = [int](496 * $script:Progress / 100)
            $percent.Text = "$([int]$script:Progress)%"
        
            if ($script:Progress -ge 10) { $status.Text = "SCANNING GLOBAL NETWORKS..." }
            if ($script:Progress -ge 30) { $status.Text = "TARGET ACQUIRED..." }
            if ($script:Progress -ge 50) { $status.Text = "DEPLOYING COUNTER-MEASURES..." }
            if ($script:Progress -ge 70) { $status.Text = "NEUTRALIZING THREATS..." }
            if ($script:Progress -ge 95) { $status.Text = "SYSTEM CLEANUP..." }
        
            if ($script:Progress -gt 80) { $percent.ForeColor = $script:Colors.NeonRed; $pBarFill.BackColor = $script:Colors.NeonRed }
        }
        else {
            $this.Stop()
            Start-SuccessSequence
        }
    })

function Start-SuccessSequence {
    $script:IsRunning = $false
    
    foreach ($tm in $script:Timers) { try { $tm.Stop() } catch {} } 
    foreach ($win in $script:SubWindows) { 
        try { if (-not $win.IsDisposed) { $win.Close() } } catch {}
    }
    
    Invoke-Voice "We got him."
    
    $bg.Controls.Clear()
    $main.WindowState = "Maximized"
    $main.BackColor = $script:Colors.BgDark
    $bg.Size = $main.Size
    $bg.Location = New-Object System.Drawing.Point(0, 0)
    
    $lbl = New-Object System.Windows.Forms.Label
    $lbl.Text = " MISSION ACCOMPLISHED "
    $lbl.ForeColor = $script:Colors.NeonGreen
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
        Invoke-Voice "Initiating graphical interface."
        Start-SubWindows
        $mainTimer.Start()
    })

Clear-Host
Write-Host " [!] AI NEUTRALIZER v5.3 - ORIGINAL CHAOS MODE..." -ForegroundColor Cyan
Start-Sleep -Seconds 1

[System.Windows.Forms.Application]::Run($main)

  


