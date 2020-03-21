-- Triggers definition

-- Trigger for user before insert
delimiter |
CREATE OR REPLACE TRIGGER validateUserBeforeInsert BEFORE INSERT ON user
    FOR EACH ROW
    BEGIN

        -- Declaration of variables
        DECLARE usNamRef VARCHAR(21);
        DECLARE usSurRef VARCHAR(36);
        DECLARE usUseRef VARCHAR(31);
        DECLARE usEmaRef VARCHAR(71);
        DECLARE usPhoRef VARCHAR(10);
        DECLARE usPasRef VARCHAR(31);
        DECLARE usRolRef VARCHAR(11);
        DECLARE repeatedUsernameErrorMessage VARCHAR(100);
        DECLARE repeatedEmailErrorMessage VARCHAR (100);
        DECLARE repeatedPhoneErrorMessage VARCHAR (100);
		
		-- Setting conditions and handlers
        DECLARE nameError CONDITION FOR SQLSTATE '45000';
		DECLARE surnameError CONDITION FOR SQLSTATE '45001';
		DECLARE usernameError CONDITION FOR SQLSTATE '45002';
		DECLARE emailError CONDITION FOR SQLSTATE '45003';
		DECLARE phoneError CONDITION FOR SQLSTATE '45004';
		DECLARE passwordError CONDITION FOR SQLSTATE '45005';
        DECLARE dataTooLong CONDITION FOR SQLSTATE '22001';

        -- Loop for data integrity validation
        DECLARE done INT DEFAULT FALSE;
        DECLARE existingUsername VARCHAR(31);
        DECLARE existingEmail VARCHAR(71);
        DECLARE existingPhone VARCHAR(10);
        DECLARE usernameCursor CURSOR FOR SELECT usUse FROM user;
        DECLARE emailCursor CURSOR FOR SELECT usEma FROM user;
        DECLARE phoneCursor CURSOR FOR SELECT usPho FROM user;

        -- Setting handlers
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
        DECLARE EXIT HANDLER FOR nameError
        BEGIN
            RESIGNAL SET MESSAGE_TEXT = 'Error detected on name field. Input does not match the requirements', MYSQL_ERRNO = 1001;
        END;
		DECLARE EXIT HANDLER FOR surnameError
        BEGIN
            RESIGNAL SET MESSAGE_TEXT = 'Error detected on surname field. Input does not match the requirements', MYSQL_ERRNO = 1001;
        END;
		DECLARE EXIT HANDLER FOR usernameError
        BEGIN
            RESIGNAL SET MESSAGE_TEXT = 'Error detected on username field. Input does not match the requirements', MYSQL_ERRNO = 1001;
        END;
		DECLARE EXIT HANDLER FOR emailError
        BEGIN
            RESIGNAL SET MESSAGE_TEXT = 'Error detected on email field. Input does not match the requirements', MYSQL_ERRNO = 1001;
        END;
		DECLARE EXIT HANDLER FOR phoneError
        BEGIN
            RESIGNAL SET MESSAGE_TEXT = 'Error detected on phone field. Input does not match the requirements', MYSQL_ERRNO = 1001;
        END;
		DECLARE EXIT HANDLER FOR passwordError
        BEGIN
            RESIGNAL SET MESSAGE_TEXT = 'Error detected on password field. Input does not match the requirements', MYSQL_ERRNO = 1001;
        END;
        DECLARE EXIT HANDLER FOR dataTooLong 
        BEGIN
            RESIGNAL SET MESSAGE_TEXT = 'Input too long for this field', MYSQL_ERRNO = 1406;
        END;

        -- Variables assignment
        SET usNamRef = NEW.usNam;
        SET usSurRef = NEW.usSur;
        SET usUseRef = NEW.usUse;
        SET usEmaRef = NEW.usEma;
        SET usPhoRef = NEW.usPho;
        SET usPasRef = NEW.usPas;
        SET usRolRef = NEW.usRol;

        OPEN usernameCursor;
        OPEN emailCursor;
        OPEN phoneCursor;

        validation_loop: LOOP 
            FETCH usernameCursor INTO existingUsername;
            FETCH emailCursor INTO existingEmail;
            FETCH phoneCursor INTO existingPhone;

            IF done THEN
                LEAVE validation_loop;
            END IF;

            IF usUseRef = existingUsername THEN
                SET repeatedUsernameErrorMessage = CONCAT('Value for the username detected on database: ', existingUsername);
                SIGNAL SQLSTATE '45500' SET MESSAGE_TEXT = repeatedUsernameErrorMessage, MYSQL_ERRNO = 1001;
            ELSEIF usEmaRef = existingEmail THEN
                SET repeatedEmailErrorMessage = CONCAT('Value for the email detected on database: ', existingEmail);
                SIGNAL SQLSTATE '45501' SET MESSAGE_TEXT = repeatedEmailErrorMessage, MYSQL_ERRNO = 1001;
            ELSEIF usPhoRef = existingPhone THEN
                SET repeatedPhoneErrorMessage = CONCAT('Value for the phone detected on database: ', existingPhone);
                SIGNAL SQLSTATE '45502' SET MESSAGE_TEXT = repeatedPhoneErrorMessage, MYSQL_ERRNO = 1001;
            END IF;
        
        END LOOP;

        CLOSE usernameCursor;
        CLOSE emailCursor;
        CLOSE phoneCursor;

        -- Validations to be run against fields
        IF usNamRef IS NULL OR
            CHAR_LENGTH(TRIM(usNamRef)) = 0 OR
            CHAR_LENGTH(TRIM(usNamRef)) > 20 THEN
                IF CHAR_LENGTH(TRIM(usNamRef)) > 20 THEN
                    SIGNAL dataTooLong;
                ELSE
                    SIGNAL nameError;
                END IF;
        ELSEIF usSurRef IS NULL OR 
            CHAR_LENGTH(TRIM(usSurRef)) = 0 OR
            CHAR_LENGTH(TRIM(usSurRef)) > 35 THEN
                IF CHAR_LENGTH(TRIM(usSurRef)) > 35 THEN
                    SIGNAL dataTooLong;
                ELSE
                    SIGNAL surnameError;
                END IF;
        ELSEIF usUseRef IS NULL OR 
            CHAR_LENGTH(TRIM(usUseRef)) = 0 OR
            CHAR_LENGTH(TRIM(usUseRef)) > 30 THEN
                IF CHAR_LENGTH(TRIM(usUseRef)) > 30 THEN
                    SIGNAL dataTooLong;
                ELSE
                    SIGNAL usernameError;
                END IF;
        ELSEIF usEmaRef IS NULL OR 
            CHAR_LENGTH(TRIM(usEmaRef)) = 0 OR 
            CHAR_LENGTH(TRIM(usEmaRef)) > 70 OR
            usEmaRef REGEXP "^[[:alnum:]\\\\\^\\$\\.\\|\\?\\*\\+\\(\\)\\[\\{\\}\\]\\/\\-!'·%&=¿`´Çç_;:,]+@[[:alnum:]\\.\\-]+\\.[a-z]{2,3}$" = 0 THEN
                IF CHAR_LENGTH(TRIM(usEmaRef)) > 70 THEN
                    SIGNAL dataTooLong;
                ELSE
                    SIGNAL emailError;
                END IF;
        ELSEIF usPhoRef IS NULL OR
            CHAR_LENGTH(TRIM(usPhoRef)) = 0 OR
            CHAR_LENGTH(TRIM(usPhoRef)) > 9 OR
            usPhoRef REGEXP "(^(\\+\\s?([0]{2})\\s?([[:digit:]]{2})\\s?)?([6-7]{1}[[:digit:]]{2}){1}(\\s([[:digit:]]{3}\\s?[[:digit:]]{3}|[[:digit:]]{2}\\s?[[:digit:]]{2}\\s?[[:digit:]]{2})|([[:digit:]]){6})$)" = 0 THEN 
                IF CHAR_LENGTH(TRIM(usPhoRef)) > 9 THEN
                    SIGNAL dataTooLong;
                ELSE
                    SIGNAL phoneError;
                END IF;
        ELSEIF usPasRef IS NULL OR
            CHAR_LENGTH(TRIM(usPasRef)) = 0 OR
            CHAR_LENGTH(TRIM(usPasRef)) > 30 OR
            usPasRef REGEXP "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\\$%\\^&\\*])(?=.{8,})" = 0 THEN 
                IF CHAR_LENGTH(TRIM(usPasRef)) > 30 THEN
                    SIGNAL dataTooLong;
                ELSE
                    SIGNAL emailError;
                END IF;
        END IF;

    END;
    |
