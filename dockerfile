FROM alpine:3.16

EXPOSE 25

RUN apk add --no-cache bash postfix gpg-agent spamassassin spamassassin-client msmtp

COPY conf/main.cf /etc/postfix
COPY conf/local.cf /etc/mail/spamassassin
COPY run.sh run.sh

RUN ["chmod", "+x", "run.sh"]
ENTRYPOINT ["./run.sh"]