# ----------------------------------------------------------------------------------
# Script for checking the temperature reported by the ambient temperature sensor,
# and if deemed too high send the raw IPMI command to enable dynamic fan control.
#
# https://www.spxlabs.com/blog/2019/3/16/silence-your-dell-poweredge-server
#
# Requires:
# ipmitool – apt-get install ipmitool
# ----------------------------------------------------------------------------------

# IPMI SETTINGS:
# Modify to suit your needs.
# DEFAULT IP: 192.168.0.120
IPMIHOST=172.16.0.125
IPMIUSER=root
IPMIPW=calvin
IPMIEK=0000000000000000000000000000000000000000

# TEMPERATURE
# Change this to the temperature in celcius you are comfortable with.
# If the temperature goes above the set degrees it will send raw IPMI command to enable dynamic fan control
MAXTEMP=65

# This variable sends a IPMI command to get the temperature, and outputs it as two digits.
# Do not edit unless you know what you do.
TEMP=$(ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW -y $IPMIEK sdr type temperature | grep -o -E -i 'Temp .+ (\d{2} degrees)' | tail -1 | grep -o -E -i '(\d{2})')

if [[ $TEMP > $MAXTEMP ]];
    then
        echo "Warning: Temperature is too high! Activating dynamic fan control! ($TEMP C)"
        ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW -y $IPMIEK raw 0x30 0x30 0x01 0x01
    else
        echo "Temperature is OK ($TEMP C)"
        echo "Activating manual fan speeds! (30% Fan Speed)"
        ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW -y $IPMIEK raw 0x30 0x30 0x01 0x00
        ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW -y $IPMIEK raw 0x30 0x30 0x02 0xff 0x1e
fi
