#!/usr/bin/env bash
set -euo pipefail

# Week 3 - Server Status Report

OUTPUT_DIR="/var/www/html/viikko3"

# Function to check disk space status
disk_status() {
    local usage="$1"

    if (( usage >= 80 )); then
        echo "WARNING"
    else
        echo "OK"
    fi
}

# Test mode for disk usage percentages
if [[ "${1:-}" == "--test-status" ]]; then
    disk_status "${2:?Please provide a percentage}"
    exit 0
fi

# Collect server information
GENERATED_AT=$(date '+%Y-%m-%d %H:%M:%S %Z %z')
UPTIME_TEXT=$(uptime -p)

DISK_PERCENT=$(df -P / | awk 'NR==2 {gsub(/%/, "", $5); print $5}')
DISK_USAGE="${DISK_PERCENT}%"
DISK_STATUS=$(disk_status "$DISK_PERCENT")

MEM_TOTAL=$(free -m | awk '/^Mem:/ {print $2}')
MEM_AVAILABLE=$(free -m | awk '/^Mem:/ {print $7}')

# Create the HTML report
TEMP_FILE=$(mktemp "$OUTPUT_DIR/.index.XXXXXX")
trap 'rm -f "$TEMP_FILE"' EXIT

cat > "$TEMP_FILE" <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Week 3 - Server Status</title>

    
<style>
* {
    box-sizing: border-box;
}

body {
    margin: 0;
    background: #000000;
    color: #f2f2f2;
    font-family: Arial, sans-serif;
    line-height: 1.6;
}



.sidebar {
    width: 260px;
    height: 100vh;
    position: fixed;
    top: 0;
    left: 0;
    background: #404040;
    color: white;
    padding: 30px 20px;
}

.sidebar h2 {
    color: #ffffff;
    font-size: 28px;
}

.sidebar p {
    color: #cccccc;
}

.sidebar a {
    display: block;
    color: #eeeeee;
    padding: 12px 15px;
    margin-top: 10px;
    text-decoration: none;
    border-radius: 6px;
}

.sidebar a:hover {
    background: #606060;
}

.sidebar a.active {
    background: #666666;
    border-left: 3px solid #ffffff;
}



main {
    margin-left: 260px;
    max-width: 1100px;
    padding: 45px 65px;
}

h1 {
    font-size: 36px;
    color: #ffffff;
}

h2 {
    color: #eeeeee;
}

/* Light grey disk status panel */

.status-banner {
    background: #d6d6d6;
    color: #202020;
    border: 1px solid #888888;
    border-radius: 14px;
    padding: 30px;
    margin: 25px 0 40px;
}

.status-banner h2 {
    color: #202020;
    font-size: 42px;
    margin: 0;
}

.status-banner p {
    color: #444444;
    margin: 5px 0 0;
}



section {
    margin: 35px 0;
    padding: 10px 0;
    background: transparent;
}



table {
    width: 100%;
    border-collapse: collapse;
    background: #181818;
    color: #eeeeee;
}

th, td {
    border: 1px solid #444444;
    padding: 13px;
    text-align: left;
}

th {
    background: #383838;
    color: white;
}

td {
    background: #181818;
}



code {
    background: #353535;
    color: #ffffff;
    padding: 3px 6px;
    border-radius: 4px;
}

main a {
    color: #b5caff;
}

/* Mobile layout */

@media (max-width: 700px) {
    .sidebar {
        position: static;
        width: 100%;
        height: auto;
    }

    .sidebar a {
        display: inline-block;
    }

    main {
        margin-left: 0;
        padding: 20px;
    }

    .status-banner h2 {
        font-size: 30px;
    }
}
</style>
</head>

<section>
    <h2>Testing and Documentation</h2>

    <h3>How the script works</h3>
    <p>
        My Bash script collects server information
        using Linux commands. It uses variables,
        command substitution, piping, an if statement
        and a function to check disk usage.
    </p>

    <h3>Automatic Updates</h3>
    <p>
        A systemd timer runs my Bash script every
        minute and generates a new HTML report.
        The timer starts automatically after reboot.
    </p>

    <h3>Disk Status Tests</h3>
    <ul>
        <li>50% disk usage: OK - Passed</li>
        <li>80% disk usage: WARNING - Passed</li>
        <li>90% disk usage: WARNING - Passed</li>
    </ul>

    <h3>Reboot Test</h3>
    <p>
        I rebooted my Ubuntu server and successfully
        connected to it again using SSH. Nginx,
        MariaDB, the Python application and the
        Week 3 timer were active after reboot.
    </p>

    <h3>Problem Solved</h3>
    <p>
        My systemd service initially failed with
        an Exec format error. I fixed the Bash
        interpreter line and checked the script.
        After that, the service ran successfully.
    </p>

    <h3>GitHub Repository</h3>
    <p>
        <a href="https://github.com/Veetij17/viikko2_linux"
           target="_blank" rel="noopener noreferrer">
            View my project on GitHub
        </a>
    </p>
</section>

<body>

<h1>My Linux Server Status</h1><p>Welcome to my Week 3 Bash scripting project!</p>

<section>
<h2>Current Server Status</h2>

<table>
<tr><th>Information</th><th>Value</th></tr>
<tr><td>Report generated</td><td>$GENERATED_AT</td></tr>
<tr><td>Server uptime</td><td>$UPTIME_TEXT</td></tr>
<tr><td>Root disk usage</td><td>$DISK_USAGE</td></tr>
<tr><td>Disk space status</td><td>$DISK_STATUS</td></tr>
<tr><td>Total RAM</td><td>$MEM_TOTAL MiB</td></tr>
<tr><td>Available RAM</td><td>$MEM_AVAILABLE MiB</td></tr>
</table>
</section>

<section>
<h2>How Does It Work?</h2>

<p>This report is generated using a Bash script.</p>

<p>The script uses Linux commands to collect server
information and stores the results in variables.</p>

<p>A function checks the disk usage with an if statement.</p>

<p>Below 80% the status is OK.
At 80% or higher the status is WARNING.</p>
</section>

<section>
<h2>Linux Commands Used</h2>

<p><b>date:</b> Shows the current date, time and time zone.</p>

<p><b>uptime -p:</b> Shows how long the server has been running.</p>

<p><b>df -P / | awk:</b> Uses a pipe to extract the disk usage
percentage from the root filesystem.</p>

<p><b>free -m:</b> Displays RAM information in MiB.</p>
</section>

</body>
</html>
EOF

chmod 644 "$TEMP_FILE"
mv "$TEMP_FILE" "$OUTPUT_DIR/index.html"
trap - EXIT

echo "HTML report generated successfully!"
