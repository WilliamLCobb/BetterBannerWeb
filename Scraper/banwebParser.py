from bs4 import BeautifulSoup
from tidylib import tidy_document

### Constants ###
validClasses = ['BADM', 'WOMS', 'BCMB', 'GEOL', 'ITAL', 'EDUC', 'INTP', 'MILS', 'NAVY', 'PHED', 'PLEC', 'AFAM', 'AFST', 'AMST', 'ASTD', 'ASHU', 'ASSC', 'ENSC', 'ENST', 'FILM', 'AERO', 'ANSO', 'ARCE', 'ART', 'BMB', 'BIOL', 'CHEM', 'CHIN', 'BUS', 'COMP', 'ECON', 'ENGL', 'ENVS', 'FYWS', 'FREN', 'GSST', 'GRMN', 'GREK', 'GRRO', 'HEBR', 'HIST', 'HUM', 'INTD', 'INTS', 'LATN', 'LTNS', 'MATH', 'LANG', 'MUSC', 'NEUR', 'PHIL', 'PHYS', 'POLS', 'PSYC', 'RELS', 'RUSS', 'SPAN', 'THEA', 'URBN']

### Classes ###

class EnrolledClass(object):
    def __init__(self, id, number, type, name, credits, gpa=None):
        self.id = id
        self.number = number
        self.type = type
        self.name = name
        self.credits = credits
        self.gpa = gpa

    def __str__(self):
        if (self.gpa):
            return '<Class: {0:<6} {1:<5} {2:<3} {3:>5}>'.format(self.id, self.number, self.gpa, self.name)
        return '<Class: {0:<6} {1:<5} {2:>5}>'.format(self.id, self.number, self.name)

### Callables ###

def classesFromTranscript(html):
    tidy, errors = tidy_document(html)
    soup = BeautifulSoup(tidy, "html.parser")
    # parse
    enrolledClasses = []
    for table in soup.find_all('table'):
        classes = table['class']
        if (len(classes) > 0 and classes[0] == "datadisplaytable"):
            for row in table.find_all('tr'):
                strings = list(row.stripped_strings)
                if (len(strings) > 0):
                    classId = strings[0]
                    if (classId in validClasses):
                        #print strings
                        if (len(strings) == 6):  # AP/transfered class
                            newClass = EnrolledClass(id=classId, number=strings[1], type=strings[3], name=deCap(strings[2]), credits=strings[4])
                            enrolledClasses.append(newClass)
                        elif (len(strings) == 7):  # Completed Class
                            newClass = EnrolledClass(id = classId, number=strings[1], type=strings[2], name=deCap(strings[3]), credits=strings[5], gpa=strings[4])
                            enrolledClasses.append(newClass)
                        elif (len(strings) == 5): #Current Class
                            newClass = EnrolledClass(id = classId, number=strings[1], type=strings[2], name=deCap(strings[3]), credits=strings[4])
                            enrolledClasses.append(newClass)

    return enrolledClasses


### Utilities ###
def deCap(str):
    newStr = str.lower().title()
    #Make this regex
    newStr = newStr.replace('ii', 'II')
    newStr = newStr.replace('Ii', 'II')
    return newStr.replace('Iv', 'IV')