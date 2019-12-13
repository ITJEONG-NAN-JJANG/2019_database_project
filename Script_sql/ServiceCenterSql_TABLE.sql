
-- 직원
DROP TABLE IF EXISTS Employee;
CREATE TABLE Employee (
	`code`     CHARACTER(8)                        NOT NULL, -- 직원코드
	`rank`     ENUM('신입', '평사원', '지점장')	 	   NOT NULL DEFAULT '신입', -- 직급
	`name`     VARCHAR(50)                         NOT NULL, -- 이름
	`birthday` DATE                                NOT NULL, -- 생년월일
	`call`     VARCHAR(30)                         NOT NULL, -- 전화번호
	`mail`     VARCHAR(50)                         NOT NULL, -- 이메일
	`address`  VARCHAR(255)                        NOT NULL, -- 주소
	`bank`     VARCHAR(50)                         NOT NULL, -- 계좌은행
	`account`  VARCHAR(20)                         NOT NULL, -- 계좌번호
	`date`     DATE                                NOT NULL, -- 입사날짜
    
    PRIMARY KEY(`code`)
);

-- 부품
DROP TABLE IF EXISTS Component;
CREATE TABLE Component (
	`code`  CHARACTER(8) NOT NULL, -- 부품코드
	`name`  VARCHAR(50)  NOT NULL, -- 제품명
	`price` INTEGER      NOT NULL DEFAULT 0, -- 판매가격
    
    PRIMARY KEY(`code`)
);

-- 지점
DROP TABLE IF EXISTS Franchise;
CREATE TABLE Franchise (
	`code`    CHARACTER(8) NOT NULL, -- 지점코드
	`name`    VARCHAR(50)  NOT NULL, -- 지점명
	`address` VARCHAR(255) NOT NULL, -- 주소
	`phone`   VARCHAR(30)  NOT NULL,  -- 전화번호
    
    PRIMARY KEY(`code`)
);

-- 고객
DROP TABLE IF EXISTS Customer;
CREATE TABLE Customer (
	`code`    CHARACTER(8) NOT NULL, -- 고객코드
	`name`    VARCHAR(50)  NOT NULL, -- 이름
	`call`    VARCHAR(30)  NOT NULL, -- 전화번호
	`mail`    VARCHAR(50)  NOT NULL, -- 이메일
	`address` VARCHAR(255) NOT NULL,  -- 주소
    
    PRIMARY KEY(`code`)
);

-- 부품재고
DROP TABLE IF EXISTS ComponentList;
CREATE TABLE ComponentList (
	`franchise_code` CHARACTER(8) NOT NULL, -- 대리점고유번호
	`component_code` CHARACTER(8) NOT NULL, -- 부품고유번호
	`number`         INTEGER      NOT NULL DEFAULT 0, -- 개수
    
    PRIMARY KEY(`franchise_code`, `component_code`),
    FOREIGN KEY(`franchise_code`) REFERENCES Franchise(`code`),
    FOREIGN KEY(`component_code`) REFERENCES Component(`code`)
);

-- 서비스 접수 정보
DROP TABLE IF EXISTS Service;
CREATE TABLE Service (
	`code`          CHARACTER(8)               NOT NULL, -- 서비스 접수 코드
	`time`          TIMESTAMP                  NOT NULL, -- 접수 시간
	`progress`      INTEGER                    NOT NULL DEFAULT 0, -- 서비스 진행 상태
	`type`          ENUM('SW', 'HW', 'BUY')    NOT NULL DEFAULT 'SW', -- 서비스 분류
	`way`           BOOLEAN                    NOT NULL DEFAULT false, -- 서비스 제공 방법
	`customer_code` CHARACTER(8)               NOT NULL, -- 고객고유번호
	`employee_code` CHARACTER(8)               NULL,      -- 담당직원고유번호
    
    PRIMARY KEY(`code`),
    FOREIGN KEY(`customer_code`) REFERENCES Customer(`code`),
    FOREIGN KEY(`employee_code`) REFERENCES Employee(`code`)
);

