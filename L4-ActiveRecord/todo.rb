require "active_record"

class Todo < ActiveRecord::Base
  # To check if due_date is due_today
  def due_today?
    due_date == Date.today
  end
 
  #This returns an array of overdue todos
  def self.overdue
    all.where("due_date < ?", Date.today)
  end
  #This returns an array of due_today todos
  def self.due_today
    all.where("due_date = ?", Date.today)
  end
  #This returns an array of due_later todos
  def self.due_later
    all.where("due_date > ?", Date.today)
  end
  #This prints todos from the database in the given format:
  def self.show_list
    puts "My Todo-list\n\n"

    puts "Overdue\n"
    puts to_displayable_list(overdue)
    puts "\n\n"

    puts "Due Today\n"
    puts to_displayable_list(due_today)
    puts "\n\n"

    puts "Due Later\n"
    puts to_displayable_list(due_later)
    puts "\n\n"
  end

  # This is used to display a todo in string format
  def to_displayable_string
    display_id = format("%02d", "#{id}")
    display_status = completed ? "[X]" : "[ ]"
    display_date = due_today? ? nil : due_date
    "#{display_id}. #{display_status} #{todo_text} #{display_date}"
  end

  # This is used to add a new todo
  def self.add_task(todo)
    self.create!(todo_text: todo[:todo_text], due_date: Date.today + todo[:due_in_days],completed: false)
  end
# This is used to  mark a todo status completed
  def self.mark_as_complete!(todo_id)
    todo = self.find_by_id(todo_id)
    if(todo.nil?)
      puts "No id found"
      exit(0)
    else
       if (!todo.completed)
        todo.completed = true
        todo.save
       end
       return todo
    end
  end

# This is used to display all todos

  def self.to_displayable_list(todos)
    todos.map { |todo| todo.to_displayable_string }
  end
end
