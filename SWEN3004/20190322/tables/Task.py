from sqlalchemy import Column, Integer, String
from sqlalchemy.ext.declarative import declarative_base
Base = declarative_base()

class Task(Base):
  __tablename__ = 'tasks'
  tid = Column(Integer, primary_key=True)
  title = Column(String)
  description = Column(String)
  done = Column(Integer)
  ts = Column(String)
  def __repr__(self):
    return {
      "Task": {
        "tid": self.tid,
        "title": self.title,
        "description": self.description,
        "done": self.done,
        "ts": self.ts,
      }
    }

  