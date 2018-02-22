CREATE OR REPLACE DIRECTORY odoengine AS '/home/oracle/scripts/odo';
GRANT READ, WRITE ON DIRECTORY odoengine TO moncsrole;
GRANT EXECUTE ON SYS.UTL_FILE TO moncs;
exit;

