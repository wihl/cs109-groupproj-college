from flask import Flask
from flask import jsonify, request

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
college_cols = ["acceptrate","size","public","finAidPct","instatePct"]
predictor_cols = ws_cols + college_cols

cols_to_drop = ['classrank', 'canAfford', 'firstinfamily', 'artist', 'workexp', 'visited', 'acceptProb',
                'addInfo','intendedgradyear']
NUM_ESTIMATORS = 1000

colleges = ti.College()

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
    X = pd.Series(dict((name, float(val)) for name, val in vals))
    if clf is None: load_classifier()
    preds = []
    for i, row in colleges.df.iterrows():
        X[college_cols] = row[college_cols]
        y = clf.predict_proba(X[predictor_cols])[0][1]
        p = {'college':row.collegeID, 'prob':y}
        preds.append(p)
    return preds
    #e.g.  [{'college':'harvard', 'prob':y}, {'college':'yale', 'prob':0.25}, {'college':'brown', 'prob':0.89}]

@app.route('/')
def hello_world():
    return "Welcome to the Team Ivy Web Service"

@app.route("/predict")
def predict():
    preds = genPredictionList(request.args.iteritems())
    return jsonify(preds = preds)


if __name__ == '__main__':
    app.run(debug=True)

