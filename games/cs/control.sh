#!/bin/bash
# Counter Strike: Source
# Server Management Script
# Author: Daniel Gibbs
# Website: http://danielgibbs.co.uk
# Version: 210115

#### Variables ####

# Notification Email
# (on|off)
emailnotification="{{emailNot}}"
email="{{email}}"

# Steam login
steamuser="anonymous"
steampass=""

# Server Details
servername="{{hostname}}"
rcon="{{rcon}}"

# Start Variables
defaultmap="{{map}}"
maxplayers="{{maxplayers}}"
port="{{port}}"
clientport="{{clientport}}"
ip="{{ip}}"

# https://developer.valvesoftware.com/wiki/Command_Line_Options#Command-line_parameters_2
fn_parms(){
parms="-game cstrike -strictportbind -ip ${ip} -port ${port} +clientport ${clientport} +map ${defaultmap} -maxplayers ${maxplayers}"
}

#### Advanced Variables ####

# Steam
appid="90 +app_set_config 90 mod cstrike"

# Server Details
servicename="{{id}}"
gamename="Counter Strike 1.6"
engine="goldsource"

# Directories
rootdir="$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd )"
selfname="$(basename $0)"
lockselfname=".${servicename}.lock"
filesdir="${rootdir}/serverfiles"
systemdir="${filesdir}/cstrike"
executabledir="${filesdir}"
executable="./hlds_run"
servercfgdir="${systemdir}"
servercfg="${servicename}.cfg"
servercfgfullpath="${servercfgdir}/${servercfg}"
defaultcfg="${servercfgdir}/server.cfg"
backupdir="${rootdir}/backups"

# Logging
logdays="7"
gamelogdir="${systemdir}/logs"
scriptlogdir="${rootdir}/log/script"
consolelogdir="${rootdir}/log/console"

scriptlog="${scriptlogdir}/${servicename}-script.log"
consolelog="${consolelogdir}/${servicename}-console.log"
emaillog="${scriptlogdir}/${servicename}-email.log"

scriptlogdate="${scriptlogdir}/${servicename}-script-$(date '+%d-%m-%Y-%H-%M-%S').log"
consolelogdate="${consolelogdir}/${servicename}-console-$(date '+%d-%m-%Y-%H-%M-%S').log"

##### Script #####
# Do not edit

fn_runfunction(){
# Functions are downloaded and run with this function
if [ ! -f "${rootdir}/functions/${functionfile}" ]; then
	cd "${rootdir}"
	if [ ! -d "functions" ]; then
		mkdir functions
	fi
	cd functions
	echo -e "loading ${functionfile}...\c"
	wget -N --no-check-certificate /dev/null https://raw.githubusercontent.com/dgibbs64/linuxgsm/master/functions/${functionfile} 2>&1 | grep -F HTTP | cut -c45-
	chmod +x "${functionfile}"
	cd "${rootdir}"
	sleep 1
fi
source "${rootdir}/functions/${functionfile}"
}

fn_functions(){
# Functions are defined in fn_functions.
functionfile="${FUNCNAME}"
fn_runfunction
}

fn_functions

getopt=$1
fn_getopt