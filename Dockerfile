FROM ansible/ubuntu14.04-ansible:devel

RUN apt-get update -yqq
RUN apt-get upgrade -yqq
RUN apt-get install vim -yqq

# smtp
EXPOSE 25
EXPOSE 587

# pop
EXPOSE 110
EXPOSE 995

# imap
EXPOSE 143
EXPOSE 993

# Add playbooks to the Docker image
ADD ansible /srv/postamt/
WORKDIR /srv/postamt

ENV PATH $PATH:/srv/postamt/bin:/usr/bin:/bin:/usr/local/bin:/sbin:/usr/local/sbin:/usr/sbin
ENV POSTAMT_ROOT /srv/postamt
ENV POSTAMT_DATA $POSTAMT_ROOT/data
ENV POSTAMT_VMAIL $POSTAMT_DATA/vmail
ENV POSTAMT_DB $POSTAMT_DATA/mail.sqlite

ENV HOSTNAME localhost

# persist ssl
#ENV POSTAMT_SSL_MAKE 0
ENV POSTAMT_SSL $POSTAMT_DATA/ssl
ENV POSTAMT_SSL_CN example.com
ENV POSTAMT_SSL_C DE
ENV POSTAMT_SSL_ST Berlin
ENV POSTAMT_SSL_L Berlin
#ENV POSTAMT_SSL_O foobar

ENV POSTAMT_DOVECOT_SSL $POSTAMT_SSL/dovecot
ENV POSTAMT_DOVECOT_SSL_CN $POSTAMT_SSL_CN

ENV POSTAMT_POSTFIX_SSL $POSTAMT_SSL/postfix
ENV POSTAMT_POSTFIX_SSL_CN $POSTAMT_SSL_CN


# Run Ansible to configure the Docker image
RUN ansible-playbook site.yml -c local -vv

ADD start-postamt.sh /srv/postamt/bin/start-postamt.sh

ENTRYPOINT ["start-postamt.sh"]
