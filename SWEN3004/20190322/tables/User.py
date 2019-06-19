from sqlalchemy import Column, Integer, String
from sqlalchemy.ext.declarative import declarative_base
Base = declarative_base()

class User(Base):
  __tablename__ = 'users'
  uid = Column(Integer, primary_key=True)
  usrname = Column(String)
  pwd = Column(String)
  slt = Column(String)
  ts = Column(String)
  def __repr__(self):
    return {
      "User": {
        "id": self.id,
        "usrname": self.usrname,
        "pwd": self.pwd,
        "slt": self.slt,
        "ts": self.ts,
      }
    }  

