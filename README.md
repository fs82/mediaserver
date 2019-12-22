# Description and Installation

## backup.sh

### Description

This script makes a backup of the mediaserver to a usb disc.

### Installation

    - Copy backup.sh to your ~/bin directory
    - Enter directory `cd ~/bin`
    - Make the script executable `chmod u+x backup.sh`
    - Run the script `./backup.sh`

## checkshutdown.sh

### Description

This script checks periodically for open ports and samba connections.
If there is no activity the server will be shut down automatically. The
script is inspired by [https://wiki.ubuntuusers.de/Skripte/Auto_OFF](https://wiki.ubuntuusers.de/Skripte/Auto_OFF).

### Installation

    - Copy checkshutdown to /etc/cron.d
    - Copy checkshutdown.sh to /usr/local/sbin/
    - Make it executable `chmod u+x checkshutdown.sh`
    - Copy autoshutdown.conf to /etc/

## localBackup.bat

### Description

This batch file runs [restic](https://restic.net) for backup to a local server that is started via wake on lan first.
The password for the restic repository has to be set as environment variable RESTIC_PASSWORD
(Systemsteuerung\Benutzerkonten und Jugendschutz\Benutzerkonten -> Eigene Umgebungsvariablen ändern)

## cloudBackup.bat

### Description

This batch file runs [restic](https://restic.net) for backup to a cloud storage. 
The password for the restic repository has to be set as environment variable RESTIC_PASSWORD
(Systemsteuerung\Benutzerkonten und Jugendschutz\Benutzerkonten -> Eigene Umgebungsvariablen ändern)

