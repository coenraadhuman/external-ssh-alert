# external-ssh-alert
Simple script to send an email via `Proton Mail Bridge` if an SSH connection is made from external client to your machine.

### Context

My machine is running Ubuntu 24.04 and I wanted the means of being notified of when I or someone else logins into the machine from the outside world.

### Setup

1. Install [Proton Mail Bridge](https://proton.me/mail/download)
1. Log into it so you can get the details you need for the setup of `ssmtp` and `mail`
1. Install `ssmtp` to use the SMTP protocal with `mail`: `sudo apt install ssmtp`
1. Edit your `/etc/ssmtp/ssmtp.conf`:

    ```bash
    #
    # Config file for sSMTP sendmail
    #
    # The person who gets all mail for userids < 1000
    # Make this empty to disable rewriting.
    root=postmaster
    SERVER=THE EMAIL ADDRESS YOU ARE USING FROM PROTON

    # The place where the mail goes. The actual machine name is required no 
    # MX records are consulted. Commonly mailhosts are named mail.domain.com
    
    # This is the details from Proton Mail Bridge:
    mailhub=127.0.0.1:1025
    AuthUser=USERNAME
    AuthPass=PASSWORD
    UseTLS=YES
    UseSTARTTLS=YES

    # Where will the mail seem to come from? THIS IS THE DOMAIN OF THE EMAIL YOU ARE SENDING FROM
    rewriteDomain=pm.me

    # The full hostname, YOUR MACHINE's HOSTNAME
    hostname=HOSTNAME

    # Are users allowed to set their own From: address?
    # YES - Allow the user to specify their own From: address
    # NO - Use the system generated From: address
    FromLineOverride=YES
    ```

1. Install mailutils to send email from terminal: `sudo apt install -y mailutils` 
1. Copy the script, `ssh_login_notify.sh` to `/usr/local/bin/`.
1. Make it executable: `sudo chmod +x /usr/local/bin/ssh_login_notify.sh`
1. Change the details in the script, namely: sender and recipient variables.
1. Lastly edit your `/etc/bash.bashrc` and add the below (it relies on the terminal multiplexer `screen` if you don't have this installed do it via your package manager):

    ```bash
    if [[ ! -v SSH_CONNECTION ]]; then
        echo "SSH_CONNECTION is not set" &>/dev/null
    elif [[ -z "$SSH_CONNECTION" ]]; then
        echo "SSH_CONNECTION is set to the empty string" &>/dev/null
    else
        screen -dm /usr/local/bin/ssh_login_notify.sh "$(/usr/bin/hostname)" "$(/usr/bin/date)" "$(/usr/bin/whoami)" $SSH_CONNECTION
    fi
    ```

    The above ensures that you only get notified when the SSH_CONNECTION variable is populated by OpenSSH, meaning that a remote client has connected.

    ```bash
    SSH_CONNECTION, Identifies the client and server ends of the connection. 
    The variable contains four space-separated values: client IP address and client port number and server IP address and server port number. 
    SSH client and server socket connection info; set by the sshd(8) daemon, string, session.c
    ```

### Contributions

Feel free to contribute to this guide and scripts.
