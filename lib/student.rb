class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    Student.new.tap do |student|
      student.id = row[0]
      student.name = row[1]
      student.grade = row[2]
    end
  end

  def self.all
    sql = "SELECT * FROM students"
    
    DB[:conn].execute(sql).map do |row|
      Student.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM students
    WHERE name = ?
    LIMIT 1
    SQL
    
    student = DB[:conn].execute(sql, name)
    Student.new_from_db(student.first)
  end
  
  def self.count_all_students_in_grade_9
    sql = <<-SQL
    SELECT COUNT(grade) 
    WHERE grade = 9 
    FROM students
    SQL
    
    DB[:conn].execute(sql)
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
