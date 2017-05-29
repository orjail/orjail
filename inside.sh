
REALPATH=`realpath $0`
REALPATH=`dirname $REALPATH`

mount --bind $REALPATH/resolv.conf /etc/resolv.conf 
sudo -u les $*
