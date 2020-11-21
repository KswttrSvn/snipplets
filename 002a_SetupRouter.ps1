$VM="router.tanzu.local"


Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
Connect-VIServer -Server vcsa.tanzu.local -User administrator@vsphere.local -Password VMware1!
Connect-CisServer -Server vcsa.tanzu.local -User administrator@vsphere.local -Password VMware1!

if (!(Test-Path -path ./VMKeystrokes.ps1)) {
  Invoke-WebRequest -Uri https://raw.githubusercontent.com/lamw/vghetto-scripts/master/powershell/VMKeystrokes.ps1  -OutFile VMKeystrokes.ps1
  }

Import-Module ./VMKeystrokes.ps1

#initial password change
Set-VMKeystrokes -VMName $VM -StringInput "root" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "changeme" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "changeme" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "VMware1!" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "VMware1!" -ReturnCarriage $true

#create the shell-script for configuring the VM
Set-VMKeystrokes -VMName $VM -StringInput "vi setupRouter.sh" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "i"
Set-VMKeystrokes -VMName $VM -StringInput "#!/bin/bash" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM  -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "PHOTON_ROUTER_IP=192.168.222.2" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "PHOTON_ROUTER_GW=192.168.252.111" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "PHOTON_ROUTER_DNS=192.168.222.2" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "SETUP_DNS_SERVER=1" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM  -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "tdnf -y update" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "if [ $"
Set-VMKeystrokes -VMName $VM -StringInput "{SETUP_DNS_SERVER} -eq 1 ]; then" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "    tdnf install -y unbound" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM  -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "    cat > /etc/unbound/unbound.conf << EOF" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "    server:" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "        interface: 0.0.0.0" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "        port: 53" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "        do-ip4: yes" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "        do-udp: yes" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "        access-control: 192.168.127.0/16 allow" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "        access-control: 10.10.0.0/24 allow" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "        access-control: 10.20.0.0/24 allow" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM  -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "        verbosity: 1" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM  -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "    local-zone: `"tanzu.local.`" static" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM  -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "    local-data: `"router.tanzu.local A 192.168.222.2`"" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "    local-data-ptr: `"192.168.222.2 router.tanzu.local`"" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM  -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "    local-data: `"vcsa.tanzu.local A 192.168.222.5`"" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "    local-data-ptr: `"192.168.222.5 vcsa.tanzu.local`"" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM  -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "    local-data: `"haproxy.tanzu.local A 192.168.222.6`"" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "    local-data-ptr: `"192.168.222.6 haproxy.tanzu.local`"" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM  -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "    local-data: `"esxi-01.tanzu.local A 192.168.130.18`"" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "    local-data-ptr: `"192.168.130.18 esxi-01.tanzu.local`"" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM  -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "    forward-zone:" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "        name: `".`"" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "        forward-addr: ${PHOTON_ROUTER_DNS}" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "EOF" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "    systemctl enable unbound" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "    systemctl start unbound" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "fi" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM  -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "sed -i 's/net.ipv4.ip_forward.*/net.ipv4.ip_forward=1/g' /etc/sysctl.d/50-security-hardening.conf" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM  -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "rm -f /etc/systemd/network/99-dhcp-en.network" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM  -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "cat > /etc/systemd/network/10-static-eth0.network << EOF" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "[Match]" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "Name=eth0" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM  -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "[Network]" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "Address=${PHOTON_ROUTER_IP}/17" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "Gateway=${PHOTON_ROUTER_GW}" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "DNS=${PHOTON_ROUTER_DNS}" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "IPv6AcceptRA=no" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "EOF" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM  -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "cat > /etc/systemd/network/11-static-eth1.network << EOF" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "[Match]" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "Name=eth1" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM  -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "[Network]" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "Address=10.10.0.1/24" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "EOF" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM  -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "cat > /etc/systemd/network/12-static-eth2.network << EOF" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "[Match]" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "Name=eth2" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM  -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "[Network]" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "Address=10.20.0.1/24" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "EOF" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM  -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "chmod 655 /etc/systemd/network/*" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "systemctl restart systemd-networkd" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM  -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "iptables -P INPUT ACCEPT" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "iptables -P FORWARD ACCEPT" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "iptables -P OUTPUT ACCEPT" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "iptables -t nat -F" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "iptables -t mangle -F" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "iptables -F" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "iptables -X" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "iptables -A FORWARD -i eth0 -o eth1 -m state --state RELATED,ESTABLISHED -j ACCEPT" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "iptables -A FORWARD -i eth0 -o eth2 -m state --state RELATED,ESTABLISHED -j ACCEPT" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "iptables -A FORWARD -i eth2 -o eth0 -j ACCEPT" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "if [ $"
Set-VMKeystrokes -VMName $VM -StringInput "{SETUP_DNS_SERVER} -eq 1 ]; then" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "    iptables -A INPUT -i eth0 -p udp --dport 53 -j ACCEPT" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "    iptables -A INPUT -i eth1 -p udp --dport 53 -j ACCEPT" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "    iptables -A INPUT -i eth2 -p udp --dport 53 -j ACCEPT" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "fi" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "iptables-save > /etc/systemd/scripts/ip4save" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM  -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -StringInput "systemctl restart iptables" -ReturnCarriage $true
Set-VMKeystrokes -VMName $VM -SpecialKeyInput "KeyESC"
Set-VMKeystrokes -VMName $VM -StringInput ":wq" -ReturnCarriage $true

#Execute the script
#Set-VMKeystrokes -VMName $VM -StringInput "bash ./setupRouter.sh" -ReturnCarriage $true

#LogOff the VM
Set-VMKeystrokes -VMName $VM -StringInput "logout" -ReturnCarriage $true
