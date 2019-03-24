#!/bin/bash
#
#set -x

. /etc/autoshutdown.conf

logit()
{
	logger -p local0.notice -s -- AutoShutdown: $*
}

IsOnline()
{
        for i in $*; do
		ping $i -c1
		if [ "$?" == "0" ]; then
		  logit PC $i is still active, auto shutdown terminated
		  return 1
		fi
        done

	return 0
}

IsRunning()
{
        for i in $*; do
		if [ `pgrep -c $i` -gt 0 ] ; then
		  logit $i still active, auto shutdown terminated
                  return 1
                fi
        done

        return 0
}

IsDamonActive()
{
        for i in $*; do
                if [ `pgrep -c $i` -gt 1 ] ; then
                  logit $i still active, auto shutdown terminated
                  return 1
                fi
        done

        return 0
}

IsPortInUse()
{
        for i in $*; do
                Err=`LANG=C netstat -an | grep "${myIp}:${i}" \
                    | grep -E "ESTABLISHED|FIN_WAIT1|FIN_WAIT2|TIME_WAIT|CLOSE_WAIT" \
                    | wc -l`

                if [ ${Err} -gt 0 ] ; then
                  logit "Port ${i} is still in use, auto shutdown terminated"
                  return 1
                fi
        done

        return 0
}

IsBusy()
{
	# Samba
	if [ "x$SAMBANETWORK" != "x" ]; then
		smbClients=`/usr/bin/smbstatus -b | grep $SAMBANETWORK | awk '{print $5}' | cut -d: -f2`
		IsOnline $smbClients
		if [ "$?" == "1" ]; then
                	return 1
        	fi
	fi

	#damons that always have one process running
	IsDamonActive $DAMONS
        if [ "$?" == "1" ]; then
                return 1
        fi

	#backuppc, wget, wsus, ....
        IsRunning $APPLICATIONS
	if [ "$?" == "1" ]; then
                return 1
        fi

        # check network-ports
        if [ "x${NETWORKPORTS}" != "x" ]; then
                myIp=$(LANG=C /sbin/ifconfig | awk '/inet / {print $2}' | head -n 1)
                IsPortInUse ${NETWORKPORTS}
                if [ "$?" == "1" ]; then
                        return 1
                fi
        fi

	# Read logged users
	USERCOUNT=`who | wc -l`;
	# No Shutdown if there are any users logged in
	test $USERCOUNT -gt 0 && { logit some users still connected, auto shutdown terminated; return 1; }

        IsOnline $CLIENTS
        if [ "$?" == "1" ]; then
                return 1
        fi

	return 0
}

COUNTFILE="/var/spool/shutdown_counter"
OFFFILE="/var/spool/shutdown_off"

# turns off the auto shutdown
if [ -e $OFFFILE ]; then
	logit auto shutdown is turned off by existents of $OFFFILE
	exit 0
fi

if [ "$AUTO_SHUTDOWN" = "true" ] || [ "$AUTO_SHUTDOWN" = "yes" ] ; then
	IsBusy
	if [ "$?" == "0" ]; then
		# was it not busy already last time? Then shutdown.
		if [ -e $COUNTFILE ]; then
	        	# shutdown
	        	rm -f $COUNTFILE
		        logit auto shutdown caused by cron
        		/sbin/shutdown -P now
		        exit 0
		else
			# shut down next time
			touch $COUNTFILE
			logit marked for shutdown in next try
			exit 0
		fi
	else
		rm -f $COUNTFILE
		#logit aborted
		exit 0
	fi
fi

logit malfunction
exit 1
