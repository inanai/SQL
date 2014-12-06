-- 1. Напишите запрос с EXISTS, позволяющий вывести данные обо всех студентах, 
--    обучающихся в вузах с рейтингом не попадающим в диапазон от 488 до 571

select NAME, SURNAME
from STUDENTS S
where not exists
	(select 1
	from UNIVERSITIES
	where (RATING between 488 and 571) and ID = S.ID)


-- 2. Напишите запрос с EXISTS, выбирающий всех студентов, для которых в том же городе, 
--    где живет и учится студент, существуют другие университеты, в которых он не учится.

select NAME, SURNAME
from STUDENTS S
where not exists
	(select 1
	from UNIVERSITIES U
	where S.CITY = U.CITY)


-- 3. Напишите запрос, выбирающий из таблицы SUBJECTS данные о названиях предметов обучения, 
--    по которым были сданы экзамены более чем 12 студентами, за первые 10 дней сессии. 
--    Используйте EXISTS. Примечание: по возможности выходная выборка не должна учитывать
--    пересдач.

select NAME
from SUBJECTS
where exists
	(select 


-- 4. Напишите запрос EXISTS, выбирающий фамилии всех лекторов, преподающих в университетах
--    с рейтингом, превосходящим рейтинг каждого харьковского универа.

select SURNAME
from LECTURERS L
where exists
	(select 1
	from UNIVERSITIES U
	where U.ID = L.UNIV_ID and RATING > all
		(select RATING from UNIVERSITIES where CITY = 'Харьков'))


-- 5. Напишите 2 запроса, использующий ANY и ALL, выполняющий выборку данных о студентах, 
--    у которых в городе их постоянного местожительства нет университета.

select NAME, SURNAME
from STUDENTS S
where S.CITY <> all
	(select U.CITY from UNIVERSITIES U)

select NAME, SURNAME
from STUDENTS S
where not S.CITY = any
	(select U.CITY from UNIVERSITIES U)


-- 6. Напишите запрос выдающий имена и фамилии студентов, которые получили
--    максимальные оценки в первый и последний день сессии.
--    Подсказка: выборка должна содержать по крайне мере 2х студентов.
		
select NAME, SURNAME
from STUDENTS S
where exists 
	(select 1 
	from EXAM_MARKS M 
	where M.STUDENT_ID = S.ID and 
		(
			(
				MARK = (select MAX(MARK) from EXAM_MARKS where EXAM_DATE = (select MIN(EXAM_DATE) from EXAM_MARKS))
				and
				EXAM_DATE = (select MIN(EXAM_DATE) from EXAM_MARKS)
			)
			or
			(
				MARK = (select MAX(MARK) from EXAM_MARKS where EXAM_DATE = (select MAX(EXAM_DATE) from EXAM_MARKS))
				and
				EXAM_DATE = (select MAX(EXAM_DATE) from EXAM_MARKS)
			)
		))


-- 7. Напишите запрос EXISTS, выводящий кол-во студентов каждого курса, которые успешно 
--    сдали экзамены, и при этом не получивших ни одной двойки.

select COURSE, COUNT(*) as QUANTITY
from STUDENTS S
where exists
	(select 1
	from EXAM_MARKS EM
	where MARK >=3 and S.ID = EM.STUDENT_ID)
group by COURSE


-- 8. Напишите запрос EXISTS на выдачу названий предметов обучения, 
--    по которым было получено максимальное кол-во оценок.

select NAME
from SUBJECTS S
where exists 
	(select 1
	from EXAM_MARKS M 
	where S.ID = M.SUBJ_ID 
	having count(*) = 
			(
				-- отбираем максимальное количество оценок
				select top 1 count(*) as CNT
				from EXAM_MARKS 
				group by SUBJ_ID
				order by CNT desc
			))


-- 9. Напишите команду, которая выдает список фамилий студентов по алфавиту, 
--    с колонкой комментарием: 'успевает' у студентов , имеющих все положительные оценки, 
--    'не успевает' для сдававших экзамены, но имеющих хотя бы одну 
--    неудовлетворительную оценку, и комментарием 'не сдавал' – для всех остальных.
--    Примечание: по возможности воспользуйтесь операторами ALL и ANY.

-- 10. Создайте объединение двух запросов, которые выдают значения полей 
--     NAME, CITY, RATING для всех университетов. Те из них, у которых рейтинг 
--     равен или выше 500, должны иметь комментарий 'Высокий', все остальные – 'Низкий'.

select NAME, CITY, RATING,
CASE
WHEN RATING >= 500 THEN 'Высокий' ELSE 'Низкий'
END DIF_RATING
from UNIVERSITIES
union




-- 11. Напишите UNION запрос на выдачу списка фамилий студентов 4-5 курсов в виде 3х полей выборки:
--     SURNAME, 'студент <значение поля COURSE> курса', STIPEND
--     включив в список преподавателей в виде
--     SURNAME, 'преподаватель из <значение поля CITY>', <значение зарплаты в зависимости от города (придумать самим)>
--     отсортировать по фамилии
--     Примечание: достаточно учесть 4-5 городов.
