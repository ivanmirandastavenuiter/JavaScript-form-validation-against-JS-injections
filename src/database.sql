DROP DATABASE IF EXISTS CH33TZ;

-- Database creation
CREATE DATABASE IF NOT EXISTS CH33TZ CHARACTER SET 'utf8' COLLATE 'utf8_general_ci';

-- Database selection
USE CH33TZ;

-- Creation of user table
CREATE TABLE IF NOT EXISTS user (
    usId SMALLINT PRIMARY KEY AUTO_INCREMENT,
    usNam VARCHAR(21) NOT NULL, 
    usSur VARCHAR(36),
    usUse VARCHAR(31) NOT NULL,
    usEma VARCHAR(71) NOT NULL,
    usPho VARCHAR(10) NOT NULL,
    usPas VARCHAR(31) NOT NULL,
    usRol VARCHAR(11) NOT NULL
);

    -- usEma VARCHAR(70) NOT NULL CHECK ("^[\\w\\d\\\\\\^\\$\\.\\|\\?\\*\\+\\(\\)\\[\\{\\}\\]\\/\\-!'·%&=¿`´Çç_.;:,]+@[\\w\\d\\.\\-]+\\.[a-z]{2,3}$"),
    -- usPho VARCHAR(9) NOT NULL CHECK ('(^(\\+\\s?([0]{2})\\s?([0-9]{2})\\s?)?([6-7]{1}[0-9]{2}){1}(\\s([0-9]{3}\\s?[0-9]{3}|[0-9]{2}\\s?[0-9]{2}\\s?[0-9]{2})|([0-9]){6})$)'),
    -- usPas VARCHAR(30) NOT NULL CHECK ('^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*])(?=.{8,})'),

-- Creation of post table
CREATE TABLE IF NOT EXISTS post (
    poId SMALLINT PRIMARY KEY AUTO_INCREMENT,
    poTit VARCHAR(51) NOT NULL,
    poCon TEXT NOT NULL, 
    poDat DATETIME,
    poVis INT, 
    usId SMALLINT NOT NULL,
    CONSTRAINT FK_usId_post_table FOREIGN KEY (usId) REFERENCES user(usId) -- One user - many posts
);

-- Creation of comment table
CREATE TABLE IF NOT EXISTS comment (
    coId SMALLINT PRIMARY KEY AUTO_INCREMENT,
    coCon TEXT NOT NULL,
    coDat DATETIME,
    poId SMALLINT NOT NULL,
    usId SMALLINT NOT NULL,
    CONSTRAINT FK_poId_comment_table FOREIGN KEY (poId) REFERENCES post(poId), -- One post - many comments
    CONSTRAINT FK_usId_comment_table FOREIGN KEY (usId) REFERENCES user(usId) -- One user - many comments
);

-- Creation of vote table
CREATE TABLE IF NOT EXISTS vote (
    voId SMALLINT PRIMARY KEY AUTO_INCREMENT,
    voTyp VARCHAR(11) NOT NULL,
    voDat DATETIME,
    poId SMALLINT NOT NULL,
    usId SMALLINT NOT NULL,
    CONSTRAINT FK_usId_vote_table FOREIGN KEY (usId) REFERENCES user(usId), -- One user - many votes
    CONSTRAINT FK_poId_vote_table FOREIGN KEY (poId) REFERENCES post(poId) -- One post - many votes
);