-- 서비스 이력
DROP TABLE IF EXISTS ServiceHistory;
CREATE TABLE ServiceHistory (
	`service_code` CHARACTER(8) NOT NULL, -- 서비스 접수 코드
	`time`         TIMESTAMP    NOT NULL, -- 시간
	`progress`     INTEGER      NOT NULL DEFAULT 0, -- 이력 번호
	`explanation`  VARCHAR(255) NULL,      -- 서비스 내용
    
    PRIMARY KEY(`service_code`, `time`),
    FOREIGN KEY(`service_code`) REFERENCES Service(`code`)
);

-- 결제 이력
DROP TABLE IF EXISTS PaymentHistory;
CREATE TABLE PaymentHistory (
	`service_code` CHARACTER(8) NOT NULL, -- 서비스 접수 코드
	`time`         TIMESTAMP    NOT NULL, -- 결제 시간
	`card`         VARCHAR(30)  NULL,     -- 결제카드번호
	`price`        INTEGER      NOT NULL DEFAULT 0, -- 결제 금액
    
    PRIMARY KEY(`service_code`, `time`),
    FOREIGN KEY(`service_code`) REFERENCES Service(`code`)
);

-- 부품 주문 이력
DROP TABLE IF EXISTS ComponentOrderHistory;
CREATE TABLE ComponentOrderHistory (
	`code`           CHARACTER(8) NOT NULL, -- 부품 주문 코드
	`time`           TIMESTAMP    NOT NULL, -- 주문 시간
	`employee_code`  CHARACTER(8) NOT NULL, -- 직원코드
	`franchise_code` CHARACTER(8) NOT NULL, -- 대리점고유번호
	`component_code` CHARACTER(8) NOT NULL, -- 부품고유번호
	`number`         INTEGER      NOT NULL DEFAULT 0, -- 개수
    
    PRIMARY KEY(`code`),
	FOREIGN KEY(`employee_code`) REFERENCES Employee(`code`),
	FOREIGN KEY(`franchise_code`) REFERENCES Franchise(`code`),
	FOREIGN KEY(`component_code`) REFERENCES Component(`code`)
);

-- 부품 판매 이력
DROP TABLE IF EXISTS ComponentSalesHistory;
CREATE TABLE ComponentSalesHistory (
	`service_code`   CHARACTER(8) NOT NULL, -- 서비스 접수 코드
	`franchise_code` CHARACTER(8) NOT NULL, -- 대리점고유번호
	`component_code` CHARACTER(8) NOT NULL, -- 부품고유번호
	`date`           DATE         NOT NULL, -- 판매 날짜
    
    PRIMARY KEY(`service_code`, `franchise_code`, `component_code`),
    FOREIGN KEY(`service_code`) REFERENCES Service(`code`),
    FOREIGN KEY(`franchise_code`) REFERENCES Franchise(`code`),
    FOREIGN KEY(`component_code`) REFERENCES Component(`code`)
);

-- 직원 소속
DROP TABLE IF EXISTS Affiliation;
CREATE TABLE Affiliation (
	`employee_code`  CHARACTER(8) NOT NULL, -- 직원코드
	`franchise_code` CHARACTER(8) NOT NULL,  -- 지점코드
    
	PRIMARY KEY(`employee_code`),
    FOREIGN KEY(`employee_code`) REFERENCES Employee(`code`),
    FOREIGN KEY(`franchise_code`) REFERENCES Franchise(`code`)
);

-- 소속 변경 이력
DROP TABLE IF EXISTS AffiliationChangeHistory;
CREATE TABLE AffiliationChangeHistory (
	`employee_code`  CHARACTER(8) NOT NULL, -- 직원코드
	`franchise_code` CHARACTER(8) NOT NULL, -- 지점코드
	`time`           TIMESTAMP    NOT NULL,  -- 시간
    
    PRIMARY KEY(`employee_code`, `time`),
    FOREIGN KEY(`employee_code`) REFERENCES Employee(`code`),
    FOREIGN KEY(`franchise_code`) REFERENCES Franchise(`code`)
);