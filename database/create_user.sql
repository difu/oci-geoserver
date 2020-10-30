DROP USER geoserver CASCADE;

CREATE USER geoserver IDENTIFIED BY "your_top_secret_password";

GRANT connect,
    CREATE TABLE
TO geoserver;

ALTER USER geoserver
    QUOTA 5G ON data;