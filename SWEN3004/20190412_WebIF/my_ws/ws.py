#!flask/bin/python
from flask import abort
from flask import Flask, jsonify, request
from flask_httpauth import HTTPBasicAuth
from flask import Response

app = Flask(__name__)

auth = HTTPBasicAuth()

tasks = [
	{
		"id": "1",
		"title": u"Buy groceries",
		"description": u"Milk, Cheese, Pizza, Fruit, Tylenol",
		"done": False
	},
	{
		"id": "2",
		"title": u"Learn Python",
		"description": u"Need to find a good python tutorial on the web",
		"done": False
	}
]

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

@app.route('/todo/api/v1.0/tasks/', methods=['GET'])
@auth.login_required
def get_task():
	task_id = None;
	try:
		task_id = dict(request.args)["task_id"][0];
	except:
		return jsonify({'Error 503':'Missing Parameter task_id'}), 503
	result = [];
	for task in tasks:
		if task["id"] == str(task_id):
			result.append(task)
			break
	if len(result) == 0:
		return jsonify({})
	return jsonify({'task': result[0]})


@app.route('/todo/api/v1.0/tasks/newtask', methods=['POST'])
@auth.login_required
def new_task():
	newtask = dict(request.form)
	try:
		newtask["title"] = newtask["title"][0]
		newtask["description"] = newtask["description"][0]
		newtask["done"] = False
		seq = [task['id'] for task in tasks]
		newtask["id"] = str(int(max(seq)) + 1)
		tasks.append(newtask)
		return "Task added successfully with id#: "+ newtask["id"]+"\n"
	except:
		return "Error while adding task"
		
@app.route('/todo/api/v1.0/tasks/updatetask', methods=['PUT'])
@auth.login_required
def update_task():
	task_to_update = dict(request.form)
	try:
		task_to_update["id"] = task_to_update["id"][0]
		for task_index in range(len(tasks)):
			if tasks[task_index]["id"] == task_to_update["id"]:
				tasks[task_index]["title"] = task_to_update["title"][0]
				tasks[task_index]["description"] = task_to_update["description"][0]		
				return "Task with id#: "+task_to_update["id"]+" updated successfully\n"
		return "no changes made"
	except:
		return "Error while adding task"	
		
@app.route('/todo/api/v1.0/tasks/toggledone', methods=['PUT'])
@auth.login_required
def toggle_task_done():
	task_to_update = dict(request.form)
	try:
		task_to_update["id"] = task_to_update["id"][0]
		for task_index in range(len(tasks)):
			if tasks[task_index]["id"] == task_to_update["id"]:
				if bool(tasks[task_index]["done"]):
					tasks[task_index]["done"] = False
				else:
					tasks[task_index]["done"] = True
				return "Task with id#: "+task_to_update["id"]+" changed to done\n"
		return "no changes made"
	except:
		return "Error while adding task"

@app.route('/todo/api/v1.0/tasks/removetask', methods=['DELETE'])
@auth.login_required
def remove_task():
	task_id = dict(request.form)
	try:
		task_id["id"] = task_id["id"][0]
		for task_index in range(len(tasks)):
			if tasks[task_index]["id"] == task_id["id"]:
				tasks.pop(int(task_id["id"]))
				return "Task with id#: "+task_to_update["id"]+" removed successfully\n"
		return "no changes made"
	except:
		return "Error while adding task"

@auth.error_handler
def unauthorized():
    response = jsonify({'Error 403':'Forbidden'})
    return response, 403

if __name__ == '__main__':
	app.run(debug=False, ssl_context=('cert.pem', 'key.pem'))


	
	

