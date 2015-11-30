library(jsonlite)
pred = data.frame(admissionstest=numeric(0),
                  AP=numeric(0),
                  averageAP=numeric(0),
                  SATsubject=numeric(0),
                  GPA=numeric(0),
                  schooltype=numeric(0),
                  intendedgradyear=numeric(0),
                  female=numeric(0),
                  MinorityRace=numeric(0),
                  international=numeric(0),
                  sports=numeric(0),
                  earlyAppl=numeric(0),
                  alumni=numeric(0),
                  outofstate=numeric(0),
                  acceptrate=numeric(0),
                  size=numeric(0),
                  public=numeric(0),
                  finAidPct=numeric(0),
                  instatePct=numeric(0))
pred[1,] = list(9.26899206e-01,   7.00000000e+00,   1.06733864e+00,   3.24271565e-01,
            -1.87109979e-01,   0.00000000e+00,   2.01700000e+03,   1.00000000e+00,
            0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,
            0.00000000e+00,   0.00000000e+00,   1.51000000e-01,   6.62100000e+03,
            0.00000000e+00,   0.00000000e+00,   0.00000000e+00)

# create query string
qs = paste0(colnames(pred),"=",pred[1,],collapse="&")

URL = paste0("http://127.0.0.1:5000/predict","?",qs)

js  = fromJSON(URL)
df = js$preds
df$college = as.factor(df$college)
summary(df)
