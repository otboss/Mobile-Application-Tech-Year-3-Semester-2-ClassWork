class Task {
  int id;
  String title;
  String description;
  bool done;
  Task({
    this.id,
    this.title,
    this.description,
    this.done,
  });
  Task fromJSON(Map task){
    this.id = int.parse(task["id"]);
    this.description = task["description"];
    this.title = task["title"];
    this.done = task["done"].toString() == "true";
    return this;
  }
}
