# PL-SQL_PROCEDURE_Overloading

#### Question 1: (des02, script 7Clearwater)
Create a package with OVERLOADING procedure used to insert a new customer. The user has the choice of providing either
<br>&nbsp;&nbsp;&nbsp;&nbsp;a. Last Name, address
<br>&nbsp;&nbsp;&nbsp;&nbsp;b. Last Name, birthdate
<br>&nbsp;&nbsp;&nbsp;&nbsp;c. Last Name, First Name, birthdate
<br>&nbsp;&nbsp;&nbsp;&nbsp;d. Customer id, last name, birthdate
<br>In case no customer id is provided, please use a number from a sequence called customer_sequence.
#### Question 2: (des03, script 7Northwoods)
Create a package with OVERLOADING procedure used to insert a new student. The user has the choice of providing either
<br>&nbsp;&nbsp;&nbsp;&nbsp;a/ Student id, last name, birthdate
<br>&nbsp;&nbsp;&nbsp;&nbsp;b/ Last Name, birthdate
<br>&nbsp;&nbsp;&nbsp;&nbsp;c/ Last Name, address
<br>&nbsp;&nbsp;&nbsp;&nbsp;d/ Last Name, First Name, birthdate, faculty id
<br>In case no student id is provided, please use a number from a sequence called student_sequence.
Make sure that the package with the overloading procedure is user friendly enough to handle error such as:
- Faculty id does not exist
- Student id provided already existed
- Birthdate is in the future
