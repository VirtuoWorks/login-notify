#!/bin/bash

## Login notification script

## Put it in /etc/profile.d to send an e-mail on user login.
##  - chown root:root && chmod 755
##  - uses mutt to send e-mail (apt-get install mutt)
##  - sends the output of some commands as attachments:
##    - netstat (connections/servers)
##    - iptables (firewall configuration)
##    - ps (processes list)
##    - who (logged in users + hostnames)
##  You need a configured MTA/smtp server in order to send emails.

# --- Configuration ----------------------------------------------------

TO="my-address@my-mail-provider.tld"
FROM="security@my-server-domain.tld"

# ----------------------------------------------------------------------

LOG_USER="$( whoami )"
LOG_DATE="$( date "+%Y-%m-%d %H:%M:%S" )"
OUT_WHO="$( who )"

if [ "$(id -u)" -ne "0" ]; then
  netstat -n    1> /tmp/netstat.log        2> /dev/null
  netstat -ln   1> /tmp/netstat-listen.log 2> /dev/null
  echo "IPTables dump is only available on root login." > /tmp/iptables-conf.log
else
  netstat -lnp  > /tmp/netstat-listen.log
  netstat -np   > /tmp/netstat.log
  (
  echo "--- Iptables: list rules"
  iptables -L
  echo
  echo "--- Iptables: show rules"
  iptables -S
  )     > /tmp/iptables-conf.log
fi

ps afux > /tmp/processes.log
who     > /tmp/who.log

(
cat <<EOF
------------------------------------------------------------------------
  LOGIN NOTIFICATION
------------------------------------------------------------------------

Host:   $(hostname)
User:   ${LOG_USER}
Date:   ${LOG_DATE}
        $(date)
Uptime: $(uptime)

--- Logged in users ----------------------------------------------------
${OUT_WHO}

------------------------------------------------------------------------
Attaching other relevant system data.

EOF
) | /usr/bin/mutt -s "[LOGIN-NOTIFY] $(hostname) Login of ${LOG_USER} on ${LOG_DATE}" -e "set copy=no" -e "set from=${FROM}" -a /tmp/netstat-listen.log -a /tmp/netstat.log -a /tmp/processes.log -a /tmp/who.log -a /tmp/iptables-conf.log -- "${TO}"

rm /tmp/netstat-listen.log /tmp/netstat.log /tmp/processes.log /tmp/who.log /tmp/iptables-conf.log
