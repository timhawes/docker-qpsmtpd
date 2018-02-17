#!/bin/sh
chown -R smtpd: /var/spool/qpsmtpd
cd /srv/qpsmtpd
exec ./qpsmtpd-forkserver --port 25
