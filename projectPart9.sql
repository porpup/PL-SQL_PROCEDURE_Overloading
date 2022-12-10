SPOOL /tmp/oracle/projectPart9_spool.txt

SELECT
    to_char (sysdate, 'DD Month YYYY Year Day HH:MI:SS AM')
FROM
    dual;

/* Question 1: (des02, script 7Clearwater)
Create a package with OVERLOADING procedure used to insert a new customer. 
The user has the choice of providing either
    a/ Last Name, address
    b/ Last Name, birthdate
    c/ Last Name, First Name, birthdate
    d/ Customer id, last name, birthdate
In case no customer id is provided, please use a number from a sequence 
called customer_sequence. */
CONNECT des02/des02

SET SERVEROUTPUT ON

CREATE OR REPLACE PACKAGE c_package IS
    PROCEDURE c_insert(p_c_last VARCHAR2, p_c_address VARCHAR2);

    PROCEDURE c_insert(p_c_last VARCHAR2, p_c_birthdate DATE);

    PROCEDURE c_insert(p_c_last VARCHAR2, 
                        p_c_first VARCHAR2, 
                        p_c_birthdate DATE);

    PROCEDURE c_insert(p_c_id NUMBER, 
                        p_c_last VARCHAR2, 
                        p_c_birthdate DATE);
END;
/

CREATE SEQUENCE c_id_sequence START WITH 7;

CREATE OR REPLACE PACKAGE BODY c_package IS
    PROCEDURE c_insert(p_c_last VARCHAR2, p_c_address VARCHAR2) AS
    BEGIN
        INSERT INTO CUSTOMER(C_ID,
                            C_LAST,
                            C_ADDRESS
        ) VALUES(
                c_id_sequence.NEXTVAL,
                p_c_last,
                p_c_address
        );
    COMMIT;
    END;

    PROCEDURE c_insert(p_c_last VARCHAR2, p_c_birthdate DATE) AS
    BEGIN
        INSERT INTO CUSTOMER(C_ID,
                            C_LAST,
                            C_BIRTHDATE
        ) VALUES(
                c_id_sequence.NEXTVAL,
                p_c_last,
                p_c_birthdate
        );
    COMMIT;
    END;

    PROCEDURE c_insert(p_c_last VARCHAR2, 
                        p_c_first VARCHAR2, 
                        p_c_birthdate DATE) AS
    BEGIN
        INSERT INTO CUSTOMER(C_ID,
                            C_LAST,
                            C_FIRST,
                            C_BIRTHDATE
        ) VALUES(
                c_id_sequence.NEXTVAL,
                p_c_last,
                p_c_first,
                p_c_birthdate
        );
    COMMIT;
    END;

    PROCEDURE c_insert(p_c_id NUMBER, 
                        p_c_last VARCHAR2, 
                        p_c_birthdate DATE) AS
    BEGIN
        IF p_c_id != NULL THEN
            INSERT INTO CUSTOMER(C_ID,
                            C_LAST,
                            C_BIRTHDATE
            ) VALUES(
                    p_c_id,
                    p_c_last,
                    p_c_birthdate
                    );
        ELSE
            INSERT INTO CUSTOMER(C_ID,
                            C_LAST,
                            C_BIRTHDATE
            ) VALUES(
                    c_id_sequence.NEXTVAL,
                    p_c_last,
                    p_c_birthdate
                    );
        END IF;
    COMMIT;
    END;

END;
/

EXEC c_package.c_insert('Gates', '10000 Wall Street, Apt.100')

EXEC c_package.c_insert('Berners-Lee', DATE '1962-11-23')

EXEC c_package.c_insert('Torvalds', 'Linus', DATE '1954-10-05')


EXEC c_package.c_insert(15, 'Codd', DATE '1971-06-17')

EXEC c_package.c_insert(0, 'Shirley', DATE '1978-05-09')





/* Question 2: (des03, script 7Northwoods)
Create a package with OVERLOADING procedure used to insert a new student. 
The user has the choice of providing either
    a/ Student id, last name, birthdate
    b/ Last Name, birthdate
    c/ Last Name, address
    d/ Last Name, First Name, birthdate, faculty id
In case no student id is provided, please use a number from a sequence 
called student_sequence.
Make sure that the package with the overloading procedure is user 
friendly enough to handle error such as:
    - Faculty id does not exist
    - Student id provided already existed
    - Birthdate is in the future */
CONNECT des03/des03

SET SERVEROUTPUT ON

