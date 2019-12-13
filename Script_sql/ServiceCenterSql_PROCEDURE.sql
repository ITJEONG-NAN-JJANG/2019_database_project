use s2018112552;

-- add new Employee
DROP PROCEDURE IF EXISTS AddNewEmployee;
DELIMITER $$
CREATE PROCEDURE AddNewEmployee(
		IN `code` CHARACTER(8),
        IN `name` VARCHAR(50),
        IN `birthday` DATE,
        IN `call` VARCHAR(30),
        IN `mail` VARCHAR(50),
        IN `address` VARCHAR(255),
        IN `bank` VARCHAR(50),
        IN `account` VARCHAR(20),
        OUT `result` BOOLEAN
)
BEGIN
	INSERT INTO Employee(`code`, `name`, `birthday`, `call`, `mail`, `address`, `bank`, `account`, `date`) VALUES(`code`, `name`, `birthday`, `call`, `mail`, `address`, `bank`, `account`, CURRENT_TIMESTAMP());

	SET `result` = TRUE;

END
$$ DELIMITER ;

-- add new franchise
DROP PROCEDURE IF EXISTS AddNewFranchise;
DELIMITER $$
CREATE PROCEDURE AddNewFranchise(
	IN `code` CHARACTER(8),
    IN `name` VARCHAR(50),
    IN `address` VARCHAR(255),
    IN `phone` VARCHAR(30),
    OUT `result` BOOLEAN
)
BEGIN
	INSERT INTO Component(`code`, `name`, `address`, `phone`) VALUES(`code`, `name`, `address`, `phone`);

    SET `result` = TRUE;

END
$$ DELIMITER ;

-- add new Component
DROP PROCEDURE IF EXISTS AddNewComponent;
DELIMITER $$
CREATE PROCEDURE AddNewComponent(
	IN `code` CHARACTER(8),
    IN `name` VARCHAR(50),
    IN `price` INTEGER,
    OUT `result` BOOLEAN
)
BEGIN
	INSERT INTO Component(`code`, `name`, `price`) VALUES(`code`, `name`, `price`);

    SET `result` = TRUE;

END
$$ DELIMITER ;

-- add new customer
DROP PROCEDURE IF EXISTS AddNewCustomer;
DELIMITER $$
CREATE PROCEDURE AddNewCustomer(
	IN `code` CHARACTER(8),
    IN `name` VARCHAR(50),
    IN `call` VARCHAR(30),
    IN `mail` VARCHAR(50),
    IN `address` VARCHAR(255),
    OUT `result` BOOLEAN
)
BEGIN
	INSERT INTO Component(`code`, `name`, `call`, `mail`, `address`) VALUES(`code`, `name`, `call`, `mail`, `address`);

    SET `result` = TRUE;

END
$$ DELIMITER ;


-- set affiliation
-- Add log -> AffiliationChangeHistory
DROP PROCEDURE IF EXISTS SetAffiliation;
DELIMITER $$
CREATE PROCEDURE SetAffiliation(
	IN `employee` CHARACTER(8),
    IN `franchise` CHARACTER(8)
)
BEGIN
	IF EXISTS ( SELECT `employee_code` FROM Affiliation WHERE `employee_code` = `employee` ) THEN
		UPDATE Affiliation SET `franchise_code` = `franchise` WHERE `employee_code` = `employee`;
	ELSE
		INSERT INTO Affiliation(`employee_code`, `franchise_code`) VALUES(`employee`, `franchise`);

	INSERT INTO AffiliationChangeHistory(`employee_code`, `time`, `franchise_code`) VALUES(`employee`, CURRENT_TIMESTAMP(), `franchise`);
    END IF;
END
$$ DELIMITER ;

-- order component in list
DROP PROCEDURE IF EXISTS OrderComponent;
DELIMITER $$
CREATE PROCEDURE OrderComponent(
	IN `code` CHARACTER(8),
	IN `employee` CHARACTER(8),
	IN `franchise` CHARACTER(8),
    IN `component` VARCHAR(50),
    IN NUMBER INTEGER
)
BEGIN
	DECLARE COUNT INTEGER;

	IF EXISTS (SELECT `number` FROM ComponentList WHERE `franchise_code` = `franchise` AND `component_code` = `component`) THEN

		SELECT `number` INTO COUNT FROM ComponentList WHERE `franchise_code` = `franchise` AND `component_code` = `component`;

		UPDATE ComponentList SET `number` = COUNT + NUMBER WHERE `franchise_code` = `franchise` AND `component_code` = `component`;

    ELSE
		INSERT INTO ComponentList(`franchise_code`, `component_code`, `number`) VALUES(`franchise`, `component`, NUMBER);

    END IF;

    INSERT INTO ComponentOrderHistory(`code`, `time`, `employee_code`, `franchise_code`, `component_code`, `number`) VALUES (`code`, CURRENT_TIMESTAMP(), `employee`, `franchise`, `component`, NUMBER);

END
$$ DELIMITER ;

