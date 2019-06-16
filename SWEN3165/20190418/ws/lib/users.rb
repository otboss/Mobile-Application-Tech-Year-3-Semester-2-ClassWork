require "active_record";

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => "../task_fetcher.db")

class User < ActiveRecord::Base
  def login(username, password)
    #TODO:implement code to query database and return boolean if found
  end
  def register(username, password)
    #TODO:implement code to add a new user the database
  end
end