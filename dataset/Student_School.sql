  
    CREATE TABLE Student (
      student_id INT,
      student_name VARCHAR(255),
      city VARCHAR(255),
      school_id INT,
      GPA FLOAT
    );


    INSERT INTO Student (student_id, student_name,city, school_id, GPA) VALUES (1001, 'Peter Brebec', 'New York', 1, 4.0), (1002, 'John Goorgy', 'San Francisco', 2, 3.1), (2003, 'Brad Smith', 'New York', 3, 2.9), (1004, 'Fabian Johns', 'Boston', 5, 2.1), (1005, 'Brad Cameron', 'Stanford', 1, 2.3), (1006, 'Geoff Firby', 'Boston', 5, 1.2), (1007, 'Johnny Blue', 'New Haven', 2, 3.8), (1008, 'Johse Brook', 'Miami', 2, 3.4);

  
    CREATE TABLE School (
      school_id INT,
      school_name VARCHAR(255),
      city VARCHAR(255)
    );


    INSERT INTO School (school_id, school_name, city) VALUES (1.0, 'Stanford', 'Stanford'), (2.0, 'University of California', 'San Francisco'), (3.0, 'Harvard University', 'New York'), (4.0, 'MIT', 'Boston'), (5.0, 'Yale', 'New Haven'), (6.0, 'University of Westminster', 'London'), (7.0, 'Corvinus University', 'Budapest');

