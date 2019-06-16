
class Task:
  def __init__(self, id, title, description, done):
    self.id = id
    self.title = title
    self.description = description
    self.done = done
  def fromJSON(self, dictionary):
    self.id = dictionary["id"]
    self.title = dictionary["title"]
    self.description = dictionary["description"]
    self.done = dictionary["done"]
    return self
  def toJSON(self):
    return {
      "id": self.id,
      "title": self.title,
      "description": self.description,
      "done": self.done,
    }