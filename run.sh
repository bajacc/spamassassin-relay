#!/bin/bash
# change max size to 268435456 B = 256 MB. default is 500KB

addgroup -S spamd
adduser -S spamd -G spamd -s /bin/false -h $SAHOME

sed -i "s/relayhost =/relayhost = $RELAY_HOST/" /etc/postfix/main.cf
sed -i "s/smtp      inet  n       -       n       -       -       smtpd/smtp inet n - - - - smtpd -o content_filter=spamassassin/" /etc/postfix/master.cf
echo 'spamassassin unix - n n - - pipe user=spamd argv=/usr/bin/spamc --max-size=268435456 -f -e /usr/sbin/sendmail -oi -f ${sender} ${recipient}' >> /etc/postfix/master.cf
 
sa-update
spamd --create-prefs --max-children 50 --username spamd --helper-home-dir $SAHOME -s $SAHOME/spamd.log start &
postfix start-fg