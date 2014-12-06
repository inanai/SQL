-- Внимание! Во всех результирующих выборках не должно быть NULL записей
-- Для этого используйте либо CASE, либо функцию ISNULL(<выражение>, <значение по умолчанию>)
-- Соблюдать это условие достаточно для двух полей BIRTHDAY и UNIV_ID.

-- 1. Составьте запрос для таблицы STUDENT таким образом, чтобы выходная таблица 
--    содержала один столбец типа varchar, содержащий последовательность разделенных 
--    символом ';' (точка с запятой) значений столбцов этой таблицы, и при этом 
--    текстовые значения должны отображаться прописными символами (верхний регистр), 
--    то есть быть представленными в следующем виде: 
--    1;КАБАНОВ;ВИТАЛИЙ;550;4;ХАРЬКОВ;01/12/1990;2.
--    ...
--    примечание: в выборку должны попасть студенты из любого города, 
--    состоящего из 5 символов

select UPPER(CAST(ID as varchar) + ';' + SURNAME + ';' + NAME + ';' + 
	CAST(FLOOR(STIPEND) as varchar) + ';' + CAST(COURSE as varchar) + ';' + CITY + ';' + 
	CONVERT(varchar, BIRTHDAY, 101)  + ';' + CAST(UNIV_ID as varchar))
from STUDENTS   
where LEN(CITY) = 5
and BIRTHDAY is not null and UNIV_ID is not null


-- 2. Составьте запрос для таблицы STUDENT таким образом, чтобы выходная таблица 
--    содержала всего один столбец в следующем виде: 
--    В.КАБАНОВ;местожительства-ХАРЬКОВ;родился-01.12.90
--    ...
--    примечание: в выборку должны попасть студенты, фамилия которых содержит вторую
--    букву 'е' и предпоследнюю букву 'и', либо фамилия заканчивается на 'ц'

select LEFT (NAME, 1) + '.' + UPPER(SURNAME) + ';' + 'местожительства-' + UPPER(CITY) + ';' + 
'родился-' + CONVERT(varchar, BIRTHDAY, 4)
from STUDENTS   
where BIRTHDAY is not null and
      (SURNAME like '_е%' and SURNAME like '%и_'
      or SURNAME like '%ц')


-- 3. Составьте запрос для таблицы STUDENT таким образом, чтобы выходная таблица 
--    содержала всего один столбец в следующем виде:
--    т.цилюрик;местожительства-Херсон;учится на IV курсе
--    ...
--    примечание: курс указать римскими цифрами, отобрать студентов, стипендия 
--    которых кратна 200

select LOWER(LEFT (NAME, 1)) + '.' + LOWER(SURNAME) + ';' + 'местожительства-' + CITY + ';' + 'учится на ' +
CASE COURSE
WHEN  1 THEN 'I'
WHEN  2 THEN 'II'
WHEN  3 THEN 'III'
WHEN  4 THEN 'IV'
WHEN  5 THEN 'V'
END
+ ' курсе'
from STUDENTS   
where STIPEND % 200 = 0


-- 4. Составьте запрос для таблицы STUDENT таким образом, чтобы выборка 
--    содержала столбец в следующего вида:
--     Нина Федосеева из г.Днепропетровск родился(ась) в 1992 году
--     ...
--    для всех городов, в которых более 8 букв

select NAME + ' ' + SURNAME + ' ' + 'из г.' + ' ' + CITY + ' родился(ась)'
+ ' в '  + CONVERT(varchar, YEAR(BIRTHDAY)) + ' году'
from STUDENTS   
where LEN(CITY) > 8
and BIRTHDAY is not null


-- 5. Вывести фамилии, имена студентов и величину получаемых ими стипендий, 
--    при этом значения стипендий первокурсников должны быть увеличены на 17.5%

select SURNAME, NAME, STIPEND,
    CASE
    WHEN COURSE = 1 THEN STIPEND + STIPEND / 100 * 17.5 ELSE STIPEND
    END as DIF_STIPEND
from STUDENTS

select SURNAME, NAME, STIPEND,
    CASE COURSE
    WHEN 1 THEN STIPEND + STIPEND / 100 * 17.5 ELSE STIPEND
    END as DIF_STIPEND
from STUDENTS


-- 6. Вывести наименования всех учебных заведений и их расстояния 
--    (придумать/нагуглить/взять на глаз) до Киева.

select NAME,
    CASE CITY
	WHEN 'Киев' THEN 0
    WHEN 'Харьков' THEN 478 
	WHEN 'Львов' THEN 550 
	WHEN 'Днепропетровск' THEN 533 
	WHEN 'Донецк' THEN 727 
	WHEN 'Одесса' THEN 489 
	WHEN 'Тернополь' THEN 427
	WHEN 'Запорожье' THEN 607
	WHEN 'Белая Церковь' THEN 86
	WHEN 'Херсон' THEN 551
	ELSE NULL
    END as KM_TO_KYIV
from UNIVERSITIES


-- 7. Вывести все учебные заведения и их две последние цифры рейтинга.

select NAME, RIGHT (RATING, 2) as RATING_LAST_2
from UNIVERSITIES

select NAME, RATING % 100 as RATING_LAST_2
from UNIVERSITIES


-- 8. Составьте запрос для таблицы UNIVERSITY таким образом, чтобы выходная таблица 
--    содержала всего один столбец в следующем виде:
--    Код-1;КПИ-г.Киев;Рейтинг относительно ДНТУ(501) +276
--    примечание: рейтинг вычислить относительно ДНТУшного, а также должен 
--    присутствовать знак (+/-)

select 
    'Код-' + CAST (ID as varchar) + ';' + NAME + '-г.' + CITY+ ';' + 
	CASE
    WHEN RATING > 501 THEN '+' ELSE ''
    END
	+ CAST(RATING - 501 as varchar)
from UNIVERSITIES


-- 9. Составьте запрос для таблицы UNIVERSITY таким образом, чтобы выходная таблица 
--    содержала всего один столбец в следующем виде:
--    Код-1;КНУ-г.Киев;Рейтинг состоит из 6 сотен
--    примечание: в рейтинге необходимо указать кол-во сотен

select
    'Код-' + CAST (ID as varchar) + ';' + NAME + '-г.' + CITY+ ';Рейтинг состоит из ' +
	CAST(FLOOR(RATING/100) as varchar) + ' сотен'
from UNIVERSITIES