delimiter ;

-- Trigger for user before update
delimiter |
CREATE OR REPLACE TRIGGER validateUserBeforeUpdate BEFORE UPDATE ON user
    FOR EACH ROW
    BEGIN

        -- Declaration of variables
        DECLARE usNamRef VARCHAR(21);
        DECLARE usSurRef VARCHAR(36);
        DECLARE usUseRef VARCHAR(31);
        DECLARE usEmaRef VARCHAR(71);
        DECLARE usPhoRef VARCHAR(10);
        DECLARE usPasRef VARCHAR(31);
        DECLARE usRolRef VARCHAR(11);
        DECLARE repeatedUsernameErrorMessage VARCHAR(100);
        DECLARE repeatedEmailErrorMessage VARCHAR (100);
        DECLARE repeatedPhoneErrorMessage VARCHAR (100);
		
		-- Setting conditions and handlers
        DECLARE nameError CONDITION FOR SQLSTATE '45000';
		DECLARE surnameError CONDITION FOR SQLSTATE '45001';
		DECLARE usernameError CONDITION FOR SQLSTATE '45002';
		DECLARE emailError CONDITION FOR SQLSTATE '45003';
		DECLARE phoneError CONDITION FOR SQLSTATE '45004';
		DECLARE passwordError CONDITION FOR SQLSTATE '45005';
        DECLARE dataTooLong CONDITION FOR SQLSTATE '22001';

        -- Loop for data integrity validation
        DECLARE done INT DEFAULT FALSE;
        DECLARE existingId SMALLINT(6);
        DECLARE existingUsername VARCHAR(31);
        DECLARE existingEmail VARCHAR(71);
        DECLARE existingPhone VARCHAR(10);
        DECLARE idCursor CURSOR FOR SELECT usId FROM user;
        DECLARE usernameCursor CURSOR FOR SELECT usUse FROM user;
        DECLARE emailCursor CURSOR FOR SELECT usEma FROM user;
        DECLARE phoneCursor CURSOR FOR SELECT usPho FROM user;

        -- Setting handlers
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
        DECLARE EXIT HANDLER FOR nameError
        BEGIN
            RESIGNAL SET MESSAGE_TEXT = 'Error detected on name field. Input does not match the requirements', MYSQL_ERRNO = 1001;
        END;
		DECLARE EXIT HANDLER FOR surnameError
        BEGIN
            RESIGNAL SET MESSAGE_TEXT = 'Error detected on surname field. Input does not match the requirements', MYSQL_ERRNO = 1001;
        END;
		DECLARE EXIT HANDLER FOR usernameError
        BEGIN
            RESIGNAL SET MESSAGE_TEXT = 'Error detected on username field. Input does not match the requirements', MYSQL_ERRNO = 1001;
        END;
		DECLARE EXIT HANDLER FOR emailError
        BEGIN
            RESIGNAL SET MESSAGE_TEXT = 'Error detected on email field. Input does not match the requirements', MYSQL_ERRNO = 1001;
        END;
		DECLARE EXIT HANDLER FOR phoneError
        BEGIN
            RESIGNAL SET MESSAGE_TEXT = 'Error detected on phone field. Input does not match the requirements', MYSQL_ERRNO = 1001;
        END;
		DECLARE EXIT HANDLER FOR passwordError
        BEGIN
            RESIGNAL SET MESSAGE_TEXT = 'Error detected on password field. Input does not match the requirements', MYSQL_ERRNO = 1001;
        END;
        DECLARE EXIT HANDLER FOR dataTooLong 
        BEGIN
            RESIGNAL SET MESSAGE_TEXT = 'Input too long for this field', MYSQL_ERRNO = 1406;
        END;

        -- Variables assignment
        SET usNamRef = NEW.usNam;
        SET usSurRef = NEW.usSur;
        SET usUseRef = NEW.usUse;
        SET usEmaRef = NEW.usEma;
        SET usPhoRef = NEW.usPho;
        SET usPasRef = NEW.usPas;
        SET usRolRef = NEW.usRol;

        OPEN idCursor;
        OPEN usernameCursor;
        OPEN emailCursor;
        OPEN phoneCursor;

        validation_loop: LOOP 
            FETCH idCursor INTO existingId;
            FETCH usernameCursor INTO existingUsername;
            FETCH emailCursor INTO existingEmail;
            FETCH phoneCursor INTO existingPhone;

            IF done THEN
                LEAVE validation_loop;
            END IF;

            IF existingId != OLD.usId THEN

                IF usUseRef = existingUsername THEN
                    SET repeatedUsernameErrorMessage = CONCAT('Value for the username detected on database: ', existingUsername);
                    SIGNAL SQLSTATE '45500' SET MESSAGE_TEXT = repeatedUsernameErrorMessage, MYSQL_ERRNO = 1001;
                ELSEIF usEmaRef = existingEmail THEN
                    SET repeatedEmailErrorMessage = CONCAT('Value for the email detected on database: ', existingEmail);
                    SIGNAL SQLSTATE '45501' SET MESSAGE_TEXT = repeatedEmailErrorMessage, MYSQL_ERRNO = 1001;
                ELSEIF usPhoRef = existingPhone THEN
                    SET repeatedPhoneErrorMessage = CONCAT('Value for the phone detected on database: ', existingPhone);
                    SIGNAL SQLSTATE '45502' SET MESSAGE_TEXT = repeatedPhoneErrorMessage, MYSQL_ERRNO = 1001;
                END IF;

            END IF;
        
        END LOOP;

        CLOSE idCursor;
        CLOSE usernameCursor;
        CLOSE emailCursor;
        CLOSE phoneCursor;

        -- Validations to be run against fields
        IF usNamRef IS NULL OR 
            CHAR_LENGTH(TRIM(usNamRef)) = 0 OR
            CHAR_LENGTH(TRIM(usNamRef)) > 20 THEN
                IF CHAR_LENGTH(TRIM(usNamRef)) > 20 THEN
                    SIGNAL dataTooLong;
                ELSE
                    SIGNAL nameError;
                END IF;
        ELSEIF usSurRef IS NULL OR 
            CHAR_LENGTH(TRIM(usSurRef)) = 0 OR
            CHAR_LENGTH(TRIM(usSurRef)) > 35 THEN
                IF CHAR_LENGTH(TRIM(usSurRef)) > 35 THEN
                    SIGNAL dataTooLong;
                ELSE
                    SIGNAL surnameError;
                END IF;
        ELSEIF usUseRef IS NULL OR 
            CHAR_LENGTH(TRIM(usUseRef)) = 0 OR
            CHAR_LENGTH(TRIM(usUseRef)) > 30 THEN
                IF CHAR_LENGTH(TRIM(usUseRef)) > 30 THEN
                    SIGNAL dataTooLong;
                ELSE
                    SIGNAL usernameError;
                END IF;
        ELSEIF usEmaRef IS NULL OR 
            CHAR_LENGTH(TRIM(usEmaRef)) = 0 OR 
            CHAR_LENGTH(TRIM(usEmaRef)) > 70 OR
            usEmaRef REGEXP "^[[:alnum:]\\\\\^\\$\\.\\|\\?\\*\\+\\(\\)\\[\\{\\}\\]\\/\\-!'·%&=¿`´Çç_;:,]+@[[:alnum:]\\.\\-]+\\.[a-z]{2,3}$" = 0 THEN
                IF CHAR_LENGTH(TRIM(usEmaRef)) > 70 THEN
                    SIGNAL dataTooLong;
                ELSE
                    SIGNAL emailError;
                END IF;
        ELSEIF usPhoRef IS NULL OR
            CHAR_LENGTH(TRIM(usPhoRef)) = 0 OR
            CHAR_LENGTH(TRIM(usPhoRef)) > 9 OR
            usPhoRef REGEXP "(^(\\+\\s?([0]{2})\\s?([[:digit:]]{2})\\s?)?([6-7]{1}[[:digit:]]{2}){1}(\\s([[:digit:]]{3}\\s?[[:digit:]]{3}|[[:digit:]]{2}\\s?[[:digit:]]{2}\\s?[[:digit:]]{2})|([[:digit:]]){6})$)" = 0 THEN 
                IF CHAR_LENGTH(TRIM(usPhoRef)) > 9 THEN
                    SIGNAL dataTooLong;
                ELSE
                    SIGNAL phoneError;
                END IF;
        ELSEIF usPasRef IS NULL OR
            CHAR_LENGTH(TRIM(usPasRef)) = 0 OR
            CHAR_LENGTH(TRIM(usPasRef)) > 30 OR
            usPasRef REGEXP "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\\$%\\^&\\*])(?=.{8,})" = 0 THEN 
                IF CHAR_LENGTH(TRIM(usPasRef)) > 30 THEN
                    SIGNAL dataTooLong;
                ELSE
                    SIGNAL emailError;
                END IF;
        END IF;

    END;
    |
