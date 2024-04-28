 /*
 Temporary tables creation - they are dropped after closing session
 */
CREATE GLOBAL TEMPORARY TABLE TMP_NAGLOWEK(
             KOD_FORMULARZA nvarchar2(7) NOT NULL,
             WARIANT_FORMULARZA number NOT NULL,
             CEL_ZLOZENIA number NOT NULL,
             DATA_WYTWORZENIA_JPK nvarchar2(100) NOT NULL,
             DATA_OD nvarchar2(100) NOT NULL,
             DATA_DO nvarchar2(100) NOT NULL,
             DOMYSLNY_KOD_WALUTY nvarchar2(3) NOT NULL,
             KOD_URZEDU number NOT NULL
) ON COMMIT DELETE ROWS;

CREATE GLOBAL TEMPORARY TABLE TMP_PODMIOT(
     NIP nvarchar2(10) NOT NULL,
     PELNA_NAZWA nvarchar2(100) NOT NULL,
     KOD_KRAJU nvarchar2(100) NOT NULL,
     WOJEWODZTWO nvarchar2(100) NOT NULL,
     POWIAT nvarchar2(100) NOT NULL,
     GMINA nvarchar2(100) NOT NULL,
     NR_DOMU number NOT NULL,
     MIEJSCOWOSC nvarchar2(100) NOT NULL,
     KOD_POCZTOWY nvarchar2(6) NOT NULL
) ON COMMIT DELETE ROWS;

CREATE GLOBAL TEMPORARY TABLE TMP_EWPWIERSZ(
             K_1 number NOT NULL,
             K_2 nvarchar2(100) NOT NULL,
             K_3 nvarchar2(100) NOT NULL,
             K_4 nvarchar2(100) NOT NULL,
             K_5 number NOT NULL,
             K_6 number NOT NULL,
             K_7 number NOT NULL,
             K_8 number NOT NULL,
             K_9 number NOT NULL,
             K_10 number NOT NULL,
             K_11 number NOT NULL,
             K_12 number NOT NULL,
             K_13 number NOT NULL,
             K_14 number NOT NULL
) ON COMMIT DELETE ROWS;

CREATE GLOBAL TEMPORARY TABLE TMP_EWPCTRL(
             LICZBA_WIERSZY number,
             SUMA_PRZYCHODOW number
) ON COMMIT DELETE ROWS;


/*
 Main tables creation -
 First - it is checked each table existence
 Second - if not exist - then create, otherwise do nothing
 */

DECLARE
    IS_TABLE_EXIST NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO IS_TABLE_EXIST
    FROM ALL_TABLES T
    WHERE T.TABLE_NAME = 'ADRES_PODMIOTU';

    IF IS_TABLE_EXIST = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE ADRES_PODMIOTU(
            PK_ADRES_PODMIOTU NUMBER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
            KOD_KRAJU nvarchar2(100) NOT NULL,
            WOJEWODZTWO nvarchar2(100) NOT NULL,
            POWIAT nvarchar2(100) NOT NULL,
            GMINA nvarchar2(100) NOT NULL,
            NR_DOMU number NOT NULL,
            MIEJSCOWOSC nvarchar2(100) NOT NULL,
            KOD_POCZTOWY nvarchar2(6) NOT NULL,
            PRIMARY KEY (PK_ADRES_PODMIOTU)
        )';
    END IF;
END;


DECLARE
    IS_TABLE_EXIST NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO IS_TABLE_EXIST
    FROM ALL_TABLES T WHERE T.TABLE_NAME = 'IDENTYFIKATOR_PODMIOTU';

    IF IS_TABLE_EXIST = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE IDENTYFIKATOR_PODMIOTU(
            PK_ID_PODMIOTU NUMBER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
            FK_ADRES_PODMIOTU NUMBER,
            NIP nvarchar2(10) NOT NULL,
            PELNA_NAZWA nvarchar2(100) NOT NULL,
            PRIMARY KEY (PK_ID_PODMIOTU),
            FOREIGN KEY (FK_ADRES_PODMIOTU) REFERENCES ADRES_PODMIOTU(PK_ADRES_PODMIOTU)
        )';
    END IF;
END;

