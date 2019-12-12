USE s2018112552;

-- add employee
INSERT INTO Employee(`code`, `rank`, `name`, `birthday`, `call`, `mail`, `address`, `bank`, `account`, `date`) VALUES ("AAAAAAAA", "지점장", "김가가", "1980-10-24", "010-0000-0000", "r@naver.com", "안산", "국민", "217019-56-105804", "1999-02-03");
INSERT INTO Employee(`code`, `rank`, `name`, `birthday`, `call`, `mail`, `address`, `bank`, `account`, `date`) VALUES ("BBBBBBBB", "지점장", "이나나", "1983-03-07", "010-1111-1111", "s@naver.com", "수원", "신한", "079801-04-061985", "2003-04-05");
INSERT INTO Employee(`code`, `rank`, `name`, `birthday`, `call`, `mail`, `address`, `bank`, `account`, `date`) VALUES ("CCCCCCCC", "지점장", "박다다", "1978-08-04", "010-2222-2222", "e@gmail.com", "대구", "기업", "1005-802-832006", "2007-07-02");
INSERT INTO Employee(`code`, `rank`, `name`, `birthday`, `call`, `mail`, `address`, `bank`, `account`, `date`) VALUES ("DDDDDDDD", "평사원", "최라라", "1984-02-21", "010-3333-3333", "f@gmail.com", "부산", "우리", "675001-04-034789", "2012-04-22");
INSERT INTO Employee(`code`, `rank`, `name`, `birthday`, `call`, `mail`, `address`, `bank`, `account`, `date`) VALUES ("EEEEEEEE", "평사원", "강마마", "1990-04-22", "010-4444-4444", "a@gmail.com", "창원", "국민", "041301-04-058980", "2016-05-28");
INSERT INTO Employee(`code`, `rank`, `name`, `birthday`, `call`, `mail`, `address`, `bank`, `account`, `date`) VALUES ("FFFFFFFF", "신입", "서바바", "1994-01-03", "010-5555-5555", "g@naver.com", "일산", "기업", "1005-701-464885", "2018-12-02");

select * from Employee;

-- add customer
INSERT INTO Customer(`code`, `name`, `call`, `mail`, `address`) VALUES ("OOOOOOOO", "김김김", "010-1234-1234", "kkk@naver.com", "서울시 용산구");
INSERT INTO Customer(`code`, `name`, `call`, `mail`, `address`) VALUES ("PPPPPPPP", "이이이", "010-2345-2345", "lll@naver.com", "서울시 용산구");
INSERT INTO Customer(`code`, `name`, `call`, `mail`, `address`) VALUES ("QQQQQQQQ", "박박박", "010-3456-3456", "ppp@naver.com", "서울시 종로구");
INSERT INTO Customer(`code`, `name`, `call`, `mail`, `address`) VALUES ("RRRRRRRR", "최최최", "010-4567-4567", "ccc@naver.com", "경기도 수원시");

select * from Customer;

-- add franchise
INSERT INTO Franchise(`code`, `name`, `address`, `phone`) VALUES ("GGGGGGGG", "용산본점", "서울시 용산구", "02-5678-8765");
INSERT INTO Franchise(`code`, `name`, `address`, `phone`) VALUES ("HHHHHHHH", "종로점", "서울시 종로구", "02-1234-4321");
INSERT INTO Franchise(`code`, `name`, `address`, `phone`) VALUES ("IIIIIIII", "수원점", "경기도 수원시", "031-1357-2468");

select * from Franchise;

-- add component
INSERT INTO Component(`code`, `name`, `price`) VALUES ("JJJJJJJJ", "육각회전나사", 3000);
INSERT INTO Component(`code`, `name`, `price`) VALUES ("KKKKKKKK", "7.5V 4080mAh 배터리", 58000);
INSERT INTO Component(`code`, `name`, `price`) VALUES ("LLLLLLLL", "19V 3.16A 60W 어댑터", 74000);
INSERT INTO Component(`code`, `name`, `price`) VALUES ("MMMMMMMM", "R380 메인보드", 102000);
INSERT INTO Component(`code`, `name`, `price`) VALUES ("NNNNNNNN", "RV409 그래픽카드", 208000);

