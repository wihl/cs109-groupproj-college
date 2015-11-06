import string
import random as random
import pandas as pd


# Module globals
studentDF = None
collegeDF = None

class Student:
    def __init__(self):
        global studentDF
        self.keysize = 10
        self.factorcolumns = ['canAfford', 'female', 'MinorityGender','MinorityRace',
                              'outofstate','international','firstinfamily','alumni',
                              'sports','artist', 'workexp']
        self.columnlist = ['studentID','classrank', 'admissionstest','AP','averageAP',
                           'SATsubject', 'GPA', 'program','schooltype',
                           'intendedgradyear'] + self.factorcolumns
        if (studentDF is None):
            studentDF = pd.DataFrame(columns = self.columnlist)

        return

    def newstudentID(self):
        return ''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(self.keysize))

    @property
    def df(self):
        global studentDF
        return studentDF

    @df.setter
    def df(self, df):
        global studentDF
        if not isinstance(df, pd.DataFrame):
            raise TypeError('Expected a Pandas DataFrame')
        studentDF = df

    def cleanup(self):
        """
        reinitialize all the globals
        """
        global studentDF, collegeDF
        studentDF = None
        collegeDF = None

    def insertrow(self, row):
        global studentDF
        if (not isinstance(row,dict)):
            raise TypeError("only dicts can be used to insert")
        studentID = self.newstudentID()
        # check for a rare random collision until we get a unique value
        while (studentID in studentDF.studentID.values):
            studentID = self.newstudentID()
        row['studentID'] = studentID
        # fill any missing indicator columns with 0's
        for c in self.factorcolumns:
            if (not c in row):
                row[c] = 0
        return row


    def insert(self,args):
        """
        Insert either a single row (when a dict is passed) or a list of rows
        """
        global studentDF
        rows = []
        if (isinstance(args, dict)):
            rows.append(self.insertrow(args))
        elif (isinstance(args, list)):
            for i in args:
                rows.append(self.insertrow(i))
        else:
            raise TypeError("insert either a single dict or a list of dicts")
        studentDF = studentDF.append(rows)

    def fillRandom(self, nrows):
        global studentDF
        """
        populate the dataframe with n random rows.
        """
        for i in range(nrows):
            studentDF.loc[i] = [
                self.newstudentID(), # studentID
                random.random(), # classrank
                random.random(), # admissiontest
                random.random(), # AP
                random.random(), # averageAP
                random.random(), # SAT subject
                random.random(), # GPA
                random.randint(1,5), # program factor 
                random.randint(1,5), # schooltype
                random.randint(2010,2020), # grad year
                random.randint(-1,1), # canAfford
                random.randint(-1,1), # female
                random.randint(-1,1), # MinorityGender
                random.randint(-1,1), # MinorityRace
                random.randint(-1,1), # outofstate
                random.randint(-1,1), # international
                random.randint(-1,1), # firstinfamily
                random.randint(-1,1), # alumni
                random.randint(-1,1),  # sports
                random.randint(-1,1),  # artist
                random.randint(-1,1) # workexp
                ]




class College:
    def __init__(self):
        global collegeDF
        collegeDF = pd.read_csv("collegelist.csv")
        #collegeDF = pd.DataFrame(columns = 
        #                              ['collegeID','name','acceptrate','size','public',
        #                               'finAidPct','instatePct'])
        return

    @property
    def df(self):
        global collegeDF
        return collegeDF

    @df.setter
    def df(self, df):
        global collegeDF
        if not isinstance(df, pd.DataFrame):
            raise TypeError('Expected a Pandas DataFrame')
        collegeDF = df



class ApplForm:
    def __init__(self):
        global studentDF, collegeDF
        self.ApplFormDF = pd.DataFrame(columns =
                                       ['studentID','collegeID','earlyAppl','visited',
                                        'acceptStatus','acceptProb'])

        return
    @property
    def df(self):
        return self.ApplFormDF

    @df.setter
    def df(self, df):
        if not isinstance(df, pd.DataFrame):
            raise TypeError('Expected a Pandas DataFrame')
        self.ApplFormDF = df

    def fillRandom(self,nrows):
        global studentDF, collegeDF
        i = 0
        while (i < nrows):
            studentID = studentDF.sample(1).studentID.iloc[0]
            collegename = collegeDF.sample(1).name.iloc[0]
            # Make sure we don't have this combination already
            if (self.ApplFormDF.loc[(self.ApplFormDF['studentID'] == studentID) & 
                                    (self.ApplFormDF['collegeID'] == collegename)   , 'visited' ].count() == 0): 
                # add in a new record
                self.ApplFormDF.loc[i] = [studentID, collegename, 
                                          random.randint(-1,1), # earlyAppl
                                          random.randint(-1,1), # visited
                                          random.randint(-1,1), # acceptStatus
                                          random.random() # acceptProb
                                          ]
                i += 1

class Application:
    """
    Consists of one student and one ApplForm
    """
    def __init__(self):
        return




