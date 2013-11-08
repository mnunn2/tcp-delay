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