DECLARE
    IS_TABLE_EXIST NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO IS_TABLE_EXIST
    FROM ALL_TABLES T WHERE T.TABLE_NAME = 'EWPCTRL';

    IF IS_TABLE_EXIST = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE EWPCTRL(
            PK_EWPCTRL NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
            LICZBA_WIERSZY number,
            SUMA_PRZYCHODOW number,
            PRIMARY KEY (PK_EWPCTRL)
        )';
    END IF;
END;


DECLARE
    IS_TABLE_EXIST NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO IS_TABLE_EXIST
    FROM ALL_TABLES T WHERE T.TABLE_NAME = 'EWPWIERSZ';

    IF IS_TABLE_EXIST = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE EWPWIERSZ(
            PK_EWPWIERSZ NUMBER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
            FK_EWPCTRL NUMBER,
            K_1 number NOT NULL,
            K_2 nvarchar2(100) NOT NULL,
            K_3 nvarchar2(100) NOT NULL,
            K_4 nvarchar2(100) NOT NULL,
            K_5 number NOT NULL,
            K_6 number NOT NULL,
            K_7 number NOT NULL,
            K_8 number NOT NULL,
            K_9 number NOT NULL,
            K_10 number NOT NULL,
            K_11 number NOT NULL,
            K_12 number NOT NULL,
            K_13 number NOT NULL,
            K_14 number NOT NULL,
            PRIMARY KEY (PK_EWPWIERSZ),
            FOREIGN KEY (FK_EWPCTRL) REFERENCES EWPCTRL(PK_EWPCTRL)
         )';
    END IF;
END;

DECLARE
    IS_TABLE_EXIST NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO IS_TABLE_EXIST
    FROM ALL_TABLES T WHERE T.TABLE_NAME = 'NAGLOWEK';

    IF IS_TABLE_EXIST = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE NAGLOWEK(
            PK_NAGLOWEK NUMBER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
            FK_PODMIOT NUMBER,
            FK_EWP NUMBER,
            KOD_FORMULARZA nvarchar2(7) NOT NULL,
            WARIANT_FORMULARZA number NOT NULL,
            CEL_ZLOZENIA number NOT NULL,
            DATA_WYTWORZENIA_JPK nvarchar2(100) NOT NULL,
            DATA_OD nvarchar2(100) NOT NULL,
            DATA_DO nvarchar2(100) NOT NULL,
            DOMYSLNY_KOD_WALUTY nvarchar2(3) NOT NULL,
            KOD_URZEDU number NOT NULL,
            FOREIGN KEY (FK_PODMIOT) REFERENCES IDENTYFIKATOR_PODMIOTU(PK_ID_PODMIOTU),
            FOREIGN KEY (FK_EWP) REFERENCES EWPWIERSZ(PK_EWPWIERSZ)
        )';
    END IF;
END;

/*
 Log table creation - same rule as for main tables
 */
DECLARE
    IS_TABLE_EXIST NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO IS_TABLE_EXIST
    FROM ALL_TABLES T WHERE T.TABLE_NAME = 'LOG';

    IF  IS_TABLE_EXIST = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE LOG(
                PK_LOG NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
                OPIS NVARCHAR2(100),
                DATE_TIME TIMESTAMP,
                USER_NAME NVARCHAR2(20),
                PRIMARY KEY (PK_LOG)
        )';
    END IF;
END;

/*
    Function for table deletion
        @@input - table which we want to delete
        @@return - 1 - if table found and deleted, 1 - if no operation was performed
 */
CREATE OR REPLACE FUNCTION DELETE_TABLE(delete_table IN NVARCHAR2)
RETURN NUMBER
AS
    IS_TABLE_EXISTS NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO IS_TABLE_EXISTS
    FROM ALL_TABLES T
    WHERE T.TABLE_NAME = delete_table;

    IF IS_TABLE_EXISTS > 0 THEN
        EXECUTE IMMEDIATE 'DROP TABLE :delete_table'
        USING delete_table;
    END IF;
    RETURN IS_TABLE_EXISTS;
END;


/*
    Procedure for normalizing date  -
        converts dates in naglowek to one format
 */
CREATE OR REPLACE PROCEDURE NORMALIZE_DATE AS
    CURSOR NAGLOWEK_CURSOR IS SELECT * FROM TMP_NAGLOWEK;
    CURSOR EWPWIERSZ_CURSOR IS SELECT * FROM TMP_EWPWIERSZ;
    DATA_OD DATE;
    DATA_DO DATE;
    DATA_WYTWORZENIA_JPK DATE;
    K_2 DATE;
    K_3 DATE;
