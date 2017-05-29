#!/bin/bash

REALPATH=`realpath $0`
REALPATH=`dirname $REALPATH`
NAME=torjail

# check if network namespace already exists
sudo ip netns list | grep -e ^$NAME\  &> /dev/null
if [ $? -eq 0 ]; then
  echo "$NAME network namespace already exists"
else
  # add network namespace
  sudo ip netns add $NAME

  # Create veth link.
  sudo ip link add in-$NAME type veth peer name out-$NAME

  # Add out to NS.
  sudo ip link set out-$NAME netns $NAME

  ## setup ip address of host interface
  sudo ip addr add 10.200.1.1/24 dev in-$NAME
  sudo ip link set in-$NAME up

  # setup ip address of peer
  sudo ip netns exec $NAME ip addr add 10.200.1.2/24 dev out-$NAME
  sudo ip netns exec $NAME ip link set out-$NAME up

  # default route
  sudo ip netns exec $NAME ip route add default via 10.200.1.1

  # resolve with tor
  sudo iptables -t nat -A  PREROUTING -i in-$NAME -p udp --dport 53 -j REDIRECT --to-ports 5353

  # traffic througth tor
  sudo iptables -t nat -A PREROUTING -i in-$NAME -p tcp --syn  -j REDIRECT --to-ports 9040    
  sudo iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

fi

# run your shit
sudo ip netns exec $NAME unshare --ipc --fork --pid --mount --mount-proc $REALPATH/inside.sh $*
