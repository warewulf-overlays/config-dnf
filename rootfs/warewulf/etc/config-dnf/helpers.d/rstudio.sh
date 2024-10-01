#!/bin/bash

# Author: griznog
# Purpose: Collect random things that require extra effort to install until we
#          can integrate more conditions in the main service script.

# Pull in warewulf functions/variables for this node.
[[ -f /warewulf/etc/functions ]] && source /warewulf/etc/functions || exit 1


# Install rstudio, this works around the ongoing issue of rstudio being stupid.
# https://github.com/rstudio/rstudio/issues/8840
RSTUDIORPMDIR=/tmp/rstudio.$(date "+%s")
[[ -d ${RSTUDIORPMDIR} ]] && rm -rf ${RSTUDIORPMDIR}
mkdir ${RSTUDIORPMDIR} && chmod 0750 ${RSTUDIORPMDIR} # Fix this race/security flaw.
pushd ${RSTUDIORPMDIR} > /dev/null 2>&1 
  yumdownloader rstudio rstudio-server
  rpm -Uvh --force rstudio*.rpm
  retval=$?
popd > /dev/null 2>&1

# The rpm tries to enable the server, we kill that here.
systemctl stop rstudio-server.service
systemctl disable rstudio-server.service

# Return the exit code from the rpm install attempt.
exit ${retval}