BEGIN
    FOR NAG IN NAGLOWEK_CURSOR
    LOOP
        DATA_WYTWORZENIA_JPK := DATE_CONVERTER(NAG.DATA_WYTWORZENIA_JPK);
        DATA_OD := DATE_CONVERTER(NAG.DATA_OD);
        DATA_DO := DATE_CONVERTER(NAG.DATA_DO);
        UPDATE TMP_NAGLOWEK
        SET DATA_WYTWORZENIA_JPK = DATA_WYTWORZENIA_JPK,
            DATA_OD = DATA_OD, DATA_DO = DATA_DO;
    END LOOP;

    FOR WIERSZ IN EWPWIERSZ_CURSOR
    LOOP
        K_2 := DATE_CONVERTER(WIERSZ.K_2);
        K_3 := DATE_CONVERTER(WIERSZ.K_3);
        UPDATE TMP_EWPWIERSZ E
        SET E.K_2 = K_2,
            E.K_3 = K_3;
    END LOOP;
END;

/*
 Date Converter
    @@input - date which we want to convert to one specific format
    @@output - yyyy/mm/dd
 */
CREATE OR REPLACE FUNCTION DATE_CONVERTER(date_in in nvarchar2)
RETURN DATE
AS
    DATE_FORMAT_EXCEPTION EXCEPTION;
BEGIN
    IF date_in LIKE '%/%/%' THEN
        RETURN TO_DATE(date_in, 'yyyy/mm/dd');
    END IF;
    IF date_in LIKE '%.%.%' THEN
        RETURN TO_DATE(date_in, 'yyyy.mm.dd');
    END IF;

    RAISE DATE_FORMAT_EXCEPTION;

    EXCEPTION
        WHEN DATE_FORMAT_EXCEPTION THEN
            NULL;
            RETURN NULL;
END;

/*
 Function for checking if curr_date > date_input
    @@input - date which we want to check
    @@output - True - if statement is fulfilled, False - if not
 */

CREATE OR REPLACE FUNCTION DATE_NAGLOWEK_CHECKER(date_in in DATE)
RETURN BOOLEAN
AS
BEGIN
    IF date_in < TRUNC(SYSDATE) THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;

/*
 Procedure for checking data in TMP_NAGLOWEK
 */

CREATE OR REPLACE PROCEDURE CHECK_NAGLOWEK AS
    IS_DATA_EXISTS NUMBER;
    IS_WARIANT_FORMULARZA_CORRECT NUMBER;
    IS_KOD_URZEDU_CORRECT NUMBER;
    DATE_INCORRECTION_COUNTER NUMBER;
    DATA_FORMAT_EXCEPTION EXCEPTION;
BEGIN
    /*
        Check if data exists
     */
    SELECT COUNT(*)
    INTO IS_DATA_EXISTS
    FROM TMP_NAGLOWEK;

    IF IS_DATA_EXISTS = 0 THEN
        RAISE NO_DATA_FOUND;
    END IF;

    /*
        Check if WariantFormularza is equal to 3
     */
    SELECT COUNT(*)
    INTO IS_WARIANT_FORMULARZA_CORRECT
    FROM TMP_NAGLOWEK
    WHERE WARIANT_FORMULARZA != 3;

    IF IS_WARIANT_FORMULARZA_CORRECT != 0 THEN
        RAISE DATA_FORMAT_EXCEPTION;
    END IF;

    /*
        Check if DataOf is earlier than DataDo
     */
    SELECT COUNT(*)
    INTO DATE_INCORRECTION_COUNTER
    FROM TMP_NAGLOWEK
    WHERE DATA_OD >= DATA_DO;

    IF DATE_INCORRECTION_COUNTER > 0 THEN
        RAISE DATA_FORMAT_EXCEPTION;
    END IF;

    /*
        Check futures dates
     */
    DATE_INCORRECTION_COUNTER  := 0;
    SELECT COUNT(*)
    INTO DATE_INCORRECTION_COUNTER
    FROM TMP_NAGLOWEK
    WHERE DATA_DO >= CURRENT_DATE;

    IF DATE_INCORRECTION_COUNTER > 0 THEN
        RAISE DATA_FORMAT_EXCEPTION;
    END IF;


    DATE_INCORRECTION_COUNTER := 0;

    SELECT COUNT(*)
    INTO DATE_INCORRECTION_COUNTER
    FROM TMP_NAGLOWEK
    WHERE DATA_WYTWORZENIA_JPK > TMP_NAGLOWEK.DATA_DO;

    IF DATE_INCORRECTION_COUNTER > 0 THEN
        RAISE DATA_FORMAT_EXCEPTION;
    END IF;

    /*
        Check if KOD_URZEDU is in correct range
     */
    SELECT COUNT(*)
    INTO IS_KOD_URZEDU_CORRECT
    FROM TMP_NAGLOWEK
    WHERE KOD_URZEDU < 1000 OR KOD_URZEDU >= 10000;

    IF IS_KOD_URZEDU_CORRECT != 0 THEN
        RAISE DATA_FORMAT_EXCEPTION;
    END IF;

