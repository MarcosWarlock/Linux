#!/bin/bash
#Firewall para uso doméstico
#Debian: /etc/init.d/rc.firewall.sh
#Slackware: /etc/rc.d/rc.firewall.sh

/sbin/modprobe ip_tables
/sbin/modprobe ip_conntrack
/sbin/modprobe iptable_filter
/sbin/modprobe ipt_LOG
/sbin/modprobe ipt_limit
/sbin/modprobe ipt_state
/sbin/modprobe ipt_owner
/sbin/modprobe ipt_REJECT
/sbin/modprobe ip_conntrack_ftp
  
# Firewall Start
firewall_start() {
    # Limpa
    iptables -X
    iptables -Z
    iptables -F
    iptables -t nat -F
  
    # Politica default
    iptables -P INPUT DROP
    iptables -P FORWARD DROP
    iptables -P OUTPUT ACCEPT
  
    # access loopback 
    iptables -A INPUT -i lo -j ACCEPT
  
    # Conexão estabelecida
    iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
  
   # Security
    echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all
    echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts
    echo 1 > /proc/sys/net/ipv4/tcp_syncookies
    iptables -A FORWARD -p icmp --icmp-type echo-request -m limit --limit 1/s -j ACCEPT
    iptables -A FORWARD -p tcp -m limit --limit 1\s -j ACCEPT
    iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
    iptables -A FORWARD -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s -j ACCEPT
    iptables -A FORWARD --protocol tcp --tcp-flags ALL SYN,ACK -j DROP
  
    echo "Firewall Start."
}
  
# Firewall Stop
firewall_stop() {
    # Limpa as regras
    iptables -X
    iptables -Z
    iptables -F
    iptables -t nat -F
  
    # Politica default
    iptables -P INPUT ACCEPT
    iptables -P FORWARD ACCEPT
    iptables -P OUTPUT ACCEPT
  
    # acesso loopback
    iptables -A INPUT -i lo -j ACCEPT
  
    # Conexão estabelecida
    iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
  
    echo "Firewall Stop (sem segurança)."
}
  
# Firewall Restart
firewall_restart() {
    firewall_stop
    sleep 3
    firewall_start
}
  
# opções
case "$1" in
'start')
    firewall_start
    ;;
'stop')
    firewall_stop
    ;;
'restart')
    firewall_restart
    ;;
*)
    echo "rc.firewall start"
    echo "rc.firewall stop"
    echo "rc.firewall restart"
esac