delimiter ;

-- Trigger for post before insert
delimiter |
CREATE OR REPLACE TRIGGER validatePostBeforeInsert BEFORE INSERT ON post
    FOR EACH ROW
    BEGIN

        -- Declaration of variables
        DECLARE poTitRef VARCHAR(51);
        DECLARE poConRef TEXT;
        DECLARE usIdRef SMALLINT;
		
		-- Setting conditions and handlers
        DECLARE titleError CONDITION FOR SQLSTATE '45000';
		DECLARE contentError CONDITION FOR SQLSTATE '45001';
		DECLARE userIdError CONDITION FOR SQLSTATE '45002';
        DECLARE dataTooLong CONDITION FOR SQLSTATE '22001';

        -- Setting handlers
        DECLARE EXIT HANDLER FOR titleError
        BEGIN
            RESIGNAL SET MESSAGE_TEXT = 'Title field cannot be empty. Provide a title.', MYSQL_ERRNO = 1001;
        END;
		DECLARE EXIT HANDLER FOR contentError
        BEGIN
            RESIGNAL SET MESSAGE_TEXT = 'Content cannot be empty. Provide some content.', MYSQL_ERRNO = 1001;
        END;
		DECLARE EXIT HANDLER FOR userIdError
        BEGIN
            RESIGNAL SET MESSAGE_TEXT = 'Posts must relate to a certain user.', MYSQL_ERRNO = 1001;
        END;
        DECLARE EXIT HANDLER FOR dataTooLong 
        BEGIN
            RESIGNAL SET MESSAGE_TEXT = 'Input too long for this field', MYSQL_ERRNO = 1406;
        END;

        -- Variables assignment
        SET poTitRef = NEW.poTit;
        SET poConRef = NEW.poCon;
        SET usIdRef = NEW.usId;

        -- Validations to be run against fields
        IF poTitRef IS NULL OR
            CHAR_LENGTH(TRIM(poTitRef)) = 0 OR
            CHAR_LENGTH(TRIM(poTitRef)) > 50 THEN
                IF CHAR_LENGTH(TRIM(poTitRef)) > 50 THEN
                    SIGNAL dataTooLong;
                ELSE
                    SIGNAL titleError;
                END IF;
        ELSEIF poConRef IS NULL OR 
            CHAR_LENGTH(TRIM(poConRef)) = 0 THEN
                SIGNAL contentError;
        ELSEIF (SELECT COUNT(usId) FROM user WHERE usId = usIdRef) = 0 THEN 
            SIGNAL userIdError;
        END IF;

    END;
    |
