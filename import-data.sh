until /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P HardPasswordAsMSSQLShitRequires123! -d master -i init-db.sql
do
  sleep 1
done
echo "Initialized db"
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P HardPasswordAsMSSQLShitRequires123! -d master -i schema.sql
echo "Created schema"
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P HardPasswordAsMSSQLShitRequires123! -d master -i procedures.sql
echo "Created procedures"
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P HardPasswordAsMSSQLShitRequires123! -d master -i functions.sql
echo "Created functions"
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P HardPasswordAsMSSQLShitRequires123! -d master -i views.sql
echo "Created views"
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P HardPasswordAsMSSQLShitRequires123! -d master -i triggers.sql
echo "Created triggers"
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P HardPasswordAsMSSQLShitRequires123! -d master -i data.sql
echo "Imported data"
while [ 1 ]
do
  sleep 1
done
