#!/bin/bash

# Name:
# tcpdive - A TCP performance profiling tool.
#
# Description:
# Tcpdive is designed to provide an insight into TCP's performance. 
# It uses systemtap to collect data from a running linux kernel.

VERSION="1.0"
DATE="2016-1-1"
AUTHOR="zhangskd@gmail.com"
DIR=`dirname $0`
SOURCE="$DIR/src"

# MODULES
RETRANS="never"
CONG="never"
RST="never"
HTTP="never"
BITMAP=0

# OPTIONS
VERBOSE=""
FILTER=""
PORTS=""
FORMAT=0
MODULE_NAME=""
RUN_TIME=""
LIFE_TIME=0
TRANS_TIME=0
SAMPLE=0
ADCONG=0

function version {
	echo -e "Version $VERSION $DATE"
	echo -e "$AUTHOR"
	echo "tcpdive - A TCP performance profiling tool."
	echo ""
}

function usage {
	echo "USAGE:"
	echo "  $0 [options] [modules] [filters]"
	echo ""
	echo "OPTIONS:"
	echo "  -h            # show help"
	echo "  -V            # show version"
	echo "  -v            # verbose mode for debugging"
	echo "  -t <sec>      # stop itself after running specified time"
	echo "  -m            # compile as tcpdive.ko instead of running directly"
	echo "  -d            # detailed logging instead of default format"
	echo ""
	echo "MODULES:"
	echo "  -L            # Loss and Retransmission"
	echo "  -H            # HTTP Performance (1.0/1.1)"
	echo "  -C            # Congestion Control"
	echo "  -A <num>      # Advanced CC (depict <num> critical points)"
	echo "  -R            # Monitor Reset Packet"
	echo ""
	echo "FILTERS:"
	echo "  -l <msec>     # lifetime of connection should greater than <msec>"
	echo "  -i <msec>     # trans time of response should greater than <msec>"
	echo "  -s <num>      # take one sample from <num> connections"
	echo "  -p <ports>    # server ports cared, use comma to separate"
	echo ""
	echo "  -f <laddr>:<lport>-<raddr>:<rport> [-f <...>] # should be last"
	echo "     eg. -f *.*.*.*:80-10.210.136.*:*"
	echo ""
}

# Process cmdline options
while getopts hVvdLCRHmA:f:t:l:i:s:p: option
do
	case $option in
	V) version
	   exit 0;;
	v) VERBOSE="-v";;
	L) RETRANS="retran.*"
	   BITMAP=$(($BITMAP+2));;
	H) HTTP="http.*"
	   BITMAP=$(($BITMAP+4));;
	C) CONG="cong.*"
	   BITMAP=$(($BITMAP+8));;
	R) RST="rst.*"
	   BITMAP=$(($BITMAP+16));;
	A) ADCONG=$OPTARG
	   CONG="cong.*"
	   BITMAP=$(($BITMAP+32));;
	f) FILTER="$OPTARG $FILTER";;
	t) RUN_TIME=$OPTARG;;
	m) MODULE_NAME="-p 4 -m tcpdive";;
	d) FORMAT=1;;
	l) LIFE_TIME=$OPTARG;;
	i) TRANS_TIME=$OPTARG;;
	s) SAMPLE=$OPTARG;;
	p) PORTS="ports=$OPTARG";;
	h|?|*)
	   usage
	   exit 1;;
	esac
done

# In case that no modules specified, set default here
if [ $BITMAP -eq 0 ]; then
	RETRANS="never"
	CONG="never"
	HTTP="never"	
	RST="never"
fi

# Use systemtap to compile module
stap -t -w -g -DINTERRUPTIBLE=0 \
-D MAXACTION=1000000 -D MAXSTRINGLEN=1024 \
$VERBOSE $MODULE_NAME -I $SOURCE -e '
probe begin 
{
	printf("Probe begin...\n")
	structs_init()

	if (process_cmdline() < 0)
		exit()
}

# Probe points MUST
probe estab.* {}
probe close.* {}
probe trans.* {}

# Probe points Optional
probe '$RETRANS' {}
probe '$CONG' {}
probe '$RST' {}
probe '$HTTP' {}

probe end
{
	if (!mem_is_stop())
		mem_free_active()

	printf("\n\nProbe end!\n")
	log_mem_usage()
}
' bitmap=$BITMAP timeout=$RUN_TIME lifetime=$LIFE_TIME \
trans_time=$TRANS_TIME ad_cong=$ADCONG detail_log=$FORMAT \
sample_ratio=$SAMPLE $PORTS $FILTER


