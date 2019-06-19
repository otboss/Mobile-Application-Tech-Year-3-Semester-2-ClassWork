from sqlalchemy import create_engine, Table, Column, Integer, String, MetaData, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
Base = declarative_base()

engine = create_engine("mysql://user:@localhost/task_fetcher",echo = True)
metadata = MetaData()

usersTable = Table("users", metadata,
  Column("uid", Integer, primary_key=True),
  Column("usrname", String(50)),
  Column("pwd", String(100)),
  Column("slt", String(50)),
);

tasksTable = Table("tasks", metadata,
  Column("tid", Integer, primary_key=True),
  Column("uid", Integer),
  Column("title", String(100)),
  Column("description", String(255)),
  Column("done", Integer),
);