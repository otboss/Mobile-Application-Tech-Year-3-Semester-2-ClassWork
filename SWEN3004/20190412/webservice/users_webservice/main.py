from flask import Flask
from flask import request
from flask_httpauth import HTTPBasicAuth
from flask import Response
import ast

app = Flask(__name__)


auth = HTTPBasicAuth()

temporaryStorage = []

accounts = {
    "otboss": "password"
}

@auth.get_password
def get_password(username):
    try:
        return accounts[username]
    except:
        return None

@auth.error_handler
def unauthorized():
    return Response("{'error':'Unauthorized Access'}", status=403, mimetype='application/json')

@auth.verify_password
def login(username, password):
	try:
		data = request.args
		if(data["username"] in accounts):
			if(accounts[data["username"]] == data["password"]):
				return True
		return False
	except:
		return False

@app.route('/api/get', methods=['GET', 'POST', 'PUT', 'DELETE'])
@auth.login_required
def storage():
    if(request.method == "GET"):
        return "\n\nHello World!, You made a GET request. CONTENTS: \n\n"+str(temporaryStorage)+"\n\n"

@app.route('/api/post', methods=['POST'])
@auth.login_required
def post():
    temporaryStorage.append(request.data)
    return "\n\nYou made a POST request. The following data was added successfully: \n\n"+str(request.data)+"\n\n"

@app.route('/api/put', methods=['PUT'])
@auth.login_required
def put():
    try:
        request.data = ast.literal_eval(request.data)
        temporaryStorage[request.data["index"]] = request.data["value"]
    except:
        return "Invalid index selected. Here is the contents of the storage: \n\n"+str(temporaryStorage)+"\n\n"+"Please select an valid index to UPDATE\n"
    return "\n\nYou made a PUT request. index "+str(request.data["index"])+" updated to "+str(request.data["value"])+" successfully.\n\n"    

@app.route('/api/delete', methods=['DELETE'])
@auth.login_required
def delete():
    try:
        temporaryStorage.pop(request.data["index"])
    except:
        return "Invalid index selected. Here is the contents of the storage: \n\n"+str(temporaryStorage)+"\n\n"+"Please select an valid index to DELETE\n"
    return "\n\nYou made a DELETE request. index "+str(request.data["index"])+" deleted successfully.\n\n"


if __name__ == '__main__':
    app.run(ssl_context=('cert.pem', 'key.pem'))

