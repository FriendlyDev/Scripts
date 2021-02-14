#!/usr/bin/env bash

# ----------------------------------------------------------------------------------
# Script for setting manual fan speed to 2160 RPM (on my R710)
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

printf "Activating manual fan speeds! (2160 RPM)"
ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW -y $IPMIEK raw 0x30 0x30 0x01 0x00
ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW -y $IPMIEK raw 0x30 0x30 0x02 0xff 0x09
