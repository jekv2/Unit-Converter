# Import Windows Forms components
Add-Type -AssemblyName "System.Windows.Forms"
Add-Type -AssemblyName "System.Drawing"

# Create Form
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Unit Converter'
$form.Size = New-Object System.Drawing.Size(650, 350)

# Value Input
$valueLabel = New-Object System.Windows.Forms.Label
$valueLabel.Text = 'Enter value:'
$valueLabel.Location = New-Object System.Drawing.Point(20, 20)
$valueLabel.Size = New-Object System.Drawing.Size(120, 20)
$form.Controls.Add($valueLabel)

$valueInput = New-Object System.Windows.Forms.TextBox
$valueInput.Location = New-Object System.Drawing.Point(150, 45)
$valueInput.Size = New-Object System.Drawing.Size(200, 20)
$form.Controls.Add($valueInput)

# From Unit
$fromUnitLabel = New-Object System.Windows.Forms.Label
$fromUnitLabel.Text = 'From unit (bps, Kbps, Mbps, Gbps, Tbps, KB, MB, GB, TB):'
$fromUnitLabel.Location = New-Object System.Drawing.Point(20, 80)
$fromUnitLabel.Size = New-Object System.Drawing.Size(350, 20)
$form.Controls.Add($fromUnitLabel)

$fromUnitInput = New-Object System.Windows.Forms.TextBox
$fromUnitInput.Location = New-Object System.Drawing.Point(180, 105)
$fromUnitInput.Size = New-Object System.Drawing.Size(200, 20)
$form.Controls.Add($fromUnitInput)

# To Unit
$toUnitLabel = New-Object System.Windows.Forms.Label
$toUnitLabel.Text = 'To unit (bps, Kbps, Mbps, Gbps, Tbps, KB, MB, GB, TB):'
$toUnitLabel.Location = New-Object System.Drawing.Point(20, 140)
$toUnitLabel.Size = New-Object System.Drawing.Size(350, 20)
$form.Controls.Add($toUnitLabel)

$toUnitInput = New-Object System.Windows.Forms.TextBox
$toUnitInput.Location = New-Object System.Drawing.Point(180, 165)
$toUnitInput.Size = New-Object System.Drawing.Size(200, 20)
$form.Controls.Add($toUnitInput)

# Result Label
$resultLabel = New-Object System.Windows.Forms.Label
$resultLabel.Text = 'Result:'
$resultLabel.Location = New-Object System.Drawing.Point(20, 200)
$resultLabel.Size = New-Object System.Drawing.Size(400, 20)
$form.Controls.Add($resultLabel)

# Convert Button
$convertButton = New-Object System.Windows.Forms.Button
$convertButton.Text = 'Convert'
$convertButton.Location = New-Object System.Drawing.Point(180, 230)
$convertButton.Size = New-Object System.Drawing.Size(100, 30)
$form.Controls.Add($convertButton)

# Conversion logic
$convertButton.Add_Click({
    try { $value = [float]$valueInput.Text } catch { $resultLabel.Text="Enter a numeric value."; return }

    $fromUnit = $fromUnitInput.Text.Trim().ToUpper()
    $toUnit   = $toUnitInput.Text.Trim().ToUpper()

    # Speed units in bps
    $speedUnits = @{ 'BPS'=1; 'KBPS'=1e3; 'MBPS'=1e6; 'GBPS'=1e9; 'TBPS'=1e12 }

    # Data units in decimal (1 KB = 1000 bytes)
    $dataUnits = @{ 'KB'=1e3; 'MB'=1e6; 'GB'=1e9; 'TB'=1e12 }

    $result = $null

    # Speed → Speed
    if ($speedUnits.ContainsKey($fromUnit) -and $speedUnits.ContainsKey($toUnit)) {
        $bps = $value * $speedUnits[$fromUnit]
        $result = $bps / $speedUnits[$toUnit]
    }
    # Data → Data
    elseif ($dataUnits.ContainsKey($fromUnit) -and $dataUnits.ContainsKey($toUnit)) {
        $bytes = $value * $dataUnits[$fromUnit]
        $result = $bytes / $dataUnits[$toUnit]
    }
    # Speed → Data
    elseif ($speedUnits.ContainsKey($fromUnit) -and $dataUnits.ContainsKey($toUnit)) {
        $bps = $value * $speedUnits[$fromUnit]
        $bytesPerSec = $bps / 8
        $result = $bytesPerSec / $dataUnits[$toUnit]
    }
    # Data → Speed
    elseif ($dataUnits.ContainsKey($fromUnit) -and $speedUnits.ContainsKey($toUnit)) {
        $bytes = $value * $dataUnits[$fromUnit]
        $bps = $bytes * 8
        $result = $bps / $speedUnits[$toUnit]
    }
    else {
        $resultLabel.Text = "Invalid conversion or unsupported units."
        return
    }

    $resultLabel.Text = "Result: $value $fromUnit = {0:N3} $toUnit" -f $result
})

# Show the form
$form.ShowDialog()