EXCEPTION
    WHEN DATA_FORMAT_EXCEPTION THEN
        INSERT INTO LOG(OPIS, DATE_TIME, USER_NAME)
        VALUES ('Error occured during processing naglowek! Invalid data!', CURRENT_TIMESTAMP, USER);
    WHEN NO_DATA_FOUND THEN
        INSERT INTO LOG(OPIS, DATE_TIME, USER_NAME)
        VALUES ('No data provided!', CURRENT_TIMESTAMP, USER);
END;

/*
 Procedure for checking data in TMP_PODMIOT
 */
CREATE OR REPLACE PROCEDURE CHECK_PODMIOT
AS
    INCORRECT_NIP_COUNTER NUMBER;
    INCORRECT_KOD_POCZTOWY_COUNTER NUMBER;
    DATA_FORMAT_EXCEPTION EXCEPTION;
BEGIN
    SELECT COUNT(*)
    INTO INCORRECT_NIP_COUNTER
    FROM TMP_PODMIOT
    WHERE LENGTH(NIP) != 10;

    IF INCORRECT_NIP_COUNTER > 0 THEN
        RAISE DATA_FORMAT_EXCEPTION;
    END IF;

    SELECT COUNT(*)
    INTO INCORRECT_KOD_POCZTOWY_COUNTER
    FROM TMP_PODMIOT
    WHERE REGEXP_LIKE('[0-9][0-9]-[0-9][0-9][0-9]', KOD_POCZTOWY);

    IF INCORRECT_KOD_POCZTOWY_COUNTER != 0 THEN
        RAISE DATA_FORMAT_EXCEPTION;
    END IF;

    EXCEPTION
        WHEN DATA_FORMAT_EXCEPTION THEN
            INSERT INTO LOG (OPIS, DATE_TIME, USER_NAME)
            VALUES ('Podmiot is invalid!', CURRENT_TIMESTAMP, USER);
END;

/*
 Procedure for checking data in TMP_EWPWIERSZ
 */
CREATE OR REPLACE PROCEDURE CHECK_EWPWIERSZ
AS
    K_1_DUPLICATES NUMBER;
    CURSOR EWP_WIERSZ_CURSOR IS SELECT * FROM TMP_EWPWIERSZ;
    K_14_CURR_SUM NUMBER;
    EWP_WIERSZ_DATA_ERROR EXCEPTION;
BEGIN
    /*
        Check if Liczba Porzadkowa is different for each record
     */
    SELECT COUNT(*)
    INTO K_1_DUPLICATES
    FROM (
        SELECT COUNT(*)
        FROM TMP_EWPWIERSZ
        GROUP BY K_1
        HAVING COUNT(*) > 1
    );

    IF K_1_DUPLICATES > 0 THEN
        RAISE EWP_WIERSZ_DATA_ERROR;
    END IF;

    /*
        Check if K_14 is sum of for(K_5..K_13)
        Note: PL/SQL automatically open/close cursor
    */
    FOR EWP IN EWP_WIERSZ_CURSOR
    LOOP
            K_14_CURR_SUM := 0;
            K_14_CURR_SUM := EWP.K_5 + EWP.K_6 + EWP.K_7 + EWP.K_8 + EWP.K_9 + EWP.K_10 + EWP.K_11 + EWP.K_12 + EWP.K_13;
            IF K_14_CURR_SUM != EWP.K_14 THEN
                RAISE EWP_WIERSZ_DATA_ERROR;
            END IF;
    END LOOP;

    EXCEPTION
        WHEN EWP_WIERSZ_DATA_ERROR THEN
            INSERT INTO LOG(opis, date_time, user_name)
            VALUES ('Invalid EWP Wiersz!', CURRENT_TIMESTAMP, USER);
