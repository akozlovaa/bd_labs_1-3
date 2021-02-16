USE second_lab;
-- Вивести моделі ноутбуків із кількістю RAM
-- рівною 64 Мб. Вивести: model, ram, price. Вихідні дані впорядкувати
-- за зростанням за стовпцем screen.
SELECT model, ram, price
FROM Laptop
WHERE ram=64
ORDER by screen ASC;

-- З таблиці Ships вивести назви кораблів, що почи-
-- наються на 'W' та закінчуються літерою 'n'.
SELECT name 
FROM Ships
WHERE name RLIKE "^W+.+n$";

-- Знайдіть пари моделей ПК, що мають однакові
-- швидкість та RAM (таблиця PC). У результаті кожна пара виводиться
-- лише один раз. Порядок виведення: модель із більшим номером, мо-
-- дель із меншим номером, швидкість та RAM.
SELECT PC_1.model model_1, PC_2.model model_2, PC_1.ram, PC_1.speed 
FROM PC PC_1, PC PC_2 
WHERE PC_1.ram = PC_2.ram AND PC_1.speed = PC_2.speed AND PC_1.model > PC_2.model;

-- Знайдіть кораблі, «збережені для майбутніх битв»,
-- тобто такі, що були виведені з ладу в одній битві ('damaged'), а потім
-- (пізніше в часі) знову брали участь у битвах. Вивести: ship, battle, date.
SELECT ship, battle,result 
FROM Ships
JOIN Outcomes ON Ships.name = Outcomes.ship
WHERE result = "damaged"
HAVING count(name) >= 2; 

-- Знайдіть виробників, які б випускали ПК зі
-- швидкістю 750 МГц та вище. Виведіть: maker.
SELECT maker, speed
FROM Product 
JOIN PC ON PC.model = Product.model
WHERE  speed>=750;

-- З таблиці Income виведіть дати в
-- такому форматі: рік.число_місяця.день, наприклад, 2001.02.15 (без
-- формату часу).
SELECT code, point,
CONCAT(DAY(date),'.0',MONTH(date),'.',YEAR(date)) AS date
FROM Income;

-- Знайдіть виробників, що випускають, по крайній
-- мірі, дві різні моделі ПК. Вивести: maker, число моделей. (Підказка:
-- використовувати підзапити в якості обчислювальних стовпців та
-- операцію групування)
SELECT maker, type
FROM Product 
JOIN PC ON Product.model = PC.model
GROUP BY  maker
HAVING count(DISTINCT(PC.model)) > 1;

-- Знайдіть виробників, які б випускали ноутбуки з
-- мінімальною швидкістю не менше 600 МГц. Вивести: maker,
-- мінімальна швидкість. (Підказка: використовувати підзапити в якості
-- обчислювальних стовпців)

SELECT maker, type, Product.model, min(Laptop.speed) AS min_speed
FROM Product 
JOIN Laptop ON Product.model = Laptop.model
GROUP BY  maker
HAVING min(Laptop.speed)>=600;

-- Для кожного рейсу (таблиця Trip) визначити трива-
-- лість його польоту. Вивести: trip_no, назва компанії, plane, town_from,
-- town_to, тривалість польоту. (Підказка: використати для перевірки
-- умов оператор CASE)


SELECT trip_no, name, plane, town_from, town_to,
CASE WHEN time_out > time_in THEN time_out - time_in
WHEN time_out < time_in then time_in - time_out
end as flight_duration
from Trip, Company
where Trip.ID_comp = Company.ID_comp;

-- Знайти назви всіх кораблів у БД, що складаються із
-- двох та більше слів (наприклад, 'King George V'). Вважати, що слова в
-- назвах розділяються одиничними пробілами, та немає кінцевих пробі-
-- лів. Вивести: назву кораблів. (Підказка: використовувати оператор
-- UNION )

SELECT name
FROM (SELECT name FROM Ships  
UNION
SELECT ship FROM Outcomes) as all_ships
WHERE name RLIKE ".+ +.+"; 