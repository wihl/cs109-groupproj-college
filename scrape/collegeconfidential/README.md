### Scrape College Confidential ###

`scrape.py` performs a download / scrape of College Confidential. It performs a search for "actual results" and then walks the messages to output in a JSON-encoded file called `messages.json`.

Run it simply from the command line:

```
python scrape.py
```
It will print a line for every thread it finds and then
print a summary of total threads written to JSON at the end.

The current version stops at 1000 messages which should
be sufficient to build the parsers.

### JSON File Format ###

The JSON file is a single large array of threads:

```json
[
	{ "date" : date-str,
	  "url" : url,
	  "messages" : message-body
	},
	{ "date", date-str,
	  "url" : url,
	  "messages" : message-body
	},
	...
]
```
where

* `date-str` is the UTC encoded date of the first message in the thread.
* `url` is the source URL of the thread
* `message-body` is the content of all the text in the thread. Separate messages in the thread are concatenated into a single long block of text. No header information is preserved.

#### Viewing the Downloaded JSON ###

You can use your favorite JSON viewer, or from the command line:

```
cat messages.json | python -m json.tool | more
```