
class User:
  def __init__(self, id, username, password, salt):
    self.uid = name
    self.username = title
    self.password = description
    self.salt = done
  def fromJSON(self, dictionary):
    self.uid = dictionary["uid"]
    self.username = dictionary["username"]
    self.password = dictionary["password"]
    self.salt = dictionary["salt"]
    return self
  def toJSON(self):
    return {
      "uid": self.uid,
      "username": self.username,
      "password": self.password,
      "salt": self.salt,
    }