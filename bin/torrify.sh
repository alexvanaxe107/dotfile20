#! /bin/dash

show_help() {
    echo "Torrify the internet"; echo ""
    echo "-s                                    Activate the secrecy"
    echo "-n                                    Go to the normal state of affairs"
}

HOME=/home/alexvanaxe

secrecy() {
    echo "Assuming tor service is already started"
    iptables-restore $HOME/tor/torrify
    ip6tables-restore $HOME/tor/torrify

    echo "nameserver 127.0.0.1" > /etc/resolv.conf
}

normal() {
    iptables-restore $HOME/tor/clean_rules
    ip6tables-restore $HOME/tor/clean_rules

    resolvconf -u
}

while getopts "h?sn" opt; do
    case "$opt" in
    h|\?) show_help
        ;;
    s) secrecy
        ;;
    n) normal
        ;;
    esac
done

