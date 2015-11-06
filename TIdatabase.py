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
        global studentDF
        studentDF = None

    def insertrow(self, row):
        global studentDF
        if (not isinstance(row,dict)):
            raise TypeError("only dicts can be used to insert")
        studentID = self.newstudentID()
        # check for a rare random collision until we get a unique value
        while (studentID in studentDF.studentID.values):
            studentID = self.newstudentID()
        row['studentID'] = studentID
        # Leave and missing indicator variables as NaN
        #This is how we would fill any missing indicator columns with 0's
        #---for c in self.factorcolumns:
        #---    if (not c in row):
        #---        row[c] = 0
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

    def read(self,filename):
        global studentDF
        studentDF = pd.read_csv(filename, index_col=0)

    def save(self,filename):
        global studentDF
        return studentDF.to_csv(filename)

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
                random.randint(0,1), # canAfford
                random.randint(0,1), # female
                random.randint(0,1), # MinorityGender
                random.randint(0,1), # MinorityRace
                random.randint(0,1), # outofstate
                random.randint(0,1), # international
                random.randint(0,1), # firstinfamily
                random.randint(0,1), # alumni
                random.randint(0,1),  # sports
                random.randint(0,1),  # artist
                random.randint(0,1) # workexp
                ]
            # TODO: randomly insert NaNs



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
    """
    This contains an application for a given college and the results. Note that
    it is not global as it does not need to shared.
    """
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

    
    def insertrow(self, row):
        global studentDF, collegeDF
        if (not isinstance(row,dict)):
            raise TypeError("only dicts can be used to insert")
        # check the foreign keys exist in studentDF and collegeDF
        if (row['studentID'] not in studentDF.studentID.values):
            raise KeyError("The studentID does not exist in StudentDF")
            return
        if (row['collegeID'] not in collegeDF.collegeID.values):
            raise KeyError("The collegeID does not exist in CollegeDF")
            return
        if (self.ApplFormDF.loc[(self.ApplFormDF['studentID'] == row['studentID']) & 
                                (self.ApplFormDF['collegeID'] == row['collegeID'])   , 'visited' ].count() != 0):
            raise KeyError("This combination of student and college already exists")
            return
        return row


    def insert(self,args):
        """
        Insert either a single row (when a dict is passed) or a list of rows
        """
        rows = []
        if (isinstance(args, dict)):
            rows.append(self.insertrow(args))
        elif (isinstance(args, list)):
            for i in args:
                rows.append(self.insertrow(i))
        else:
            raise TypeError("insert either a single dict or a list of dicts")
        self.ApplFormDF = self.ApplFormDF.append(rows)

    def read(self,filename):
        self.ApplFormDF = pd.read_csv(filename, index_col=0)

    def save(self,filename):
        return self.ApplFormDF.to_csv(filename)


    def fillRandom(self,nrows):
        global studentDF, collegeDF
        i = 0
        while (i < nrows):
            studentID = studentDF.sample(1).studentID.iloc[0]
            collegeID = collegeDF.sample(1).collegeID.iloc[0]
            # Make sure we don't have this combination already
            if (self.ApplFormDF.loc[(self.ApplFormDF['studentID'] == studentID) & 
                                    (self.ApplFormDF['collegeID'] == collegeID)   , 'visited' ].count() == 0): 
                # add in a new record
                self.ApplFormDF.loc[i] = [studentID, collegeID, 
                                          random.randint(0,1), # earlyAppl
                                          random.randint(0,1), # visited
                                          random.randint(0,1), # acceptStatus
                                          random.random() # acceptProb
                                          ]
                i += 1

class Application:
    """
    Consists of one student and one ApplForm
    """
    def __init__(self):
        return




