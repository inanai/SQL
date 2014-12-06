-- 1. Проведена реформа образования: стипендия студентам 1, 2 курса увеличена на 20%, 
--    4 и 5 курсов - уменьшена на 10%, 3-курсников оставлена без изменений. 
--    Cоставьте запрос к таблице STUDENTS, выводящиий номера студента, фамилию и 
--    величину “новой” стипендии. Выходные данные упорядочить по убыванию в 
--    алфавитном порядке фамилий студентов, затем по убыванию значения новой 
--    вычисленной стипендии.

select ID, SURNAME, STIPEND,
	CASE
    WHEN COURSE in (1, 2) THEN STIPEND + STIPEND * 0.2
	WHEN COURSE in (4, 5) THEN STIPEND - STIPEND * 0.1
	ELSE STIPEND
    END as DIF_STIPEND
from STUDENTS
order by SURNAME DESC, DIF_STIPEND DESC


-- 2. Напишите запрос, который по таблице EXAM_MARKS позволяет найти промежуток времени,
--    который занял у студента в течении его сессии (разница дат в днях), кол-во сданных 
--    экзаменов, а также их максимальные и минимальные оценки. 
--    В выборке дожлен присутствовать идентификатор студента.

select STUDENT_ID, DATEDIFF(day, MIN(EXAM_DATE), MAX(EXAM_DATE)) as SESSION_DAYS
from EXAM_MARKS
group by STUDENT_ID


-- 3. Напишите запрос для таблицы EXAM_MARKS, выдающий даты, для которых средний балл 
--    находиться в диапазоне от 4.22 до 4.77. Формат даты для вывода на экран: 
--    день месяць, например, 05 Jun.

select CONVERT(char(6), EXAM_DATE, 6) as DAT
from EXAM_MARKS
group by EXAM_DATE
having AVG(MARK) between 4.22 and 4.77


-- 4. Напишите запрос, отображающий список предметов обучения, вычитываемых за самый короткий 
--    промежуток времени, отсортированный в порядке убывания семестров. Поле семестра в 
--    выходных данных должно быть первым, за ним должны следовать наименование и 
--    идентификатор предмета обучения.

select SEMESTER, NAME, ID
from SUBJECTS S1
where [HOURS] = (select MIN([HOURS]) from SUBJECTS S2 where S1.SEMESTER = S2.SEMESTER)
order by SEMESTER DESC


-- 5. Напишите запрос с подзапросом для получения данных обо всех положительных оценках(4, 5) Марины 
--    Шуст (предположим, что ее персональный номер неизвестен), идентификаторов предметов и дат 
--    их сдачи.

select MARK, SUBJ_ID, EXAM_DATE
from EXAM_MARKS
where Mark in (4, 5) and STUDENT_ID = (select ID from STUDENTS where NAME = 'Марина' and SURNAME = 'Шуст')


-- 6. Покажите сумму баллов, а также среднее арифметическое между максимальной 
--    и минимальной оценкой для всех студентов 5-го курса каждой даты сдачи экзаменов. 
--    Результат выведите в порядке убывания сумм баллов, а дату в формате dd/mm/yyyy.

select SUM(MARK) as SUM_MARK, (MAX(MARK)+MIN(MARK))/2 as AVG_MIN_MAX_MARK, CONVERT(varchar, EXAM_DATE, 101)
from EXAM_MARKS
where STUDENT_ID in (select ID from STUDENTS where COURSE = 5)
group by EXAM_DATE
order by EXAM_DATE DESC


-- 7. Покажите имена всех студентов, имеющих средний балл этого студента 
--    по предметам с идентификаторами 1 и 2, который превышает средний балл 
--    того же студента по всем остальным предметам. 
--    Используйте вложенный подзапрос.

select NAME
from STUDENTS
where ID in 
	(select STUDENT_ID
	from EXAM_MARKS EX1
	where SUBJ_ID in (1,2)
	group by STUDENT_ID
	having AVG(MARK) >
		(select AVG(MARK)
		from EXAM_MARKS EX2
		where SUBJ_ID not in (1,2) and EX1.STUDENT_ID = EX2.STUDENT_ID))


-- 8. Напишите запрос, выполняющий вывод общего суммарного и среднего баллов каждого 
--    экзаменованого второкурсника, при условии, что он успешно сдал 3 и больше предметов.

select SUM(MARK) as AMOUNT, AVG(MARK) as AVG_AMOUNT 
from EXAM_MARKS
where STUDENT_ID in (select ID from STUDENTS where COURSE = 2) and MARK >=3
group by STUDENT_ID
having COUNT(*) >= 3


-- 9. Напишите запрос к таблице SUBJECTS, выдающий названия всех предметов, средний балл
--    которых превышает средний балл по всем предметам университетов г.Днепропетровска. 
--    Используйте вложенный подзапрос.

select NAME
from SUBJECTS
where ID in
	(select SUBJ_ID 
	from EXAM_MARKS 
	group by SUBJ_ID
	having AVG(MARK) > 
		(select AVG(MARK)
		from EXAM_MARKS
		where STUDENT_ID in
			(select ID
			from STUDENTS
			where UNIV_ID in
				(select ID
				from UNIVERSITIES
				where CITY = 'Днепропетровск'))))