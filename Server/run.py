import os

os.environ['FLASK_APP'] = "banweb.py"
os.environ['FLASK_DEBUG'] = "1"

local_path = os.path.dirname(os.path.realpath(__file__))

if not os.path.isfile(local_path + "/banweb.db"):
    os.system('flask initdb')
    os.system('flask populate')

os.system('flask run')
