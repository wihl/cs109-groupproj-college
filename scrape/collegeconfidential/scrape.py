import requests
import json
import time
from bs4 import BeautifulSoup


def read_thread(url):
    req = requests.get(url)

    if req.status_code != 200:
	print "Could not reach site, Err=",req.status_code
	return
    
    soup = BeautifulSoup(req.text,"lxml")
    msgs = soup.find("div",attrs={"class":"Message"})
    for msg in msgs:
	if msg.string is not None:
            print msg.string

def search_msgs():
    # search for all messages with "actual results" in the message
    req = requests.get("http://talk.collegeconfidential.com/search?adv=1&search=actual+results&title=&author=&cat=all&tags=&discussion_d=1&within=1+day&date=")

    if req.status_code != 200:
        print "Could not search, Err=",req.status_code
        return

    soup = BeautifulSoup(req.text,"lxml")
    search_results = soup.findAll("li", attrs={"class","Item-Search"})
    for item in search_results:
        url = item.findAll("h3")[0].find("a",href=True)['href']
        thread = read_thread(url)
        time.sleep(1)
        

search_msgs()

#read_thread("http://talk.collegeconfidential.com/what-my-chances/1759670-actual-results-fall-2015-applicant-to-architecture-schools.html")
