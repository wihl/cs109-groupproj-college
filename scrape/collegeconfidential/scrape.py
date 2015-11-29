import requests
import json
import time
from bs4 import BeautifulSoup

msgcount = 0 # global

def write_json(threads):
    global msgcount
    with open('messages.json','w') as outfile:
        json.dump(threads, outfile)
    print "Total:", len(threads), "threads,",msgcount,"messages"
    return

def read_thread(url):
    global msgcount
    req = requests.get(url)

    print url
    if req.status_code != 200:
	print "Could not reach site, Err=",req.status_code
	return
    
    soup = BeautifulSoup(req.text,"lxml")
    # extract time of posting
    itemHeader = soup.find("div", attrs={"class":"DiscussionHeader"})
    firstTime = itemHeader.find("time")['datetime']
    thread = { 'date': firstTime, 'url':url, 'messages':"" }

    #extract msgs
    for msg in soup.find("div",attrs={"class":"Message"}):
	if msg.string is not None:
            thread['messages'] += msg.string
            msgcount += 1
    #print "<EOM>"
    return thread

def search_msgs():
    # search for all messages with "actual results" in the message
    baseurl = "http://talk.collegeconfidential.com"
    req = requests.get(baseurl + "/search?adv=1&search=actual+results&title=&author=&cat=all&tags=&discussion_d=1&within=1+day&date=")
    maxthreads = 1000
    results = []

    while (maxthreads > 0 and req.status_code == 200):
        soup = BeautifulSoup(req.text,"lxml")
        for item in soup.findAll("li", attrs={"class","Item-Search"}):
            url = item.findAll("h3")[0].find("a",href=True)['href']
            results.append(read_thread(url))
            maxthreads -= 1
            time.sleep(1)
        
        # get the next page of results
        nextpage = soup.find("a", attrs={"class","Next"},href=True)
        if not nextpage: break
        req = requests.get(baseurl + nextpage['href'])

    if req.status_code != 200:
        print "Could not search, Err=",req.status_code
        return
    else:
        print "Max threads reached or no additional threads found."


    write_json(results)
        

search_msgs()

#read_thread("http://talk.collegeconfidential.com/what-my-chances/1759670-actual-results-fall-2015-applicant-to-architecture-schools.html")
