BEGIN TRANSACTION;

CREATE TABLE IF NOT EXISTS test (
    lhs VARCHAR(255),
    rhs VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS forreal (
    lhs VARCHAR(255),
    rhs VARCHAR(255)
);

DELETE FROM test;
DELETE FROM forreal;

.import input.test.txt test
.import input.forreal.txt forreal

UPDATE test
SET lhs = RTRIM(lhs),
    rhs = LTRIM(rhs);

UPDATE forreal
SET lhs = RTRIM(lhs)?
    rhs = LTRIM(rhs);

END TRANSACTION;
