#!/bin/bash

REALPATH=`realpath $0`
REALPATH=`dirname $REALPATH`
DEFAULTNAME=torjail
NAME=$DEFAULTNAME
USERNAME=`whoami`

# Functions
# ~~~~~~~~~

print_real() {
  if [ $2 = 'G' ]; then
    echo $1 -e "\e[32m$3\e[0m"
  elif [ $2 = 'Y' ]; then
    echo $1 -e "\e[33m$3\e[0m"
  elif [ $2 = 'N' ]; then
    echo $1 "$3"
  else
    echo $1 -e "\e[31m$3\e[0m"
  fi
}

print() {
  print_real '' "$1" "$2"
}

printn() {
  print_real "-n" "$1" "$2"
}

help_and_exit() {
  printn N "Usage: "
  printn Y "$0"
  print G " <options> [command <arguments>...]"
  print N "Options:"
  print N "    -h, --help         It shows this menu."
  print N "    -n, --name <name>  Set a custom namespace name. By default '$DEFAULTNAME'."
  print N "If command is not passed, the shell will be executed."
  exit 0
}

# Inside part
# ~~~~~~~~~~~

# This part is executed only inside the namespace.
if [ "$1" = "--inside" ]; then
  REALPATH=`realpath $0`
  REALPATH=`dirname $REALPATH`

  shift
  USERNAME="$1"
  shift

  print G " * Replacing resolv.conf..."
  mount --bind $REALPATH/resolv.conf /etc/resolv.conf

  print G " * Executing..."

  sudo -u $USERNAME $*
  exit
fi

# The tool
# ~~~~~~~~

# Arguments check
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    # Replacing the name
    -n|--name)
      NAME="$2"
      if [ "$NAME" = "" ]; then
        help_and_exit
      fi
      shift
    ;;

    # Help menu
    -h|--help)
      help_and_exit
    ;;

    # The rest
    *)
    break
    ;;
  esac
  shift
done

# Let's replace $1 with the current shell if no command has been passed.
if [ "$1" = "" ]; then
  set -- "$SHELL"
fi

# check if network namespace already exists
sudo ip netns list | grep -e ^$NAME\  &> /dev/null
if [ $? -ne 0 ]; then
  print G "It seems that you don't have the namespace $NAME."
  printn Y "Do you want to create it? [y/n] "
  read CREATE

  if [ "$CREATE" != y ] && [ "$CREATE" != Y ]; then
    print G "Ok. Bye!"
    exit 0
  fi

  print G " * Creating a $NAME namespace..."
  # add network namespace
  sudo ip netns add $NAME

  # Create veth link.
  print G " * Creating a veth link..."
  sudo ip link add in-$NAME type veth peer name out-$NAME

  # Add out to NS.
  print G " * Sharing the veth interface..."
  sudo ip link set out-$NAME netns $NAME

  ## setup ip address of host interface
  print G " * Setting up IP address of host interface..."
  sudo ip addr add 10.200.1.1/24 dev in-$NAME
  sudo ip link set in-$NAME up

  # setup ip address of peer
  print G " * Setting up IP address of peer interface..."
  sudo ip netns exec $NAME ip addr add 10.200.1.2/24 dev out-$NAME
  sudo ip netns exec $NAME ip link set out-$NAME up

  # default route
  print G " * Default routing up..."
  sudo ip netns exec $NAME ip route add default via 10.200.1.1

  # resolve with tor
  print G " * Resolving via TOR..."
  sudo iptables -t nat -A  PREROUTING -i in-$NAME -p udp --dport 53 -j REDIRECT --to-ports 5353

  # traffic througth tor
  print G " * Traffic via TOR..."
  sudo iptables -t nat -A PREROUTING -i in-$NAME -p tcp --syn  -j REDIRECT --to-ports 9040
  sudo iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

  print G "All done!"
else
  print Y "$NAME network namespace already exists!"
fi

# run your shit
sudo ip netns exec $NAME unshare --ipc --fork --pid --mount --mount-proc $0 --inside $USERNAME $*