delimiter ;

-- Trigger for post before update
delimiter |
CREATE OR REPLACE TRIGGER validatePostBeforeUpdate BEFORE UPDATE ON post
    FOR EACH ROW
    BEGIN

        -- Declaration of variables
        DECLARE poTitRef VARCHAR(51);
        DECLARE poConRef TEXT;
        DECLARE usIdRef SMALLINT;
		
		-- Setting conditions and handlers
        DECLARE titleError CONDITION FOR SQLSTATE '45000';
		DECLARE contentError CONDITION FOR SQLSTATE '45001';
		DECLARE userIdError CONDITION FOR SQLSTATE '45002';
        DECLARE dataTooLong CONDITION FOR SQLSTATE '22001';

        -- Setting handlers
        DECLARE EXIT HANDLER FOR titleError
        BEGIN
            RESIGNAL SET MESSAGE_TEXT = 'Title field cannot be empty. Provide a title.', MYSQL_ERRNO = 1001;
        END;
		DECLARE EXIT HANDLER FOR contentError
        BEGIN
            RESIGNAL SET MESSAGE_TEXT = 'Content cannot be empty. Provide some content.', MYSQL_ERRNO = 1001;
        END;
		DECLARE EXIT HANDLER FOR userIdError
        BEGIN
            RESIGNAL SET MESSAGE_TEXT = 'Posts must relate to a certain user.', MYSQL_ERRNO = 1001;
        END;
        DECLARE EXIT HANDLER FOR dataTooLong 
        BEGIN
            RESIGNAL SET MESSAGE_TEXT = 'Input too long for this field', MYSQL_ERRNO = 1406;
        END;

        -- Variables assignment
        SET poTitRef = NEW.poTit;
        SET poConRef = NEW.poCon;
        SET usIdRef = NEW.usId;

        -- Validations to be run against fields
        IF poTitRef IS NULL OR
            CHAR_LENGTH(TRIM(poTitRef)) = 0 OR
            CHAR_LENGTH(TRIM(poTitRef)) > 50 THEN
                IF CHAR_LENGTH(TRIM(poTitRef)) > 50 THEN
                    SIGNAL dataTooLong;
                ELSE
                    SIGNAL titleError;
                END IF;
        ELSEIF poConRef IS NULL OR 
            CHAR_LENGTH(TRIM(poConRef)) = 0 THEN
                SIGNAL contentError;
        ELSEIF (SELECT COUNT(usId) FROM user WHERE usId = usIdRef) = 0 THEN 
            SIGNAL userIdError;
        END IF;

    END;
    |
