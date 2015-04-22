# Postamt


I like to run my own mail server. The problem is, when I started, there were no
containers around, Ubuntu was known as Maverick and I could only pay a little
root server. So how to keep a never-change-a-running-system system up-to-date?

Meanwhile ansible and docker came around the corner - so they should fit a
low-cost-I-have-to-do-it-once-in-a-few-years approach.

http://rob0.nodns4.us/howto/


## Objective

- Provide a simple docker container with all the mail tools I need and easy provisioning.
- Have an easy way to add or chnage domains, addresses and aliases.