END;



/*
 Data migration between TMP_PODMIOT and Podmiot
 */
CREATE OR REPLACE PROCEDURE DATA_MIGRATION_ADRES
AS
    CURSOR INSERT_PODMIOT_CURSOR IS SELECT * FROM TMP_PODMIOT;
    ID_ADRES_PODMIOTU NUMBER;
BEGIN

    FOR EL IN INSERT_PODMIOT_CURSOR
    LOOP
        INSERT INTO ADRES_PODMIOTU
        (KOD_KRAJU, WOJEWODZTWO, POWIAT, GMINA, NR_DOMU, MIEJSCOWOSC, KOD_POCZTOWY)
        VALUES (EL.KOD_KRAJU, EL.WOJEWODZTWO, EL.POWIAT, EL.GMINA, EL.NR_DOMU, EL.MIEJSCOWOSC, EL.KOD_POCZTOWY);

        SELECT PK_ADRES_PODMIOTU
        INTO ID_ADRES_PODMIOTU
        FROM ADRES_PODMIOTU P
        WHERE P.PK_ADRES_PODMIOTU = (SELECT MAX(PK_ADRES_PODMIOTU) FROM ADRES_PODMIOTU);

        INSERT INTO IDENTYFIKATOR_PODMIOTU
        (FK_ADRES_PODMIOTU, NIP, PELNA_NAZWA)
        VALUES (ID_ADRES_PODMIOTU, EL.NIP, EL.PELNA_NAZWA);
    END LOOP;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK TO BEFORE_MIGRATION;
END;

/*
 Data migration between TMP_EWPCTRL and EWPCTRL
*/
CREATE OR REPLACE PROCEDURE DATA_MIGRATION_EWPCTRL
AS
    CURSOR INSERT_EWPCTRL_CURSOR IS SELECT * FROM TMP_EWPCTRL;
BEGIN

    FOR EL IN INSERT_EWPCTRL_CURSOR
    LOOP
        INSERT INTO EWPCTRL
        (LICZBA_WIERSZY, SUMA_PRZYCHODOW)
        VALUES (EL.LICZBA_WIERSZY, EL.SUMA_PRZYCHODOW);
    END LOOP;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK TO BEFORE_MIGRATION;
END;

/*
 Data migration between TMP_EWPWIERSZ and EWPWIERSZ
*/
CREATE OR REPLACE PROCEDURE DATA_MIGRATION_EWPWIERSZ
AS
    AMOUNT_OF_INSERTED_DATA NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO AMOUNT_OF_INSERTED_DATA
    FROM TMP_EWPCTRL;

    INSERT INTO EWPWIERSZ( FK_EWPCTRL, K_1, K_2, K_3, K_4, K_5, K_6, K_7, K_8, K_9, K_10, K_11, K_12, K_13, K_14)
    SELECT (SELECT E.PK_EWPCTRL FROM EWPCTRL E WHERE E.PK_EWPCTRL >
            (SELECT MAX(PK_EWPCTRL) FROM EWPCTRL ) - AMOUNT_OF_INSERTED_DATA),
           K_1, K_2, K_3, K_4, K_5, K_6, K_7, K_8, K_9, K_10, K_11, K_12, K_13, K_14
    FROM TMP_EWPWIERSZ;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK TO BEFORE_MIGRATION;
END;

/*
 Data migration between TMP_NAGLOWEK and NAGLOWEK
*/
CREATE OR REPLACE PROCEDURE DATA_MIGRATION_NAGLOWEK
AS
    AMOUNT_OF_INSERTED_DATA NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO AMOUNT_OF_INSERTED_DATA
    FROM TMP_NAGLOWEK;

    INSERT INTO NAGLOWEK
    (FK_PODMIOT, FK_EWP, KOD_FORMULARZA, WARIANT_FORMULARZA, CEL_ZLOZENIA, DATA_WYTWORZENIA_JPK, DATA_OD, DATA_DO, DOMYSLNY_KOD_WALUTY, KOD_URZEDU)
    SELECT
    (SELECT P.PK_ID_PODMIOTU FROM IDENTYFIKATOR_PODMIOTU P WHERE P.PK_ID_PODMIOTU >
                (SELECT MAX(PK_ID_PODMIOTU) FROM IDENTYFIKATOR_PODMIOTU) - AMOUNT_OF_INSERTED_DATA),
    (SELECT E.PK_EWPWIERSZ FROM EWPWIERSZ E WHERE E.PK_EWPWIERSZ >
                (SELECT MAX(PK_EWPWIERSZ) FROM EWPWIERSZ ) - AMOUNT_OF_INSERTED_DATA),
    KOD_FORMULARZA, WARIANT_FORMULARZA, CEL_ZLOZENIA, DATA_WYTWORZENIA_JPK, DATA_OD, DATA_DO, DOMYSLNY_KOD_WALUTY, KOD_URZEDU
    FROM TMP_NAGLOWEK;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK TO BEFORE_MIGRATION;