delimiter ;

-- Trigger for comment before insert
delimiter |
CREATE OR REPLACE TRIGGER validateCommentBeforeInsert BEFORE INSERT ON comment
    FOR EACH ROW
    BEGIN

        -- Declaration of variables
        DECLARE coConRef TEXT;
        DECLARE poIdRef SMALLINT;
        DECLARE usIdRef SMALLINT;
		
		-- Setting conditions and handlers
        DECLARE contentError CONDITION FOR SQLSTATE '45000';
		DECLARE postIdError CONDITION FOR SQLSTATE '45001';
		DECLARE userIdError CONDITION FOR SQLSTATE '45002';
        DECLARE dataTooLong CONDITION FOR SQLSTATE '22001';

        -- Setting handlers
        DECLARE EXIT HANDLER FOR contentError
        BEGIN
            RESIGNAL SET MESSAGE_TEXT = 'Content field cannot be empty. Provide some content.', MYSQL_ERRNO = 1001;
        END;
		DECLARE EXIT HANDLER FOR postIdError
        BEGIN
            RESIGNAL SET MESSAGE_TEXT = 'Comment must relate to a certain post.', MYSQL_ERRNO = 1001;
        END;
		DECLARE EXIT HANDLER FOR userIdError
        BEGIN
            RESIGNAL SET MESSAGE_TEXT = 'Comments must relate to a certain user.', MYSQL_ERRNO = 1001;
        END;
        DECLARE EXIT HANDLER FOR dataTooLong 
        BEGIN
            RESIGNAL SET MESSAGE_TEXT = 'Input too long for this field', MYSQL_ERRNO = 1406;
        END;

        -- Variables assignment
        SET coConRef = NEW.coCon;
        SET poIdRef = NEW.poId;
        SET usIdRef = NEW.usId;

        -- Validations to be run against fields
        IF coConRef IS NULL OR 
            CHAR_LENGTH(TRIM(coConRef)) = 0 OR
            CHAR_LENGTH(TRIM(coConRef)) > 200 THEN
                IF CHAR_LENGTH(TRIM(coConRef)) > 200 THEN
                    SIGNAL dataTooLong;
                ELSE
                    SIGNAL contentError;
                END IF;
        ELSEIF (SELECT COUNT(poId) FROM post WHERE poId = poIdRef) = 0 THEN
            SIGNAL postIdError;
        ELSEIF (SELECT COUNT(usId) FROM user WHERE usId = usIdRef) = 0 THEN 
            SIGNAL userIdError;
        END IF;

    END;
    |