-- sold component
DROP PROCEDURE IF EXISTS SellComponent;
DELIMITER $$
CREATE PROCEDURE SellComponent(
	IN `code` CHARACTER(8),
	IN `employee` CHARACTER(8),
	IN `franchise` CHARACTER(8),
    IN `component` VARCHAR(50)
)
BEGIN
	DECLARE COUNT INTEGER;

	SELECT `number` INTO COUNT FROM ComponentList WHERE `franchise_code` = `franchise` AND `component_code` = `component`;

    IF COUNT > 1 THEN
		UPDATE ComponentList SET `number` = COUNT - 1 WHERE `franchise_code` = `franchise` AND `component_code` = `component`;

        INSERT INTO ComponentSalesHistory(`code`, `date`, `employee_code`, `franchise_code`, `component_code`) VALUES (`code`, CURRENT_TIMESTAMP(), `employee`, `franchise`, `component`);
    ELSEIF COUNT = 1 THEN
		DELETE FROM ComponentList WHERE `franchise_code` = `franchise` AND `component_code` = `component`;

        INSERT INTO ComponentSalesHistory(`code`, `date`, `employee_code`, `franchise_code`, `component_code`) VALUES (`code`, CURRENT_TIMESTAMP(), `employee`, `franchise`, `component`);
	END IF;
END
$$ DELIMITER ;


DROP PROCEDURE IF EXISTS AddService;
DELIMITER $$
CREATE PROCEDURE AddService(
	IN `code` CHARACTER(8),
    IN `way` BOOLEAN,
    IN `customer` CHARACTER(8),
    IN `employee` CHARACTER(8),
    IN `explanation` VARCHAR(255),
    OUT `result` BOOLEAN
)
BEGIN
	DECLARE NOW DATE;
    SET NOW = CURRENT_TIMESTAMP();
	IF `employee` = NULL THEN
		INSERT INTO Service(`code`, `time`, `progress`, `type`, `way`, `customer_code`) VALUES	(`code`, NOW, 0, 'SW', `way`, `customer`);

		INSERT INTO ServiceHistory(`service_code`, `time`, `progress`, `explanation`) VALUES (`code`, CURRENT_TIMESTAMP(), 0, `explanation`);
    ELSE
		INSERT INTO Service(`code`, `time`, `progress`, `type`, `way`, `customer_code`, `employee_code`) VALUES	(`code`, NOW, 1, 'SW', `way`, `customer`, `employee`);

    INSERT INTO ServiceHistory(`service_code`, `time`, `progress`, `explanation`) VALUES (`code`, CURRENT_TIMESTAMP(), 1, `explanation`);
	SET `result` = TRUE;

    END IF;
END
$$ DELIMITER ;

DROP PROCEDURE IF EXISTS MatchingEmployee;
DELIMITER $$
CREATE PROCEDURE MatchingEmployee(
	IN `code` CHARACTER(8),
    IN `employee` CHARACTER(8),
    OUT `result` BOOLEAN
)
BEGIN
	DECLARE NOW DATE;
    SET NOW = CURRENT_TIMESTAMP();

    UPDATE Service SET `employee_code` = `employee` WHERE `code` = `code`;

	INSERT INTO ServiceHistory(`service_code`, `time`, `progress`, `explanation`) VALUES (`code`, CURRENT_TIMESTAMP(), 1, `explanation`);

    SET `result` = TRUE;
END
$$ DELIMITER ;

DROP PROCEDURE IF EXISTS ChangeProgress;
DELIMITER $$
CREATE PROCEDURE ChangeProgress(
	IN `code` CHARACTER(8),
    IN `progress` INTEGER
)
BEGIN
	UPDATE Service SET `progress` = `progress` WHERE `code` = `code`;

    INSERT INTO ServiceHistory(`service_code`, `time`, `progress`, `explanation`) VALUES (`code`, CURRENT_TIMESTAMP(), `progress`, `explanation`);
END
$$ DELIMITER ;

DROP PROCEDURE IF EXISTS ChangeServiceType;
DELIMITER $$
CREATE PROCEDURE ChangeServiceType(
	IN `code` CHARACTER(8),
    IN `type` INTEGER
)
BEGIN
	UPDATE Service SET `type` = `type` WHERE `code` = `code`;
END
$$ DELIMITER ;


DROP PROCEDURE IF EXISTS PaymentService;
DELIMITER $$
CREATE PROCEDURE PaymentService(
	IN `code` CHARACTER(8),
    IN `card` VARCHAR(30),
    IN `price` INTEGER
)
BEGIN
	IF `card` = NULL THEN
		INSERT INTO PaymentHistory(`service_code`, `time`, `price`) VALUES(`code`, CURRENT_TIMESTAMP(), `price`);
    ELSE
		INSERT INTO PaymentHistory(`service_code`, `time`, `card`, `price`) VALUES(`code`, CURRENT_TIMESTAMP(), `card`, `price`);
    END IF;

    CALL ChangeProgress(`code`, 5);

    INSERT INTO ServiceHistory(`service_code`, `time`, `progress`, `explanation`) VALUES (`code`, CURRENT_TIMESTAMP(), `progress`, `explanation`);
END
$$ DELIMITER ;
