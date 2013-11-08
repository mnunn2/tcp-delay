#!/bin/bash

# tc class show dev {if}

# abort if fail and show what's running
set -ex

iface="$1"
delay="$2"
shift 2

tc qdisc del dev ${iface} root || true

tc qdisc add dev ${iface} root handle 1:0 htb
tc class add dev ${iface} classid 1:2 htb rate 1Gbit

tc qdisc add dev ${iface} parent 1:2 handle 2: netem delay ${delay}

for ip in $@ ; do
      tc filter add dev ${iface} parent 1:0 protocol ip prio 1 u32 match ip dst $ip/32 flowid 1:2
        tc filter add dev ${iface} parent 1:0 protocol ip prio 1 u32 match ip src $ip/32 flowid 1:2
        done

        _____________

        ip addr del 10.10.10.5 dev eth1
        ip addr del 10.10.10.5 dev eth2
        brctl addbr fred
        brctl addif fred eth1
        brctl addif fred eth2
        ip link set fred up
        brctl showmacs fred

# tc stuff
tc class show dev eth0 parent 10
tc qdisc del dev eth0 root
tc qdisc add dev eth0 root handle 1: netem delay 500ms