delimiter ;

-- Trigger for comment before update
delimiter |
CREATE OR REPLACE TRIGGER validateCommentBeforeUpdate BEFORE UPDATE ON comment
    FOR EACH ROW
    BEGIN

        -- Declaration of variables
        DECLARE coConRef TEXT;
        DECLARE poIdRef SMALLINT;
        DECLARE usIdRef SMALLINT;
		
		-- Setting conditions and handlers
        DECLARE contentError CONDITION FOR SQLSTATE '45000';
		DECLARE postIdError CONDITION FOR SQLSTATE '45001';
		DECLARE userIdError CONDITION FOR SQLSTATE '45002';
        DECLARE dataTooLong CONDITION FOR SQLSTATE '22001';

        -- Setting handlers
        DECLARE EXIT HANDLER FOR contentError
        BEGIN
            RESIGNAL SET MESSAGE_TEXT = 'Content field cannot be empty. Provide some content.', MYSQL_ERRNO = 1001;
        END;
		DECLARE EXIT HANDLER FOR postIdError
        BEGIN
            RESIGNAL SET MESSAGE_TEXT = 'Comment must relate to a certain post.', MYSQL_ERRNO = 1001;
        END;
		DECLARE EXIT HANDLER FOR userIdError
        BEGIN
            RESIGNAL SET MESSAGE_TEXT = 'Comment must relate to a certain user.', MYSQL_ERRNO = 1001;
        END;
        DECLARE EXIT HANDLER FOR dataTooLong 
        BEGIN
            RESIGNAL SET MESSAGE_TEXT = 'Input too long for this field', MYSQL_ERRNO = 1406;
        END;

        -- Variables assignment
        SET coConRef = NEW.coCon;
        SET poIdRef = NEW.poId;
        SET usIdRef = NEW.usId;

        -- Validations to be run against fields
        IF coConRef IS NULL OR 
            CHAR_LENGTH(TRIM(coConRef)) = 0 OR
            CHAR_LENGTH(TRIM(coConRef)) > 200 THEN
                IF CHAR_LENGTH(TRIM(coConRef)) > 200 THEN
                    SIGNAL dataTooLong;
                ELSE
                    SIGNAL contentError;
                END IF;
        ELSEIF (SELECT COUNT(poId) FROM post WHERE poId = poIdRef) = 0 THEN
            SIGNAL postIdError;
        ELSEIF (SELECT COUNT(usId) FROM user WHERE usId = usIdRef) = 0 THEN 
            SIGNAL userIdError;
        END IF;

    END;
    |