END;

/*
    Trigger - occurs after succesful migration
 */
CREATE OR REPLACE TRIGGER ON_SUCCES_MIGRATION
AFTER INSERT ON NAGLOWEK
BEGIN
    INSERT INTO LOG(opis, date_time, user_name)
    VALUES ('Data migrated succesfully!', CURRENT_TIMESTAMP , USER);
END;

/*
 View for selecting all JPK elements
 */
CREATE VIEW JPK AS
  SELECT *
    FROM NAGLOWEK N
    INNER JOIN (
        SELECT * FROM
        IDENTYFIKATOR_PODMIOTU I_P
        INNER JOIN ADRES_PODMIOTU AP
        ON I_P.FK_ADRES_PODMIOTU = AP.PK_ADRES_PODMIOTU
    ) P
    ON N.FK_PODMIOT = P.PK_ID_PODMIOTU
    INNER JOIN (
        SELECT * FROM
        EWPWIERSZ E
        INNER JOIN EWPCTRL ECTRL
        ON E.FK_EWPCTRL = ECTRL.PK_EWPCTRL
    ) EWP
    ON N.FK_EWP = EWP.PK_EWPCTRL;

/*
 Interface declaration for basic operations on JPK
 */
CREATE PACKAGE JPK_EWP AS
    PROCEDURE get_all_jpk_ordered_by_creation_date;
    PROCEDURE get_all_jpk_grouped_by_nip;
    PROCEDURE get_all_logs;
END JPK_EWP;

CREATE OR REPLACE PACKAGE BODY JPK_EWP AS

    PROCEDURE get_all_jpk_ordered_by_creation_date IS
    BEGIN
        SELECT *
        FROM JPK
        ORDER BY DATA_WYTWORZENIA_JPK;
    END;

    PROCEDURE get_all_jpk_grouped_by_nip AS
    BEGIN
        SELECT NIP, COUNT(PK_NAGLOWEK) AS "ILOSC_WNIOSKOW"
        FROM JPK
        GROUP BY NIP;
    END;

    PROCEDURE get_all_logs AS
    BEGIN
        SELECT *
        FROM LOG
        ORDER BY PK_LOG DESC;
    END;
END JPK_EWP;

/*
    Procedure mapping all tables to XML format
 */
CREATE OR REPLACE PROCEDURE XML_MAPPER AS
    jpk_ewp_xml XMLTYPE;
BEGIN
    SELECT XMLELEMENT(
        "JPK_EWP",
        XMLELEMENT(
            "NAGLOWEK",
            XMLFOREST(
                KOD_FORMULARZA,
                WARIANT_FORMULARZA,
                CEL_ZLOZENIA,
                DATA_WYTWORZENIA_JPK,
                DATA_OD,
                DATA_DO,
                DOMYSLNY_KOD_WALUTY,
                KOD_URZEDU
            )
        ),
        XMLELEMENT(
            "PODMIOT1",
            XMLFOREST(
                NIP,
                PELNA_NAZWA
            ),
            XMLFOREST(
                KOD_KRAJU,
                WOJEWODZTWO,
                POWIAT,
                GMINA,
                NR_DOMU,
                MIEJSCOWOSC,
                KOD_POCZTOWY
            )
        ),
        XMLELEMENT(
            "EWP",
            XMLELEMENT(
                "EWP_WIERSZ",
                XMLFOREST(
                    K_1 AS "K_1",
                    K_2 AS "K_2",
                    K_3,
                    K_4,
                    K_5,
                    K_6,
                    K_7,
                    K_8,
                    K_9,
                    K_10,
                    K_11,
                    K_12,
                    K_13,
                    K_14
                )
            ),
            XMLELEMENT(
                "EWP_CTRL",
                XMLFOREST(
                    LICZBA_WIERSZY,
                    SUMA_PRZYCHODOW
                )
            )
        )
    )
    INTO jpk_ewp_xml
    FROM NAGLOWEK N
    INNER JOIN (
        SELECT *
        FROM IDENTYFIKATOR_PODMIOTU I_P
        INNER JOIN ADRES_PODMIOTU A_P
        ON I_P.FK_ADRES_PODMIOTU = A_P.PK_ADRES_PODMIOTU
    ) P
    ON N.FK_PODMIOT = P.PK_ID_PODMIOTU
    INNER JOIN (
        SELECT *
        FROM EWPWIERSZ EWP
        INNER JOIN EWPCTRL CTRL
        ON EWP.FK_EWPCTRL =  CTRL.PK_EWPCTRL
    ) E
    ON N.FK_EWP = E.PK_EWPWIERSZ;
