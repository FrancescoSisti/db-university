-- 1. Selezionare tutti gli studenti iscritti al Corso di Laurea in Economia
SELECT *
FROM students
JOIN degrees ON students.degree_id = degrees.id
WHERE degrees.name = 'Corso di Laurea in Economia';

-- 2. Selezionare tutti i Corsi di Laurea Magistrale del Dipartimento di Neuroscienze
SELECT degrees.*
FROM degrees
JOIN departments ON degrees.department_id = departments.id
WHERE departments.name = 'Dipartimento di Neuroscienze'
AND degrees.level = 'magistrale';

-- 3. Selezionare tutti i corsi in cui insegna Fulvio Amato (id=44)
SELECT courses.*
FROM courses
JOIN course_teacher ON courses.id = course_teacher.course_id
WHERE course_teacher.teacher_id = 44;

-- 4. Selezionare tutti gli studenti con i dati relativi al corso di laurea a cui sono iscritti e il relativo dipartimento, in ordine alfabetico per cognome e nome
SELECT students.*, degrees.name AS degree_name, departments.name AS department_name
FROM students
JOIN degrees ON students.degree_id = degrees.id
JOIN departments ON degrees.department_id = departments.id
ORDER BY students.surname, students.name;

-- 5. Selezionare tutti i corsi di laurea con i relativi corsi e insegnanti
SELECT degrees.name AS degree_name, courses.name AS course_name, teachers.name AS teacher_name, teachers.surname AS teacher_surname
FROM degrees
JOIN courses ON degrees.id = courses.degree_id
JOIN course_teacher ON courses.id = course_teacher.course_id
JOIN teachers ON course_teacher.teacher_id = teachers.id;

-- 6. Selezionare tutti i docenti che insegnano nel Dipartimento di Matematica (54)
SELECT DISTINCT teachers.*
FROM teachers
JOIN course_teacher ON teachers.id = course_teacher.teacher_id
JOIN courses ON course_teacher.course_id = courses.id
JOIN degrees ON courses.degree_id = degrees.id
WHERE degrees.department_id = 54;

-- 7. BONUS: Selezionare per ogni studente il numero di tentativi sostenuti per ogni esame, stampando anche il voto massimo. Successivamente, filtrare i tentativi con voto minimo 18.
SELECT 
    students.id AS student_id,
    students.name AS student_name,
    students.surname AS student_surname,
    courses.id AS course_id,
    courses.name AS course_name,
    COUNT(*) AS num_attempts,
    MAX(exam_student.vote) AS max_vote
FROM 
    students
JOIN exam_student ON students.id = exam_student.student_id
JOIN exams ON exam_student.exam_id = exams.id
JOIN courses ON exams.course_id = courses.id
GROUP BY 
    students.id, students.name, students.surname, courses.id, courses.name
HAVING 
    MAX(exam_student.vote) >= 18
ORDER BY 
    students.surname, students.name, courses.name;

-- 1. Contare quanti iscritti ci sono stati ogni anno
SELECT YEAR(enrolment_date) AS anno_iscrizione, COUNT(*) AS numero_iscritti
FROM students
GROUP BY YEAR(enrolment_date)
ORDER BY anno_iscrizione;

-- 2. Contare gli insegnanti che hanno l'ufficio nello stesso edificio
SELECT office_address, COUNT(*) AS numero_insegnanti
FROM teachers
GROUP BY office_address
HAVING numero_insegnanti > 1
ORDER BY numero_insegnanti DESC;

-- 3. Calcolare la media dei voti di ogni appello d'esame
SELECT 
    exams.id AS exam_id,
    courses.name AS course_name,
    AVG(exam_student.vote) AS media_voti
FROM 
    exams
JOIN exam_student ON exams.id = exam_student.exam_id
JOIN courses ON exams.course_id = courses.id
GROUP BY 
    exams.id, courses.name
ORDER BY 
    courses.name, exams.id;

-- 4. Contare quanti corsi di laurea ci sono per ogni dipartimento
SELECT 
    departments.name AS department_name,
    COUNT(*) AS numero_corsi_laurea
FROM 
    departments
JOIN degrees ON departments.id = degrees.department_id
GROUP BY 
    departments.id, departments.name
ORDER BY 
    numero_corsi_laurea DESC;
