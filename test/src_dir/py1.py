# -*- coding: utf-8 -*-
# Python

# Suppose you want to spam your friend, and you have lots of
# friends. The solution is to write a program to do it. After a gander
# at python docs, one easily found the module for the job.
# see http://python.org/doc/2.3.4/lib/SMTP-example.html

# the code is a bit long with the command line, but the key lies at
# the bottom four lines. The gist is this:

####### test: strings - nonsense code follows
"\"
# still in string
"
'\'
# still in string
'
####### test done
import smtplib

smtpServer='smtp.yourdomain.com';
fromAddr='xah@xahlee.org';
toAddr='xah@xahlee.org';
text='''Subject: newfound love

Hi friend,

long time no write, i have a new manifesto i
 think it would be of interest for you to peruse.
 ...
 '''

server = smtplib.SMTP(smtpServer)
server.set_debuglevel(1)
server.sendmail(fromAddr, toAddr, text)
server.quit()

# save this file as x.py and run it.
# it should send out the mail.

# the set_debuglevel() is nice because you see all the interactions
# with the smtp server. Useful when you want to see what's going on
# with a smtp server.
