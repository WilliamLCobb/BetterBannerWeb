# Test browser - http://browserspy.dk/browser.php

# Ideas:
# Random Class
# RMP integration


import mechanize
import random
import time
import re
import banwebParser


class EnrolledClass(object):
    def __init__(self, id, number, type, name, credits, gpa=None):
        self.id = id
        self.number = number
        self.type = type
        self.name = name
        self.credits = credits
        self.gpa = gpa

    def __str__(self):
        if (self.gpa):
            return '<Class: {0:<6} {1:<5} {2:<3} {3:>5}>'.format(self.id, self.number, self.gpa, self.name)
        return '<Class: {0:<6} {1:<5} {2:>5}>'.format(self.id, self.number, self.name)


class BanWeb(object):
    def __init__(self, rhodesId, pin):
        self.rhodesId = rhodesId
        self.pin = pin

        self.lastTranscriptUpdate = 0

        self._enrolledClasses = []

        ###  Set up browser  ###
        self.browser = mechanize.Browser()
        self.browser.set_handle_robots(False)
        self.browser.set_handle_equiv(True)
        #self.browser.set_handle_gzip(True)
        self.browser.set_handle_redirect(True)
        self.browser.set_handle_referer(True)
        userAgents = ['Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.116 Safari/537.36']
        self.userAgent = random.choice(userAgents)
        self.browser.addheaders = [('User-agent', self.userAgent)]

    def setReferrer(self, ref):
        self.browser.addheaders = [('User-agent', self.userAgent),
                                   ('Referer', ref)]

    def login(self):
        print "Logging in to Banweb"
        self.browser.open("https://banweb.rhodes.edu/prod/twbkwbis.P_ValLogin")
        self.browser.select_form(name="loginform")
        self.browser["sid"] = self.rhodesId
        self.browser["PIN"] = self.pin
        response = self.browser.submit()
        url = response.geturl()
        url_components = url.split("?")
        if (len(url_components) > 1 and url_components[0] == "https://banweb.rhodes.edu/prod/twbkwbis.P_GenMenu"):
            return True
        print "Error, unable to login to Ban Web"
        return False


    def updateTranscript(self, force = False):
        if force or time.time() - self.lastTranscriptUpdate > 3600:
            self.lastTranscriptUpdate = time.time()
            self.setReferrer('https://banweb.rhodes.edu/prod/twbkwbis.P_GenMenu?name=bmenu.P_AdminMnu')
            self.browser.open("https://banweb.rhodes.edu/prod/bwskotrn.P_ViewTermTran")
            self.browser.select_form(nr=1)
            response = self.browser.submit()
            html = response.read()
            self._enrolledClasses = banwebParser.classesFromTranscript(html)

    @property
    def enrolledClasses(self):
        self.updateTranscript()
        return self._enrolledClasses

    @property
    def gpa(self):
        self.updateTranscript()
        return self._gpa

def main():
    r_number = raw_input("Enter R Number:")
    pin = raw_input("Enter Pin:")
    banweb = BanWeb(r_number, pin)
    if not banweb.login():
        print "Error logging in"
        return
    else:
        print "Logged In"
    print banweb.enrolledClasses

main()

