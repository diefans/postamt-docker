FROM ansible/ubuntu14.04-ansible:devel

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

# Run Ansible to configure the Docker image
RUN ansible-playbook site.yml -c local -vv

ENV PATH /srv/postamt/bin:/usr/bin:/bin:/usr/local/bin:/sbin:/usr/local/sbin:/usr/sbin

ENV DB /srv/postamt/data/mail.sqlite

ADD create.sql /srv/postamt/create.sql
ADD start-postamt.sh /srv/postamt/bin/start-postamt.sh

ADD admin.sh /srv/postamt/bin/admin.sh
ADD admin.py /srv/postamt/bin/admin.py

ENTRYPOINT ["start-postamt.sh"]
