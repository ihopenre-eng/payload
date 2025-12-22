Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$yt = "https://www.youtube.com/watch?v=YOUR_VIDEO_ID"

function New-Popup($title, $lines, $x, $y) {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = $title
    $form.Size = New-Object System.Drawing.Size(420,260)
    $form.StartPosition = "Manual"
    $form.Location = New-Object System.Drawing.Point($x,$y)
    $form.BackColor = [System.Drawing.Color]::Black
    $form.ForeColor = [System.Drawing.Color]::Lime
    $form.TopMost = $true

    $box = New-Object System.Windows.Forms.TextBox
    $box.Multiline = $true
    $box.Dock = "Fill"
    $box.BackColor = "Black"
    $box.ForeColor = "Lime"
    $box.BorderStyle = "None"
    $box.Font = New-Object System.Drawing.Font("Consolas",10)
    $form.Controls.Add($box)

    $form.Show()

    foreach ($l in $lines) {
        $box.AppendText($l + "`r`n")
        Start-Sleep -Milliseconds (Get-Random 40 80)
    }
}

# 화면 기준 좌표
New-Popup "MODULE INIT" @(
    "[+] USB detected",
    "[+] Runtime loaded",
    "[+] Memory allocated",
    "[+] Environment stable"
) 50 50

Start-Sleep -Milliseconds 150

New-Popup "PIPELINE" @(
    "[*] Stage 1 online",
    "[*] Stage 2 online",
    "[*] Stage 3 online"
) 520 80

Start-Sleep -Milliseconds 150

New-Popup "STREAM" @(
    "[>] Buffer sync",
    "[>] Render thread active",
    "[>] Output locked"
) 200 360

Start-Sleep -Milliseconds 200

# 진행률 창
$form = New-Object System.Windows.Forms.Form
$form.Text = "PROGRESS"
$form.Size = New-Object System.Drawing.Size(500,160)
$form.StartPosition = "CenterScreen"
$form.BackColor = "Black"
$form.ForeColor = "Cyan"
$form.TopMost = $true

$label = New-Object System.Windows.Forms.Label
$label.Dock = "Fill"
$label.TextAlign = "MiddleCenter"
$label.Font = New-Object System.Drawing.Font("Consolas",18)
$form.Controls.Add($label)
$form.Show()

for ($i=0; $i -le 100; $i++) {
    $label.Text = "EXECUTING... $i%"
    Start-Sleep -Milliseconds 35
}

$form.Close()

# 최종 성공 창
$final = New-Object System.Windows.Forms.Form
$final.Text = "RESULT"
$final.Size = New-Object System.Drawing.Size(600,200)
$final.StartPosition = "CenterScreen"
$final.BackColor = "Black"
$final.ForeColor = "Lime"
$final.TopMost = $true

$done = New-Object System.Windows.Forms.Label
$done.Dock = "Fill"
$done.TextAlign = "MiddleCenter"
$done.Font = New-Object System.Drawing.Font("Consolas",28,[System.Drawing.FontStyle]::Bold)
$done.Text = "SUCCESSFUL"
$final.Controls.Add($done)

$final.Show()
Start-Sleep -Milliseconds 800

Start-Process $yt
