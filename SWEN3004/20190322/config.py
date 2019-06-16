from sqlalchemy import create_engine, Table, Column, Integer, String, MetaData, ForeignKey

engine = create_engine('mysql+pymysql://otto:otto@localhost/', echo=True)

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