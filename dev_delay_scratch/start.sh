#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

vpp -c 1_vpp.conf &
vpp -c 2_vpp.conf &
vpp -c 3_vpp.conf &


echo '#!/bin/bash' > vpp_aliases.sh
cat << EOF > vpp_aliases.sh
#!/bin/bash
alias vpp1="echo '1vpp-cli.sock' && sudo vppctl -s /run/vpp/1vpp-cli.sock"
alias vpp2="echo '2vpp-cli.sock' && sudo vppctl -s /run/vpp/2vpp-cli.sock"
alias vpp3="echo '3vpp-cli.sock' && sudo vppctl -s /run/vpp/3vpp-cli.sock"
EOF

source ./vpp_aliases.sh
