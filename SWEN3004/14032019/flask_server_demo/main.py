from flask import Flask
from flask import request
import mysql.connector
import ast

db = mysql.connector.connect(
  host="localhost",
  user="root",
  passwd=""
)


dbInterface = db.cursor()


app = Flask(__name__)

temporaryStorage = []

@app.route('/', methods=['GET', 'POST', 'PUT', 'DELETE'])
def storage():
    print(request.method)
    if(request.method == "GET"):
        return "\n\nHello World!, You made a GET request. CONTENTS: \n\n"+str(temporaryStorage)+"\n\n"
    if(request.method == "POST"):
        temporaryStorage.append(request.data)
        return "\n\nYou made a POST request. The following data was added successfully: \n\n"+str(request.data)+"\n\n"
    if(request.method == "PUT"):
        try:
            request.data = ast.literal_eval(request.data)
            temporaryStorage[request.data["index"]] = request.data["value"]
        except:
            return "Invalid index selected. Here is the contents of the storage: \n\n"+str(temporaryStorage)+"\n\n"+"Please select an valid index to UPDATE\n"
        return "\n\nYou made a PUT request. index "+str(request.data["index"])+" updated to "+str(request.data["value"])+" successfully.\n\n"
    if(request.method == "DELETE"):
        try:
            temporaryStorage.pop(request.data["index"])
        except:
            return "Invalid index selected. Here is the contents of the storage: \n\n"+str(temporaryStorage)+"\n\n"+"Please select an valid index to DELETE\n"        
        return "\n\nYou made a DELETE request. index "+str(request.data["index"])+" deleted successfully.\n\n"


@app.route('/createdatabase', methods=['GET'])
def initDB():
    databaseName = request.data
    dbInterface.execute("CREATE DATABASE "+databaseName)
    return "DATABASE "+databaseName+" created successfully"


if __name__ == '__main__':
    app.run()