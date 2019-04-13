#!flask/bin/python
from flask import abort
from flask import Flask, jsonify, request

app = Flask(__name__)

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

@app.route('/todo/api/v1.0/tasks', methods=['GET'])
def get_tasks():
	return jsonify({'tasks': tasks})

@app.route('/todo/api/v1.0/tasks/<int:task_id>', methods=['GET'])
def get_task(task_id):
	result = [];
	for task in tasks:
		if task["id"] == str(task_id):
			result.append(task)
			break
	if len(result) == 0:
		abort(404)
	return jsonify({'task': result[0]})

@app.route('/todo/api/v1.0/tasks/newtask', methods=['POST'])
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

if __name__ == '__main__':
	app.run(debug=True)


	
	