delimiter ;

-- Trigger for vote before insert
delimiter |
CREATE OR REPLACE TRIGGER validateVoteBeforeInsert BEFORE INSERT ON vote
    FOR EACH ROW
    BEGIN

        -- Declaration of variables
        DECLARE voTypRef VARCHAR(11);
        DECLARE poIdRef SMALLINT;
        DECLARE usIdRef SMALLINT;
		
		-- Setting conditions and handlers
        DECLARE voteTypeError CONDITION FOR SQLSTATE '45000';
		DECLARE postIdError CONDITION FOR SQLSTATE '45001';
		DECLARE userIdError CONDITION FOR SQLSTATE '45002';
        DECLARE dataTooLong CONDITION FOR SQLSTATE '22001';
        DECLARE duplicatedVote CONDITION FOR SQLSTATE '45003';

        -- Setting handlers
        DECLARE EXIT HANDLER FOR voteTypeError
        BEGIN
            RESIGNAL SET MESSAGE_TEXT = 'Vote type cannot be empty. Select a valid vote type.', MYSQL_ERRNO = 1001;
        END;
		DECLARE EXIT HANDLER FOR postIdError
        BEGIN
            RESIGNAL SET MESSAGE_TEXT = 'A vote must relate to a certain post.', MYSQL_ERRNO = 1001;
        END;
		DECLARE EXIT HANDLER FOR userIdError
        BEGIN
            RESIGNAL SET MESSAGE_TEXT = 'Votes must relate to a certain user.', MYSQL_ERRNO = 1001;
        END;
        DECLARE EXIT HANDLER FOR dataTooLong 
        BEGIN
            RESIGNAL SET MESSAGE_TEXT = 'Input too long for this field', MYSQL_ERRNO = 1406;
        END;
        DECLARE EXIT HANDLER FOR duplicatedVote
        BEGIN
            RESIGNAL SET MESSAGE_TEXT = 'You have already voted for this post', MYSQL_ERRNO = 1001;
        END;

        -- Variables assignment
        SET voTypRef = NEW.voTyp;
        SET poIdRef = NEW.poId;
        SET usIdRef = NEW.usId;

        -- Validations to be run against fields

        IF (SELECT COUNT(voId) FROM vote WHERE poId = poIdRef AND usId = usIdRef = 0) THEN 

            IF voTypRef IS NULL OR 
                CHAR_LENGTH(TRIM(voTypRef)) = 0 OR
                CHAR_LENGTH(TRIM(voTypRef)) > 10 THEN
                    IF CHAR_LENGTH(TRIM(voTypRef)) > 10 THEN
                        SIGNAL dataTooLong;
                    ELSE
                        SIGNAL voteTypeError;
                    END IF;
            ELSEIF (SELECT COUNT(poId) FROM post WHERE poId = poIdRef) = 0 THEN
                SIGNAL postIdError;
            ELSEIF (SELECT COUNT(usId) FROM user WHERE usId = usIdRef) = 0 THEN 
                SIGNAL userIdError;
            END IF;

        ELSE

            SIGNAL duplicatedVote;

        END IF;

    END;
    |
