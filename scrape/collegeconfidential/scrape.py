import requests
import json
import time
from bs4 import BeautifulSoup

def write_json(msgs):
    with open('messages.json','w') as outfile:
        json.dump(msgs, outfile)
    print len(msgs), "messages written"
    return

def read_thread(url):
    req = requests.get(url)

    print url
    if req.status_code != 200:
	print "Could not reach site, Err=",req.status_code
	return
    
    soup = BeautifulSoup(req.text,"lxml")
    # extract time of posting
    itemHeader = soup.find("div", attrs={"class":"DiscussionHeader"})
    firstTime = itemHeader.find("time")['datetime']
    thread = { 'date': firstTime, 'messages':"" }

    #extract msgs
    for msg in soup.find("div",attrs={"class":"Message"}):
	if msg.string is not None:
            thread['messages'] += msg.string
    #print "<EOM>"
    return thread

def search_msgs():
    # search for all messages with "actual results" in the message
    req = requests.get("http://talk.collegeconfidential.com/search?adv=1&search=actual+results&title=&author=&cat=all&tags=&discussion_d=1&within=1+day&date=")

    if req.status_code != 200:
        print "Could not search, Err=",req.status_code
        return

    results = []
    soup = BeautifulSoup(req.text,"lxml")
    for item in soup.findAll("li", attrs={"class","Item-Search"}):
        url = item.findAll("h3")[0].find("a",href=True)['href']
        results.append(read_thread(url))
        time.sleep(1)

    write_json(results)
        

search_msgs()

#read_thread("http://talk.collegeconfidential.com/what-my-chances/1759670-actual-results-fall-2015-applicant-to-architecture-schools.html")
