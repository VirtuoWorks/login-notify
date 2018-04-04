# Login notification script

Sends you an e-mail at each user login on linux systems and sends the output of some commands as attachments :
* `netstat` (connections/servers)
* `iptables` (firewall configuration, on root login only)
* `ps` (processes list)
* `who` (logged in users and hostnames)

## Prerequisites

* Install [mutt](http://www.mutt.org/), e-mail client
	* On Debian/Ubuntu : `sudo apt-get install mutt` or `apt install mutt`

* A configured MTA/SMTP server in order to send emails.
  
## Installation

* Copy the script in :
	* `/etc/profile.d/login-notify.sh` .

### Configuration
* Change (line 17)  `my-address@my-mail-provider.tld` with the destination mail address.
* Change (line 18)  `security@my-server-domain.tld` with the source mail address.

## Permissions

* Set the owner/group to root user : 
	* `sudo chown root:root /etc/profile.d/login-notify.sh`
* Set Read/Write/Execute to root user only, others (group and others) to Read/Execute :
	* `sudo chmod 755 /etc/profile.d/login-notify.sh`

### Test
* As root : `sudo /etc/profile.d/login-notify.sh`
* and : `/etc/profile.d/login-notify.sh`
