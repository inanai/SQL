-- 1. Напишите один запрос с использованием псевдонимов для таблиц и их полей, 
--    выбирающий все возможные комбинации городов (CITY) из таблиц 
--    STUDENTS, LECTURERS и UNIVERSITIES
-- строки не должны повторяться, убедитесь в выводе только уникальных троек городов

select distinct s.CITY as studentCity, l.CITY as lecturerCity, u.CITY as universityCity
from STUDENTS s, LECTURERS l, UNIVERSITIES u

-- 2. Напишите запрос для вывода полей в следущем порядке: семестр, в котором он
--    читается, идентификатора (номера ID) предмета обучения, его наименования и 
--    количества отводимых на этот предмет часов для всех строк таблицы SUBJECTS

select SEMESTER, ID, NAME, [HOURS]
from SUBJECTS

-- 3. Выведите все строки таблицы EXAM_MARKS, в которых предмет обучения SUBJ_ID равен 4

select *
from EXAM_MARKS
where SUBJ_ID = 4

-- 4. Необходимо выбирать все данные, в следующем порядке 
--    Стипендия, Курс, Фамилия, Имя  из таблицы STUDENTS, причем интересуют
--    студенты, родившиеся после '1993-07-21'

select STIPEND, COURSE, SURNAME, NAME
from STUDENTS
where BIRTHDAY > '1993-07-21'

-- 5. Вывести на экран все предметы: их наименования и кол-во часов для каждого из них
--    в 1-м семестре и при этом кол-во часов не должно превышать 40

select NAME, HOURS
from SUBJECTS
where SEMESTER = 1
and HOURS <= 40

-- 6. Напишите запрос, позволяющий получить из таблицы EXAM_MARKS уникальные 
--    значения экзаменационных оценок всех студентов, которые сдавали
--    экзамены '2012-06-11'

select distinct MARK
from EXAM_MARKS
where EXAM_DATE = '2012-06-11'

-- 7. Выведите список фамилий студентов, обучающихся на третьем и последующих 
--    курсах и при этом проживающих не в Киеве, не Харькове и не Львове.

select SURNAME
from STUDENTS
where COURSE >= 3
 and CITY not in ('Киев', 'Харьков', 'Львов')

select SURNAME
from STUDENTS
where COURSE >= 3
 and CITY <> 'Киев' and CITY <> 'Харьков' and CITY <> 'Львов'

-- 8. Покажите данные о фамилии, имени и номере курса для студентов, 
--    получающих стипендию в диапазоне от 400 до 650, не включая 
--    эти граничные суммы. Приведите несколько вариантов решения этой задачи.

select SURNAME, NAME, COURSE
from STUDENTS
where STIPEND between 401 and 649

select SURNAME, NAME, COURSE
from STUDENTS
where STIPEND > 401 and STIPEND < 649

-- 9. Напишите запрос, выполняющий выборку из таблицы LECTURERS всех фамилий
--    преподавателей, проживающих во Львове, либо же преподающих в университете
--    с идентификатором 14

select SURNAME
from LECTURERS
where CITY = 'Львов'
or UNIV_ID = 14

-- 10. Выясните в каких городах расположены университеты, рейтинг которых 
--     состовляет 500 +/- 50 баллов.

select CITY 
from UNIVERSITIES
where RATING > 450 and RATING < 550

select CITY 
from UNIVERSITIES
where RATING between 450 and 550

-- 11. Отобрать список фамилий киевских студентов, их имен и дат рождений 
--     для всех нечетных курсов.

select SURNAME, NAME, BIRTHDAY, COURSE
from STUDENTS
where COURSE % 2 = 1
  and CITY = 'Киев'

-- 12. Упростите выражение фильтрации и дайте логическую формулировку запроса?
-- SELECT * FROM STUDENTS WHERE (STIPEND < 500 OR NOT (BIRTHDAY >= '1993-01-01' AND ID > 9))

Выведите все строки таблицы STUDENTS, где стипендия меньше 500, или дата рождения меньше 1993-01-01, или ID меньше 9 включительно.

Выведите все строки таблицы STUDENTS, где стипендия меньше 500, или дата рождения меньше 1993-01-01, или ID меньше 9 включительно.

SELECT * FROM STUDENTS WHERE NOT (BIRTHDAY >= '1993-01-01' AND ID > 9)) = 

= SELECT * FROM STUDENTS WHERE STIPEND < 500 OR BIRTHDAY < '1993-01-01' OR ID <= 9


-- 13. Упростите выражение фильтрации и дайте логическую формулировку запроса?
-- SELECT * FROM STUDENTS WHERE NOT ((BIRTHDAY = '1993-06-07' OR STIPEND > 500) AND ID >= 9)

Выведите все строки таблицы STUDENTS, где дата рождения не равна 1993-01-01, стипендия меньше 500 включительно, или ID меньше 9.

SELECT * FROM STUDENTS WHERE NOT ((BIRTHDAY = '1993-06-07' OR STIPEND > 500) AND ID >= 9) =

= SELECT * FROM STUDENTS WHERE NOT (BIRTHDAY = '1993-06-07' OR STIPEND > 500) OR ID < 9 =

= SELECT * FROM STUDENTS WHERE BIRTHDAY <> '1993-06-07' AND STIPEND <= 500 OR ID < 9