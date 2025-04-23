
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE surveys CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN -- ORA-00942: table or view does not exist
            RAISE;
        END IF;
END;
/

-- Create the table using Oracle data types
CREATE TABLE surveys (
    record_id NUMBER,
    month NUMBER,
    day NUMBER,
    year NUMBER,
    plot_id NUMBER,
    species_id VARCHAR2(10),
    sex VARCHAR2(1),
    hindfoot_length FLOAT,
    weight FLOAT
);

-- Drop species table if it exists
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE species CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

-- Create species table
CREATE TABLE species (
    species_id VARCHAR2(10),
    genus VARCHAR2(50),
    species VARCHAR2(50),
    taxa VARCHAR2(20)
);

-- Drop plots table if it exists
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE plots CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

-- Create plots table
CREATE TABLE plots (
    plot_id NUMBER(10),
    plot_type VARCHAR2(100)
);