delimiter ;

-- Trigger for vote before update
delimiter |
CREATE OR REPLACE TRIGGER validateVoteBeforeUpdate BEFORE UPDATE ON vote
    FOR EACH ROW
    BEGIN

        -- Declaration of variables
        DECLARE voTypRef VARCHAR(11);
        DECLARE poIdRef SMALLINT;
        DECLARE usIdRef SMALLINT;
		
		-- Setting conditions and handlers
        DECLARE voteTypeError CONDITION FOR SQLSTATE '45000';
		DECLARE postIdError CONDITION FOR SQLSTATE '45001';
		DECLARE userIdError CONDITION FOR SQLSTATE '45002';
        DECLARE dataTooLong CONDITION FOR SQLSTATE '22001';

        -- Setting handlers
        DECLARE EXIT HANDLER FOR voteTypeError
        BEGIN
            RESIGNAL SET MESSAGE_TEXT = 'Vote type cannot be empty. Select a valid vote type.', MYSQL_ERRNO = 1001;
        END;
		DECLARE EXIT HANDLER FOR postIdError
        BEGIN
            RESIGNAL SET MESSAGE_TEXT = 'A vote must relate to a certain post.', MYSQL_ERRNO = 1001;
        END;
		DECLARE EXIT HANDLER FOR userIdError
        BEGIN
            RESIGNAL SET MESSAGE_TEXT = 'Votes must relate to a certain user.', MYSQL_ERRNO = 1001;
        END;
        DECLARE EXIT HANDLER FOR dataTooLong 
        BEGIN
            RESIGNAL SET MESSAGE_TEXT = 'Input too long for this field', MYSQL_ERRNO = 1406;
        END;

        -- Variables assignment
        SET voTypRef = NEW.voTyp;
        SET poIdRef = NEW.poId;
        SET usIdRef = NEW.usId;

        -- Validations to be run against fields
        IF voTypRef IS NULL OR 
            CHAR_LENGTH(TRIM(voTypRef)) = 0 OR
            CHAR_LENGTH(TRIM(voTypRef)) > 10 THEN
                IF CHAR_LENGTH(TRIM(voTypRef)) > 10 THEN
                    SIGNAL dataTooLong;
                ELSE
                    SIGNAL voteTypeError;
                END IF;
        ELSEIF (SELECT COUNT(poId) FROM post WHERE poId = poIdRef) = 0 THEN
            SIGNAL postIdError;
        ELSEIF (SELECT COUNT(usId) FROM user WHERE usId = usIdRef) = 0 THEN 
            SIGNAL userIdError;
        END IF;

    END;
    |
delimiter ;