END;

/*
 Example execution
 */
INSERT INTO TMP_NAGLOWEK VALUES('1', '3', '1', '2024/04/01', '2023/03/01', '2024/04/01', 'PLN', '6428');
INSERT INTO TMP_PODMIOT VALUES('1234567891','Budimex', 'PL', 'LUB', 'radzyński', 'Radzyń Podlaski', '100', 'Radzyń Podlaski', '21-300');
INSERT INTO TMP_EWPWIERSZ VALUES(1, '01/04/2024', '01/04/2023', '20000', 8300, 8500, 8600, 8750, 8800, 9000, 9150, 9450, 9700, 80250);
INSERT INTO TMP_EWPCTRL VALUES(10, 80250);

BEGIN
    CHECK_NAGLOWEK();
END;

BEGIN
    CHECK_PODMIOT();
END;

BEGIN
    CHECK_EWPWIERSZ();
END;


SELECT * FROM TMP_NAGLOWEK;
SELECT * FROM TMP_EWPCTRL;
SELECT * FROM TMP_EWPWIERSZ;
SELECT * FROM TMP_PODMIOT;

/*
 When exception occurs during data migration all changes are rolled back to this point
 */
SAVEPOINT BEFORE_MIGRATION;

BEGIN
   DATA_MIGRATION_ADRES();
   DATA_MIGRATION_EWPCTRL();
   DATA_MIGRATION_EWPWIERSZ();
   DATA_MIGRATION_NAGLOWEK();
END;

/*
    Committing results
 */
COMMIT;

SELECT XMLELEMENT(
    "tns:JPK",
    XMLELEMENT(
        "tns:Naglowek",
        XMLFOREST(
            KOD_FORMULARZA AS "tns:KodFormularza",
            WARIANT_FORMULARZA AS "tns:WariantFormularza",
            CEL_ZLOZENIA AS "tns:CelZlozenia",
            DATA_WYTWORZENIA_JPK AS "tns:DataWytworzeniaJPK",
            DATA_OD AS "tns:DataOd",
            DATA_DO AS "tns:DataDo",
            DOMYSLNY_KOD_WALUTY AS "tns:DomyslnyKodWaluty",
            KOD_URZEDU AS "tns:KodUrzedu"
        )
    ),
    XMLELEMENT(
        "tns:Podmiot1",
        XMLELEMENT("tns:IdentyfikatorPodmiotu",
            XMLFOREST(
                NIP AS "tns:NIP",
                PELNA_NAZWA AS "tns:PelnaNazwa"
            )
        ),
        XMLELEMENT("tns:AdresPodmiotu",
            XMLFOREST(
                KOD_KRAJU AS "tns:KodKraju",
                WOJEWODZTWO AS "tns:Wojewodztwo",
                POWIAT AS "tns:Powiat",
                GMINA AS "tns:Gmina",
                NR_DOMU AS "tns:NrDomu",
                MIEJSCOWOSC AS "tns:Miejscowosc",
                KOD_POCZTOWY AS "tns:KodPocztowy"
            )
        )
    ),
    XMLELEMENT(
        "EWPWiersz" AS "tns:EWPWiersz",
        XMLFOREST(
            K_1 AS "tns:K_1",
            K_2 AS "tns:K_2",
            K_3 AS "tns:K_3",
            K_4 AS "tns:K_4",
            K_5 AS "tns:K_5",
            K_6 AS "tns:K_6",
            K_7 AS "tns:K_7",
            K_8 AS "tns:K_8",
            K_9 AS "tns:K_9",
            K_10 AS "tns:K_10",
            K_11 AS "tns:K_11",
            K_12 AS "tns:K_12",
            K_13 AS "tns:K_13",
            K_14 AS "tns:K_14",
        )
    ),
    XMLELEMENT(
        "EWPCtrl" AS "tns:EWPCtrl",
        XMLFOREST(
            LICZBA_WIERSZY AS "tns:LiczbaWierszy",
            SUMA_PRZYCHODOW AS "tns:SumaPrzychodow"
        )
    )
) AS "tns:JPK"
FROM NAGLOWEK N
INNER JOIN (
    SELECT *
    FROM IDENTYFIKATOR_PODMIOTU I_P
    INNER JOIN ADRES_PODMIOTU A_P
    ON I_P.FK_ADRES_PODMIOTU = A_P.PK_ADRES_PODMIOTU
) P
ON N.FK_PODMIOT = P.PK_ID_PODMIOTU
INNER JOIN (
    SELECT *
    FROM EWPWIERSZ EWP
    INNER JOIN EWPCTRL CTRL
    ON EWP.FK_EWPCTRL =  CTRL.PK_EWPCTRL
) E
ON N.FK_EWP = E.PK_EWPWIERSZ;

