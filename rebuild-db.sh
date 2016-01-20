rm relevebanque.db
rm -R Releve
sqlite3 relevebanque.db < cr-relevedb.sql
perl -w mk-relevedb-classes.pl