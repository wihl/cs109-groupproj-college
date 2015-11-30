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
                  "intendedgradyear","female","MinorityRace","international","sports",
                  "earlyAppl","alumni","outofstate"]
predictor_cols = ws_cols + ["acceptrate","size","public","finAidPct","instatePct"]
NUM_ESTIMATORS = 50

colleges = ti.College()

def load_classifier():
    global clf
    df = pd.read_csv(os.path.join(os.path.dirname(__file__),"collegedata_normalized.csv"))
    cols_to_drop = []
    for i in df.columns:
        if 1.0* df[i].isnull().sum() / len(df[i]) >= 0.5:
            cols_to_drop.append(i)
    dfr = df.drop(cols_to_drop,axis=1)
    dfr = dfr[pd.notnull(df["acceptStatus"])]
    dfpredict = dfr[predictor_cols]
    dfresponse = dfr["acceptStatus"]
    imp = Imputer(missing_values="NaN", strategy="median", axis=1)
    imp.fit(dfpredict)
    X = imp.transform(dfpredict)
    y = dfresponse
    clf = RandomForestClassifier(n_estimators=NUM_ESTIMATORS)
    clf.fit(X,y)
    return clf

def genPredictionList(vals):
    global ws_cols
    global clf
    global colleges
    if clf is None: load_classifier()
    preds = []
    X = np.array(vals)
    for i, row in colleges.df.iterrows():
        X_prime = np.append(X, row[-5:]) # take the last 5 columns of the Colleges dataframe 
        y = clf.predict_proba(X_prime)[0][1]
        p = {'college':row.collegeID, 'prob':y}
        preds.append(p)
    return preds
    #e.g.  [{'college':'harvard', 'prob':y}, {'college':'yale', 'prob':0.25}, {'college':'brown', 'prob':0.89}]

@app.route('/')
def hello_world():
    return "Welcome to the Team Ivy Web Service"

@app.route("/predict")
def predict():
    vals = []
    # NOTE: this is pretty fragile. It assumes that the order of the querystring parameters is the same
    #       and that all parameters are present. If this was production code, it would not be written this way.
    for i in ws_cols:
        vals.append( float(request.args.get(i)))
    preds = genPredictionList(vals)
    return jsonify(preds = preds)


if __name__ == '__main__':
    load_classifier()
    app.run(debug=True)

