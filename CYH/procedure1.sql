CREATE OR REPLACE PROCEDURE procNewPet
(petName IN Pets.name%TYPE, petAge IN Pets.age%TYPE, petGender IN Pets.gender%TYPE,
petBreed IN Pets.breed%TYPE, petColor IN Pets.color%TYPE, petType IN Pets.type%TYPE, ownerIc IN Pets.ownerIc%TYPE) IS

    v_lastId Pets.id%TYPE;
    v_petName Pets.name%TYPE;
    v_petAge Pets.age%TYPE;
    v_petGender Pets.gender%TYPE;
    v_petBreed Pets.breed%TYPE;
    v_petColor Pets.color%TYPE;
    v_petType Pets.type%TYPE;
    v_ownerIc Pets.ownerIc%TYPE;

    v_sameName BOOLEAN;
    v_sameAge BOOLEAN;
    v_sameGender BOOLEAN;
    v_sameBreed BOOLEAN;
    v_sameColor BOOLEAN;
    v_sameType BOOLEAN;
    v_sameOwnerIc BOOLEAN;

    EX_PET_EXIST EXCEPTION;
    EX_NULL_PET_NAME EXCEPTION;
    EX_NULL_PET_AGE EXCEPTION;
    EX_NULL_PET_GENDER EXCEPTION;
    EX_NULL_PET_BREED EXCEPTION;
    EX_NULL_PET_COLOR EXCEPTION;
    EX_NULL_PET_TYPE EXCEPTION;
    EX_NULL_OWNER_IC EXCEPTION;

    CURSOR c1 IS
    SELECT name,age,gender,breed,color,type,ownerIc FROM Pets;

BEGIN
    CASE
        WHEN (TRIM(petName) IS NULL) THEN
            RAISE EX_NULL_PET_NAME;
        WHEN (TRIM(petAge) is NULL OR petAge <= 0) THEN
            RAISE EX_NULL_PET_AGE;
        WHEN (TRIM(petGender) IS NULL) THEN
            RAISE EX_NULL_PET_GENDER;
        WHEN (TRIM(petBreed) IS NULL) THEN
            RAISE EX_NULL_PET_BREED;
        WHEN (TRIM(petColor) IS NULL) THEN
            RAISE EX_NULL_PET_COLOR;
        WHEN (TRIM(petType) IS NULL) THEN
            RAISE EX_NULL_PET_TYPE;
        WHEN (TRIM(ownerIc) IS NULL) THEN
            RAISE EX_NULL_OWNER_IC;
        ELSE
            open c1;
            LOOP
                FETCH c1 
                INTO v_petName, v_petAge, v_petGender, v_petBreed, v_petColor, v_petType, v_ownerIc;
                EXIT WHEN c1%NOTFOUND;

                IF petName LIKE v_petName THEN
                    v_sameName := TRUE;
                ELSE
                    v_sameName := FALSE;
                END IF;

                IF petAge LIKE v_petAge THEN
                    v_sameAge := TRUE;
                ELSE
                    v_sameAge := FALSE;
                END IF;

                IF petGender LIKE v_petGender THEN
                    v_sameGender := TRUE;
                ELSE
                    v_sameGender := FALSE;
                END IF;

                IF petBreed LIKE v_petBreed THEN
                    v_sameBreed := TRUE;
                ELSE
                    v_sameBreed := FALSE;
                END IF;

                IF petColor LIKE v_petColor THEN
                    v_sameColor := TRUE;
                ELSE
                    v_sameColor := FALSE;
                END IF;

                IF petType LIKE v_petType THEN
                    v_sameType := TRUE;
                ELSE
                    v_sameType := FALSE;
                END IF;

                IF ownerIc LIKE v_ownerIc THEN
                    v_sameOwnerIc := TRUE;
                ELSE
                    v_sameOwnerIc := FALSE;
                END IF;

                IF v_sameName = TRUE AND v_sameAge = TRUE AND v_sameGender = TRUE AND v_sameBreed AND v_sameColor AND v_sameType AND v_sameOwnerIc THEN
                    RAISE EX_PET_EXIST;
                END IF;

            END LOOP;
            CLOSE c1;

            SELECT (MAX(id)) into v_lastId FROM Pets;

            INSERT INTO Pets
            VALUES ((v_lastId + 1), TRIM(petName), TRIM(petAge), TRIM(petGender), TRIM(petBreed), TRIM(petColor), TRIM(petType), TRIM(ownerIc));
            DBMS_OUTPUT.PUT_LINE('-----New Pet has added successfully.-----');
    END CASE;

EXCEPTION
    WHEN EX_NULL_PET_NAME THEN
        DBMS_OUTPUT.PUT_LINE('-----Invalid Pet Name.-----');
    WHEN EX_NULL_PET_AGE THEN
        DBMS_OUTPUT.PUT_LINE('-----Invalid Pet Age.-----');
    WHEN EX_NULL_PET_GENDER THEN
        DBMS_OUTPUT.PUT_LINE('-----Invalid Pet Gender.-----');
    WHEN EX_NULL_PET_BREED THEN
        DBMS_OUTPUT.PUT_LINE('-----Invalid Pet Breed.-----');
    WHEN EX_NULL_PET_COLOR THEN
        DBMS_OUTPUT.PUT_LINE('-----Invalid Pet Color.-----');
    WHEN EX_NULL_PET_TYPE THEN
        DBMS_OUTPUT.PUT_LINE('-----Invalid Pet Type.-----');
    WHEN EX_NULL_OWNER_IC THEN
        DBMS_OUTPUT.PUT_LINE('-----Invalid Owner IC.-----');
    WHEN EX_PET_EXIST THEN
        DBMS_OUTPUT.PUT_LINE('-----This Pet Already Existed.-----');
END;
/