select * from Component;

-- add affiliation with log
CALL SetAffiliation("AAAAAAAA", "GGGGGGGG");
CALL SetAffiliation("BBBBBBBB", "HHHHHHHH");
CALL SetAffiliation("CCCCCCCC", "IIIIIIII");
CALL SetAffiliation("DDDDDDDD", "GGGGGGGG");
CALL SetAffiliation("EEEEEEEE", "HHHHHHHH");
CALL SetAffiliation("FFFFFFFF", "GGGGGGGG");

select * from Affiliation;
select Affiliation.`employee_code`, Employee.`name` AS 직원, Franchise.`name` AS 지점, Affiliation.`franchise_code` FROM Employee, Franchise, Affiliation WHERE Employee.`code` = Affiliation.`employee_code` AND Franchise.`code` = Affiliation.`franchise_code`;
select * from AffiliationChangeHistory;

-- add component with log
CALL OrderComponent("19121301", "AAAAAAAA", "GGGGGGGG", "JJJJJJJJ", 10);
CALL OrderComponent("19121302", "AAAAAAAA", "GGGGGGGG", "KKKKKKKK", 3);
CALL OrderComponent("19121303", "AAAAAAAA", "GGGGGGGG", "LLLLLLLL", 2);
CALL OrderComponent("19121304", "AAAAAAAA", "GGGGGGGG", "MMMMMMMM", 3);
CALL OrderComponent("19121305", "AAAAAAAA", "GGGGGGGG", "NNNNNNNN", 2);
CALL OrderComponent("19121306", "BBBBBBBB", "HHHHHHHH", "KKKKKKKK", 5);
CALL OrderComponent("19121307", "CCCCCCCC", "IIIIIIII", "NNNNNNNN", 3);

select Franchise.`code`, Franchise.`name` AS 지점명, Component.`code`, Component.`name` AS 부품명, ComponentList.`number` AS 개수 from Component, Franchise, ComponentList where ComponentList.`franchise_code` = Franchise.`code` AND ComponentList.`component_code` = Component.`code`;
select * from ComponentOrderHistory;

-- add service
INSERT INTO Service(`code`, `time`, `progress`, `type`, `way`, `customer_code`, `employee_code`) VALUES("SERV_001", "2019-01-06 15:30:22", 4, "SW", True, "OOOOOOOO", "AAAAAAAA");
INSERT INTO Service(`code`, `time`, `progress`, `type`, `way`, `customer_code`, `employee_code`) VALUES("SERV_002", "2019-02-01 16:04:03", 4, "HW", True, "PPPPPPPP", "DDDDDDDD");
INSERT INTO Service(`code`, `time`, `progress`, `type`, `way`, `customer_code`, `employee_code`) VALUES("SERV_003", "2019-03-08 18:33:21", 4, "SW", True, "QQQQQQQQ", "BBBBBBBB");
INSERT INTO Service(`code`, `time`, `progress`, `type`, `way`, `customer_code`, `employee_code`) VALUES("SERV_004", "2019-05-10 20:33:21", 4, "BUY", True, "QQQQQQQQ", "EEEEEEEE");
INSERT INTO Service(`code`, `time`, `progress`, `type`, `way`, `customer_code`, `employee_code`) VALUES("SERV_005", "2019-08-11 22:33:21", 4, "SW", True, "OOOOOOOO", "FFFFFFFF");
INSERT INTO Service(`code`, `time`, `progress`, `type`, `way`, `customer_code`, `employee_code`) VALUES("SERV_006", "2019-10-23 10:33:21", 4, "SW", True, "RRRRRRRR", "CCCCCCCC");

select * from Service;
select Service.code, Service.time, Service.progress, Service.type, Service.way, Service.customer_code, Customer.name AS 고객명, Service.employee_code, Employee.name AS 담당직원 from Service, Customer, Employee where Customer.code = Service.customer_code AND Employee.code = Service.employee_code;