/*
Output:

<tns:JPK>
    <tns:Naglowek>
        <tns:KodFormularza>1</tns:KodFormularza>
        <tns:WariantFormularza>3</tns:WariantFormularza>
        <tns:CelZlozenia>1</tns:CelZlozenia>
        <tns:DataWytworzeniaJPK>2024/04/01</tns:DataWytworzeniaJPK>
        <tns:DataOd>2023/03/01</tns:DataOd>
        <tns:DataDo>2024/04/01</tns:DataDo>
        <tns:DomyslnyKodWaluty>PLN</tns:DomyslnyKodWaluty>
        <tns:KodUrzedu>6428</tns:KodUrzedu>
    </tns:Naglowek>
    <tns:Podmiot1>
        <tns:IdentyfikatorPodmiotu>
            <tns:NIP>1234567891</tns:NIP>
            <tns:PelnaNazwa>Budimex</tns:PelnaNazwa>
        </tns:IdentyfikatorPodmiotu>
        <tns:AdresPodmiotu>
            <tns:KodKraju>PL</tns:KodKraju>
            <tns:Wojewodztwo>LUB</tns:Wojewodztwo>
            <tns:Powiat>radzyński</tns:Powiat>
            <tns:Gmina>Radzyń Podlaski</tns:Gmina>
            <tns:NrDomu>100</tns:NrDomu>
            <tns:Miejscowosc>Radzyń Podlaski</tns:Miejscowosc>
            <tns:KodPocztowy>21-300</tns:KodPocztowy>
        </tns:AdresPodmiotu>
    </tns:Podmiot1>
    <tns:EWPWiersz>
        <tns:K_1>1</tns:K_1>
        <tns:K_2>01/04/2024</tns:K_2>
        <tns:K_3>01/04/2023</tns:K_3>
        <tns:K_4>20000</tns:K_4>
        <tns:K_5>8300</tns:K_5>
        <tns:K_6>8500</tns:K_6>
        <tns:K_7>8600</tns:K_7>
        <tns:K_8>8750</tns:K_8>
        <tns:K_9>8800</tns:K_9>
        <tns:K_10>9000</tns:K_10>
        <tns:K_11>9150</tns:K_11>
        <tns:K_12>9450</tns:K_12>
        <tns:K_13>9700</tns:K_13>
        <tns:K_14>80250</tns:K_14>
    </tns:EWPWiersz>
     <tns:EWPCtrl>
         <tns:LiczbaWierszy>10</tns:LiczbaWierszy>
         <tns:SumaPrzychodow>80250</tns:SumaPrzychodow>
     </tns:EWPCtrl>
 </tns:JPK>
 */

 /*
    Clearing all tables
  */
TRUNCATE TABLE NAGLOWEK;
TRUNCATE TABLE ADRES_PODMIOTU;
TRUNCATE TABLE IDENTYFIKATOR_PODMIOTU;
TRUNCATE TABLE EWPWIERSZ;
TRUNCATE TABLE EWPCTRL;