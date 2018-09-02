%# JDBC connector path
    javaaddpath('C:\Program Files\MySQL\mysql-connector-java-5.1.18-bin.jar')
    %# connection parameteres
    host = 'localhost'; %MySQL hostname
    user = 'root'; %MySQL username
    password = '';%MySQL password
    dbName = 'atm'; %MySQL database name
    %# JDBC parameters
    jdbcString = sprintf('jdbc:mysql://%s/%s', host, dbName);
    jdbcDriver = 'com.mysql.jdbc.Driver';
 conn = database(dbName, user , password, jdbcDriver, jdbcString); 
 if isconnection(conn)
 qry = sprintf('INSERT INTO verification(FirstName)VALUES(%asdad);',distAa,distBa,distCa,distDa);
    display(qry);
    fetch(exec(conn, qry));
 else
    display('MySql Connection Error');
end