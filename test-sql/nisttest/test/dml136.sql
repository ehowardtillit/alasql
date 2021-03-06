-- MODULE  DML136  

-- SQL Test Suite, V6.0, Interactive SQL, dml136.sql
-- 59-byte ID
-- TEd Version #

-- AUTHORIZATION FLATER            

   SELECT USER FROM HU.ECCO;
-- RERUN if USER value does not match preceding AUTHORIZATION comment
   ROLLBACK WORK;

-- date_time print

-- TEST:0696 Many TSQL features #5:  Video Game Scores!

  Create Table FOOM (
  PLAYER_NO Int,
  LEVL Int,
  PCT_BLOWN_UP Float,
  TIME_TO_FINISH Interval Minute to Second);
-- PASS:0696 If table is created?

  COMMIT;

  Create Table SPLAT_EM (
  PLAYER_NO Int,
  MAX_LEVEL Int,
  SCORE Decimal (6));
-- PASS:0696 If table is created?

  COMMIT;

  CREATE VIEW FOOM_AVG
  (PLAYER_NO, FOOM_SCORE1, FOOM_SCORE2) AS
  SELECT PLAYER_NO,
    AVG (PCT_BLOWN_UP),
    1.0 / AVG (EXTRACT (SECOND FROM
      CAST (TIME_TO_FINISH AS INTERVAL SECOND)))
  FROM FOOM GROUP BY PLAYER_NO;
-- PASS:0696 If view is created?

  COMMIT;

  CREATE VIEW SPLAT_AVG
  (PLAYER_NO, SPLAT_SCORE) AS
  SELECT PLAYER_NO, AVG (SCORE)
  FROM SPLAT_EM GROUP BY PLAYER_NO;
-- PASS:0696 If view is created?

  COMMIT;

  CREATE VIEW MAXIMA
  (MAX_FOOM_SCORE1, MAX_FOOM_SCORE2, MAX_SPLAT_SCORE) AS
  SELECT MAX (FOOM_SCORE1), MAX (FOOM_SCORE2),
  MAX (SPLAT_SCORE) FROM FOOM_AVG, SPLAT_AVG;
-- PASS:0696 If view is created?

  COMMIT;

  CREATE VIEW ALLSCORES
  (PLAYER_NO, SPLAT_SCORE, FOOM_SCORE1, FOOM_SCORE2,
  MAX_FOOM_SCORE1, MAX_FOOM_SCORE2, MAX_SPLAT_SCORE) AS
  SELECT PLAYER_NO, SPLAT_AVG.*, FOOM_AVG.*, MAXIMA.*
  FROM FOOM_AVG NATURAL JOIN SPLAT_AVG, MAXIMA;
-- PASS:0696 If view is created?

  COMMIT;

  CREATE VIEW NORMALIZED_AVGS
  (PLAYER_NO, GENERIC_AVG) AS
  SELECT PLAYER_NO,
    (SPLAT_SCORE / MAX_SPLAT_SCORE +
     FOOM_SCORE1 / MAX_FOOM_SCORE1 +
     FOOM_SCORE2 / MAX_FOOM_SCORE2) / 3.0
  FROM ALLSCORES;
-- PASS:0696 If view is created?

  COMMIT;

  INSERT INTO FOOM VALUES (1, 1, 100.0, INTERVAL '10:54' MINUTE TO SECOND);
-- PASS:0696 If 1 row is inserted?

  INSERT INTO FOOM VALUES (1, 1, 98.0, INTERVAL '09:48' MINUTE TO SECOND);
-- PASS:0696 If 1 row is inserted?

  INSERT INTO FOOM VALUES (1, 2, 96.5, INTERVAL '22:10' MINUTE TO SECOND);
-- PASS:0696 If 1 row is inserted?

  INSERT INTO FOOM VALUES (2, 1, 54.1, INTERVAL '15:22' MINUTE TO SECOND);
-- PASS:0696 If 1 row is inserted?

  INSERT INTO FOOM VALUES (2, 1, 65.7, INTERVAL '14:27' MINUTE TO SECOND);
-- PASS:0696 If 1 row is inserted?

  INSERT INTO FOOM VALUES (2, 1, 87.0, INTERVAL '16:09' MINUTE TO SECOND);
-- PASS:0696 If 1 row is inserted?

  INSERT INTO SPLAT_EM VALUES (1, 5, 10820);
-- PASS:0696 If 1 row is inserted?

  INSERT INTO SPLAT_EM VALUES (1, 6, 14220);
-- PASS:0696 If 1 row is inserted?

  INSERT INTO SPLAT_EM VALUES (2, 8, 58762);
-- PASS:0696 If 1 row is inserted?

  INSERT INTO SPLAT_EM VALUES (2, 8, 62900);
-- PASS:0696 If 1 row is inserted?

  INSERT INTO SPLAT_EM VALUES (2, 7, 40282);
-- PASS:0696 If 1 row is inserted?

  SELECT * FROM NORMALIZED_AVGS
  ORDER BY PLAYER_NO;
-- PASS:0696 If 2 rows selected with ordered rows and column values?
-- PASS:0696    1   0.74398 +- 0.0001 ?
-- PASS:0696    2   0.87826 +- 0.0001 ?

  ROLLBACK;

  DROP TABLE FOOM CASCADE;
-- PASS:0696 If table and 4 views are dropped?

  COMMIT;

  DROP TABLE SPLAT_EM CASCADE;
-- PASS:0696 If table and view are dropped?

  COMMIT;

-- END TEST >>> 0696 <<< END TEST
-- *************************************************////END-OF-MODULE
