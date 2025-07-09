#utilities
cd /tmp
apt install python3-pip nano wget unzip curl jq whois git pipx -y
wget https://go.dev/dl/go1.24.4.linux-amd64.tar.gz && rm -rf /usr/local/go && tar -C /usr/local -xzf go1.24.4.linux-amd64.tar.gz && rm https://go.dev/dl/go1.24.4.linux-amd64.tar.gz*
export PATH=$PATH:/usr/local/go/bin:/root/go/bin
ln -s /usr/bin/python3 /usr/bin/python
mkdir /root/tools
mkdir /root/tools/bin
mkdir /root/tools/sources



########################## GOLANG BASED ######################################
#nuclei
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest

#httpx
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest

#katana
go install -v github.com/projectdiscovery/katana/cmd/katana@latest

#shuffledns
go install -v github.com/projectdiscovery/shuffledns/cmd/shuffledns@latest

#asnmap
go install -v github.com/projectdiscovery/asnmap/cmd/asnmap@latest

#mapcidr
go install -v github.com/projectdiscovery/mapcidr/cmd/mapcidr@latest

#cdncheck
go install -v github.com/projectdiscovery/cdncheck/cmd/cdncheck@latest

#tldfinder
go install -v github.com/projectdiscovery/tldfinder/cmd/tldfinder@latest

#notify
go install -v github.com/projectdiscovery/notify/cmd/notify@latest

#assetfinder
go install github.com/tomnomnom/assetfinder@latest

#waybackurls
go install github.com/tomnomnom/waybackurls@latest

#qsreplace
go install github.com/tomnomnom/qsreplace@latest

#anew
go install -v github.com/tomnomnom/anew@latest

#httprobe
go install github.com/tomnomnom/httprobe@latest

#gf
go install github.com/tomnomnom/gf@latest

#gospider
go install github.com/jaeles-project/gospider@latest

#dalfox
go install github.com/hahwul/dalfox/v2@latest

#hakrawler
go install github.com/hakluke/hakrawler@latest

#amass
go install github.com/owasp-amass/amass/v4/...@master

#ffuf
go install github.com/ffuf/ffuf/v2@latest

#gobuster
go install github.com/OJ/gobuster/v3@latest



ln -s /root/go/bin/* /usr/local/bin/
########################## pip/pipx Based ######################################

#uro
pipx install uro

#bbot
pipx install bbot

#arjun
pipx install arjun

#waymore
pip install waymore --break-system-packages

#git-dumper
pip install git-dumper --break-system-packages


ln -s /root/.local/bin/* /usr/local/bin/
########################## source Based ######################################
cd /root/tools/sources

#seclist
git clone https://github.com/danielmiessler/SecLists
ln -s /root/tools/sources/SecLists /opt/seclists

#sqlmap
git clone https://github.com/sqlmapproject/sqlmap
cd /root/tools/sources/sqlmap
chmod +x sqlmap.py
cd ../
ln -s /root/tools/sources/sqlmap/sqlmap.py /usr/local/bin/sqlmap

########################## Binary Based ######################################
cd /root/tools/bin

#feroxbuster
wget https://github.com/epi052/feroxbuster/releases/latest/download/x86_64-linux-feroxbuster.zip && unzip -o x86_64-linux-feroxbuster.zip && chmod +x feroxbuster && rm x86_64-linux-feroxbuster.zip*


#Findomain
wget https://github.com/Findomain/Findomain/releases/latest/download/findomain-linux.zip && unzip -o findomain-linux.zip && chmod +x findomain && rm findomain-linux.zip*


ln -s /root/tools/bin/* /usr/local/bin/
###### Create link to /usr/local/bin #######
