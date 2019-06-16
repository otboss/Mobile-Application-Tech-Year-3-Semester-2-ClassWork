require "active_record";

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => "../task_fetcher.db")

class Task < ActiveRecord::Base
  def getTask(title_substring)
    #TODO:implement code fetch a task from the database using the substring
  end
end