CREATE OR REPLACE PACKAGE s_package IS
    PROCEDURE s_insert(p_s_id NUMBER,
                        p_s_last VARCHAR2,
                        p_s_dob DATE);

    PROCEDURE s_insert(p_s_last VARCHAR2, p_s_dob DATE);

    PROCEDURE s_insert(p_s_last VARCHAR2, p_s_address VARCHAR2);

    PROCEDURE s_insert(p_s_last VARCHAR2,
                        p_s_first VARCHAR2,
                        p_s_dob DATE,
                        p_f_id NUMBER);
END;
/

CREATE SEQUENCE s_id_sequence START WITH 7;

CREATE OR REPLACE PACKAGE BODY s_package IS
    PROCEDURE s_insert(p_s_id NUMBER,
                        p_s_last VARCHAR2,
                        p_s_dob DATE) AS
    existing_s_id NUMBER;
    BEGIN
        SELECT
            COUNT(*) INTO existing_s_id
        FROM
            STUDENT
        WHERE
            S_ID = p_s_id;

        IF existing_s_id <= 0 THEN
            IF p_s_id != NULL THEN
                INSERT INTO STUDENT(S_ID,
                                S_LAST,
                                S_DOB
                ) VALUES(
                        p_s_id,
                        p_s_last,
                        p_s_dob
                        );
            ELSE
                INSERT INTO STUDENT(S_ID,
                                S_LAST,
                                S_DOB
                ) VALUES(
                        s_id_sequence.NEXTVAL,
                        p_s_last,
                        p_s_dob
                        );
            END IF;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Student ID already EXISTS!');
        END IF;
    COMMIT;
    END;

    PROCEDURE s_insert(p_s_last VARCHAR2, p_s_dob DATE) AS
    BEGIN
        IF (TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - TO_NUMBER(TO_CHAR(p_s_dob, 'YYYY'))) >= 16 THEN
            INSERT INTO STUDENT(S_ID,
                                S_LAST,
                                S_DOB
            ) VALUES(
                    s_id_sequence.NEXTVAL,
                    p_s_last,
                    p_s_dob
            );
        ELSE
            DBMS_OUTPUT.PUT_LINE('Too young to be a student!');
        END IF;
    COMMIT;
    END;

    PROCEDURE s_insert(p_s_last VARCHAR2, p_s_address VARCHAR2) AS
    BEGIN
        INSERT INTO STUDENT(S_ID,
                            S_LAST,
                            S_ADDRESS
        ) VALUES(
                s_id_sequence.NEXTVAL,
                p_s_last,
                p_s_address
        );
    COMMIT;
    END;

    PROCEDURE s_insert(p_s_last VARCHAR2,
                        p_s_first VARCHAR2,
                        p_s_dob DATE,
                        p_f_id NUMBER) AS
    existing_f_id NUMBER;
    BEGIN
        SELECT
            COUNT(*) INTO existing_f_id
        FROM
            FACULTY
        WHERE
            F_ID = p_f_id;

        IF existing_f_id > 0 THEN
            IF (TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - TO_NUMBER(TO_CHAR(p_s_dob, 'YYYY'))) >= 16 THEN
                INSERT INTO STUDENT(S_ID,
                                    S_LAST,
                                    S_FIRST,
                                    S_DOB,
                                    F_ID
                ) VALUES(
                        s_id_sequence.NEXTVAL,
                        p_s_last,
                        p_s_first,
                        p_s_dob,
                        p_f_id
                );
            ELSE
                DBMS_OUTPUT.PUT_LINE('Too young to be a student!');
            END IF;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Faculty ID DOESN''T EXIST!');
        END IF;
    COMMIT;
    END;

END;
/

EXEC s_package.s_insert(0, 'Gates', DATE '1962-11-23')

EXEC s_package.s_insert(15, 'Mask', DATE '1966-11-29')


EXEC s_package.s_insert('Bezos', DATE '2023-12-01')

EXEC s_package.s_insert('Bezos', DATE '2017-12-01')

EXEC s_package.s_insert('Bezos', DATE '1959-12-01')


EXEC s_package.s_insert('Buffet', '123 Main Street')


EXEC s_package.s_insert('Zuckerberg', 'Mark', DATE '1980-09-09', 1)

EXEC s_package.s_insert('Zuckerberg', 'Mark', DATE '1980-09-09', 100)

EXEC s_package.s_insert('Zuckerberg', 'Mark', DATE '2022-09-09', 2)


SPOOL OFF;