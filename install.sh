#!/bin/bash

TOOLS_DIR="/root/tools"
BIN_DIR="$TOOLS_DIR/bin"
SRC_DIR="$TOOLS_DIR/sources"

# 1. Utilities
install_utilities() {
    echo "[+] Installing essential utilities..."
    apt update
    apt install python3-pip nano wget unzip curl jq whois git pipx -y
    wget https://go.dev/dl/go1.24.4.linux-amd64.tar.gz
    rm -rf /usr/local/go
    tar -C /usr/local -xzf go1.24.4.linux-amd64.tar.gz
    rm -f go1.24.4.linux-amd64.tar.gz
    export PATH=$PATH:/usr/local/go/bin:/root/go/bin
    ln -sf /usr/bin/python3 /usr/bin/python
    mkdir -p "$BIN_DIR" "$SRC_DIR"
}

# 2. Symlinks
link_binaries() {
    ln -sf /root/go/bin/* /usr/local/bin/ 2>/dev/null
    ln -sf /root/.local/bin/* /usr/local/bin/ 2>/dev/null
    ln -sf "$BIN_DIR"/* /usr/local/bin/ 2>/dev/null
}

# 3. Tool definitions and descriptions
declare -A TOOLS
declare -A DESCRIPTIONS

# Format: [tool_id]="install command"
# Format: [tool_id]="description"

# --- GO Tools ---
TOOLS[nuclei]="go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest"
DESCRIPTIONS[nuclei]="Vulnerability scanner using templates"

TOOLS[httpx]="go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest"
DESCRIPTIONS[httpx]="Fast web server probing tool"

TOOLS[katana]="go install -v github.com/projectdiscovery/katana/cmd/katana@latest"
DESCRIPTIONS[katana]="High-performance crawling tool"

TOOLS[ffuf]="go install github.com/ffuf/ffuf/v2@latest"
DESCRIPTIONS[ffuf]="Web fuzzer for directories, parameters, etc"

TOOLS[dalfox]="go install github.com/hahwul/dalfox/v2@latest"
DESCRIPTIONS[dalfox]="XSS scanning and payload testing"

TOOLS[amass]="go install github.com/owasp-amass/amass/v4/...@master"
DESCRIPTIONS[amass]="Advanced subdomain enumeration tool"

TOOLS[assetfinder]="go install github.com/tomnomnom/assetfinder@latest"
DESCRIPTIONS[assetfinder]="Subdomain discovery using public sources"

TOOLS[waybackurls]="go install github.com/tomnomnom/waybackurls@latest"
DESCRIPTIONS[waybackurls]="Fetch URLs from the Wayback Machine"

TOOLS[qsreplace]="go install github.com/tomnomnom/qsreplace@latest"
DESCRIPTIONS[qsreplace]="Query string value replacer"

TOOLS[anew]="go install github.com/tomnomnom/anew@latest"
DESCRIPTIONS[anew]="Append new unique lines to a file"

TOOLS[httprobe]="go install github.com/tomnomnom/httprobe@latest"
DESCRIPTIONS[httprobe]="Check for active HTTP/S services"

TOOLS[gf]="go install github.com/tomnomnom/gf@latest"
DESCRIPTIONS[gf]="Pattern matching for common vuln parameters"

TOOLS[gospider]="go install github.com/jaeles-project/gospider@latest"
DESCRIPTIONS[gospider]="Fast web spider for recon"

TOOLS[hakrawler]="go install github.com/hakluke/hakrawler@latest"
DESCRIPTIONS[hakrawler]="Web crawler optimized for security testing"

TOOLS[shuffledns]="go install -v github.com/projectdiscovery/shuffledns/cmd/shuffledns@latest"
DESCRIPTIONS[shuffledns]="Massive subdomain brute-forcer"

TOOLS[asnmap]="go install -v github.com/projectdiscovery/asnmap/cmd/asnmap@latest"
DESCRIPTIONS[asnmap]="ASN and IP range discovery tool"

TOOLS[mapcidr]="go install -v github.com/projectdiscovery/mapcidr/cmd/mapcidr@latest"
DESCRIPTIONS[mapcidr]="CIDR block mapper and subnetting helper"

TOOLS[cdncheck]="go install -v github.com/projectdiscovery/cdncheck/cmd/cdncheck@latest"
DESCRIPTIONS[cdncheck]="Detect if IPs are behind CDNs"

TOOLS[tldfinder]="go install -v github.com/projectdiscovery/tldfinder/cmd/tldfinder@latest"
DESCRIPTIONS[tldfinder]="TLD enumeration and discovery"

TOOLS[notify]="go install -v github.com/projectdiscovery/notify/cmd/notify@latest"
DESCRIPTIONS[notify]="Notification tool for pipeline outputs"

# --- Python/Pipx Tools ---
TOOLS[uro]="pipx install uro"
DESCRIPTIONS[uro]="URL deduplicator and cleaner"

TOOLS[bbot]="pipx install bbot"
DESCRIPTIONS[bbot]="Modular OSINT and recon framework"

TOOLS[arjun]="pipx install arjun"
DESCRIPTIONS[arjun]="GET/POST parameter discovery tool"

TOOLS[waymore]="pip install waymore --break-system-packages"
DESCRIPTIONS[waymore]="Wayback Machine URL scraper + recon"

TOOLS[git-dumper]="pip install git-dumper --break-system-packages"
DESCRIPTIONS[git-dumper]="Dump exposed .git repositories"

# --- Source-based Tools ---
TOOLS[sqlmap]="
    cd $SRC_DIR && git clone https://github.com/sqlmapproject/sqlmap || true
    chmod +x $SRC_DIR/sqlmap/sqlmap.py
    ln -sf $SRC_DIR/sqlmap/sqlmap.py /usr/local/bin/sqlmap
"
DESCRIPTIONS[sqlmap]="Powerful SQL injection detection tool"

TOOLS[seclists]="
    cd $SRC_DIR && git clone https://github.com/danielmiessler/SecLists || true
    ln -sf $SRC_DIR/SecLists /opt/seclists
"
DESCRIPTIONS[seclists]="Huge collection of wordlists for pentesting"

# --- Binary Tools ---
TOOLS[feroxbuster]="
    cd $BIN_DIR
    wget https://github.com/epi052/feroxbuster/releases/latest/download/x86_64-linux-feroxbuster.zip -O ferox.zip
    unzip -o ferox.zip && chmod +x feroxbuster
    rm -f ferox.zip*
"
DESCRIPTIONS[feroxbuster]="Recursive content discovery tool"

TOOLS[findomain]="
    cd $BIN_DIR
    wget https://github.com/Findomain/Findomain/releases/latest/download/findomain-linux.zip -O findo.zip
    unzip -o findo.zip && chmod +x findomain
    rm -f findo.zip*
"
DESCRIPTIONS[findomain]="Fast subdomain enumerator"

# 4. Tool installer - select individual
install_selected_tools() {
    echo "[*] Select tools to install (space-separated, e.g. 1 4 5):"
    local i=1
    declare -a keys
    for key in "${!TOOLS[@]}"; do
        printf " [%2d] %-15s - %s\n" "$i" "$key" "${DESCRIPTIONS[$key]}"
        keys[$i]=$key
        ((i++))
    done

    read -p "Enter numbers: " -a choices

    for choice in "${choices[@]}"; do
        tool=${keys[$choice]}
        if [[ -n "$tool" ]]; then
            echo "[+] Installing $tool..."
            eval "${TOOLS[$tool]}"
        else
            echo "[-] Invalid choice: $choice"
        fi
    done

    link_binaries
    cleanup_archives
}

# 5. Install all tools
install_all() {
    echo "[+] Installing ALL tools..."
    for key in "${!TOOLS[@]}"; do
        echo "[*] Installing $key..."
        eval "${TOOLS[$key]}"
    done
    link_binaries
    cleanup_archives
}

# 6. Clean up archives
cleanup_archives() {
    echo "[*] Cleaning up archive files..."
    find "$BIN_DIR" "$SRC_DIR" /tmp -type f \( -name "*.zip" -o -name "*.tar.gz" -o -name "*.tgz" \) -delete
    echo "[✓] Cleanup complete!"
}

# 7. Main menu
show_main_menu() {
    PS3="Choose an option: "
    options=("Install Base Utilities" "Select Tools Individually" "Install All Tools" "Exit")
    select opt in "${options[@]}"; do
        case $REPLY in
            1) install_utilities ;;
            2) install_selected_tools ;;
            3) install_all ;;
            4) break ;;
            *) echo "Invalid option." ;;
        esac
    done
}

# Run menu
show_main_menu
