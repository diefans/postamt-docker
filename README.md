# Postamt


I like to run my own mail server. The problem is, when I started, there were no
containers around, Ubuntu was known as Maverick and I could only pay a little
root server. So how to keep a never-change-a-running-system system up-to-date?

Meanwhile ansible and docker came around the corner - so they should fit a
low-cost-I-have-to-do-it-once-in-a-few-years approach.

## Objective

- Provide a simple docker container with all the mail tools I need and easy
  provisioning.
- Have an easy way to add or change domains, addresses and aliases.
- check spf records.
- helo_checks.


## TODO

- dkim
- greylisting
- postscreen
- spamassassin
- amavis


## Usage

### Build docker container

``` bash
sudo docker build -t postamt .
```

### Create persistence

``` bash
sudo docker run --name postamt-persist -d -v /srv/postamt/data ubuntu:14.04 true
```

### Run docker container

``` bash
sudo docker run --name postamt \
    -p=25:25 \
    -p=143:143 \
    --volumes-from postamt-persist \
    postamt
```

### Create virtual mail user
``` bash
# see postamt admin help
sudo docker exec -it postamt postamt --help

# this will create a virtual domain, an email address and a user with password access
sudo docker exec -it postamt postamt user add foo@foo.bar -p foobar
```


## Notes

I took the howto from http://rob0.nodns4.us/howto/ and tried to implement it. Please see https://github.com/diefans/postamt-admin for the admin.
