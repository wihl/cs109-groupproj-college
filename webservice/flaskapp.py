# -*- coding: utf-8 -*-
from datetime import timedelta
from flask import make_response, request, current_app
from functools import update_wrapper
from flask import Flask
from flask import jsonify, request
from functools import wraps

import os
import pandas as pd
from sklearn.preprocessing import Imputer
from sklearn.ensemble import RandomForestClassifier
import numpy as np
import logging

import TIdatabase as ti

app = Flask(__name__)

clf = None
logging.basicConfig(level=logging.DEBUG,format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')


ws_cols = ["admissionstest","AP","averageAP","SATsubject","GPA","schooltype",
                  "female","MinorityRace","international","sports",
                  "earlyAppl","alumni","outofstate"]
college_cols = ["acceptrate","size","public"]
predictor_cols = ws_cols + college_cols

cols_to_drop = ['classrank', 'canAfford', 'firstinfamily', 'artist', 'workexp', 'visited', 'acceptProb',
                'addInfo','intendedgradyear']
NUM_ESTIMATORS = 1000

colleges = ti.College()

# Cross domain script from https://blog.skyred.fi/articles/better-crossdomain-snippet-for-flask.html
# See also:
#    http://stackoverflow.com/questions/22181384/javascript-no-access-control-allow-origin-header-is-present-on-the-requested
#    http://flask.pocoo.org/snippets/56/
def crossdomain(origin=None, methods=None, headers=None,
                max_age=21600, attach_to_all=True,
                automatic_options=True):
    if methods is not None:
        methods = ', '.join(sorted(x.upper() for x in methods))
    if headers is not None and not isinstance(headers, basestring):
        headers = ', '.join(x.upper() for x in headers)
    if not isinstance(origin, basestring):
        origin = ', '.join(origin)
    if isinstance(max_age, timedelta):
        max_age = max_age.total_seconds()

    def get_methods():
        if methods is not None:
            return methods

        options_resp = current_app.make_default_options_response()
        return options_resp.headers['allow']

    def decorator(f):
        def wrapped_function(*args, **kwargs):
            if automatic_options and request.method == 'OPTIONS':
                resp = current_app.make_default_options_response()
            else:
                resp = make_response(f(*args, **kwargs))
            if not attach_to_all and request.method != 'OPTIONS':
                return resp

            h = resp.headers
            h['Access-Control-Allow-Origin'] = origin
            h['Access-Control-Allow-Methods'] = get_methods()
            h['Access-Control-Max-Age'] = str(max_age)
            h['Access-Control-Allow-Credentials'] = 'true'
            h['Access-Control-Allow-Headers'] = \
                "Origin, X-Requested-With, Content-Type, Accept, Authorization"
            if headers is not None:
                h['Access-Control-Allow-Headers'] = headers
            return resp

        f.provide_automatic_options = False
        return update_wrapper(wrapped_function, f)
    return decorator

def load_classifier():
    global clf
    df = pd.read_csv(os.path.join(os.path.dirname(__file__),"collegedata_normalized.csv"), index_col=0)
    dfr = df.drop(cols_to_drop,axis=1)
    dfr = dfr[pd.notnull(df["acceptStatus"])]
    dfpredict = dfr[predictor_cols]
    dfresponse = dfr["acceptStatus"]
    imp = Imputer(missing_values="NaN", strategy="median", axis=1)
    imp.fit(dfpredict)
    X = imp.transform(dfpredict)
    y = dfresponse
    clf = RandomForestClassifier(n_estimators=NUM_ESTIMATORS, criterion="gini")
    clf.fit(X,y)
    return clf

def genPredictionList(vals):
    """
    vals (coming from the request arguments) is a list of tuples [('name1','val1'),('name2','val2')...]
    """
    global ws_cols
    global clf
    global colleges
    X = pd.Series(dict((name, float(val)) for name, val in vals if name != 'callback'))
    if clf is None: load_classifier()
    preds = []
    for i, row in colleges.df.iterrows():
        X[college_cols] = row[college_cols]
        y = clf.predict_proba(X[predictor_cols])[0][1]
        p = {'college':row.collegeID, 'prob':y}
        preds.append(p)
    return preds
    #e.g.  [{'college':'harvard', 'prob':y}, {'college':'yale', 'prob':0.25}, {'college':'brown', 'prob':0.89}]

def jsonp(func):
    """
    Wraps JSONified output for JSONP requests.
    See https://gist.github.com/aisipos/1094140
    """
    @wraps(func)
    def decorated_function(*args, **kwargs):
        callback = request.args.get('callback', False)
        if callback:
            resp = func(*args, **kwargs)
            resp.set_data('{}({})'.format(
                str(callback),
                resp.get_data(as_text=True)
            ))
            resp.mimetype = 'application/javascript'
            return resp
        else:
            return func(*args, **kwargs)
    return decorated_function

@app.route('/')
def hello_world():
    return "Welcome to the Team Ivy Web Service"

@app.route("/predict", methods=['GET', 'OPTIONS'])
@crossdomain(origin='*')
@jsonp
def predict():
    preds = genPredictionList(request.args.iteritems())
    return jsonify(preds = preds)


if __name__ == '__main__':
    app.run(debug=True)
