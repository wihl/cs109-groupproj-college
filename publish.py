"""
Publish.py - take a set of iPython notebooks, export them to HTML and publish them to a public website

Usage: python publish.py [--push] [notebook]
       --push will push the converted notebooks to the gh-pages branch
       notebook allows publishing of only a single notebook. By default, all notebooks listed 
       below will be published.
TODO: publish only a single file
"""

import argparse
import os
from urllib import quote_plus
import subprocess

# Contains: chapter number, notebook filename, chapter title
# if the chapter is number 0, do not put a "Chapter n - " prefix
chapter_list = [
	['0','teamivy','Preface'],
	['1','database','Data Model and Database'],
	['2','ScrapingCollegedata_MultipleRender','Scraping and Collecting Data'],
	['3','normalize','Normalizing'],
	['4','EDA','Data Analysis'],
	['5','classification_v2','Classification'],
	['7','website','The Public Website'],
	['8','conclusion','Conclusions and Next Steps'],
	['0','references','Appendix A - References and Dependencies'],
	['0','build_deploy','Appendix B - Build and Deploy'],
	]

TMPDIR = os.environ['TMPDIR']
PREFIX = 'ipython nbconvert --to html --output ' + TMPDIR

def striptags(file):
    """
    Since the resulting file will be pulled into a wrapper document,
    the surrounding <HTML>, <HEAD> and <BODY> tags have to stripped
    """
    # we are checking only the first 6 characters rather reading the whole file into Soup
    tags_to_strip = ['<!DOCT','<html>','<head>','<title','</body','</html']
    f = open(TMPDIR+file+'.html',"r+")
    d = f.readlines()
    f.seek(0)
    for i in d:
        if i[0:6] not in tags_to_strip:
            f.write(i)
    f.truncate()
    f.close()

def convert(file):
    ret = 0
    cmd = PREFIX + file + '.html ' + file + '.ipynb'
    ret = subprocess.call(cmd, shell=True)
    if ret == 0: striptags(file)
    return ret

def update_index(optionstr):
    f = open('index.html',"r+")
    d = f.readlines()
    f.seek(0)
    for i in d:
        if i.lstrip()[0:7] == '<option':
	    if (not inoption):
		for j in optionstr:
		    f.write(j)
		inoption = True
        else:
	    inoption = False
            f.write(i)
    f.truncate()
    f.close()

def gitpush():
    # move the generated HTML from the TMPDIR to the current dir
    for i in chapter_list:
	os.rename(TMPDIR+i[1]+'.html', './'+i[1]+'.html')
    subprocess.call('git add .',shell=True)
    subprocess.call('git commit -m "new page updates"',shell=True)
    subprocess.call('git push',shell=True)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--push', dest='push', action='store_true')
    parser.add_argument('--no-push', dest='push', action='store_false')
    parser.set_defaults(push=False)
    args = parser.parse_args()

    newoptions = []
    for i in chapter_list:
	convert(i[1])
        str = '\t\t\t\t<option value="' + i[1] + '.html">'
        if i[0] != '0':
	    str = str + "Chapter "+i[0]+" - "
	str = str + i[2] + "</option>" + '\n'
        newoptions.append(str)
    subprocess.call('git checkout gh-pages',shell=True)
    subprocess.call('git pull',shell=True)
    update_index(newoptions)
    #print newoptions
    if (args.push): gitpush()
    print "NOTE: you are now in the gh-pages branch"

if __name__ == "__main__":
    main()


"""
Helpful links:
http://stackoverflow.com/questions/5607551/python-urlencode-string
https://mkaz.github.io/2014/07/26/python-argparse-cookbook/
http://stackoverflow.com/questions/19067822/save-ipython-notebook-as-script-programmatically to save our notebook as HTML
http://stackoverflow.com/questions/15008758/parsing-boolean-values-with-argparse
http://stackoverflow.com/questions/89228/calling-an-external-command-in-python
http://stackoverflow.com/questions/4710067/deleting-a-specific-line-in-a-file-python
"""
