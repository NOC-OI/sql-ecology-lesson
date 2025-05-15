## Create a local Oracle Database

In order to run the SQL queries in this lesson, you need to have access to an Oracle database. You can either use a local Oracle database or connect to a remote Oracle database.

To set up a local Oracle database, follow these steps:

1. Build and run the containers:
   ```bash
   docker compose up -d
   ```

2. This command will create two Docker containers: one with the database and one with the **Adminer**,
a web-based database management tool. The Adminer container will be accessible at `localhost:8080`.

3. Open your web browser and go to `http://localhost:8080`. You will see the Adminer login page.

4. Add the credentials of the database:

    - **System**: `Oracle (beta)`
    - **Server**: `oracle`
    - **Password**: `BODC`
    - **Database**: `bodc`

5. Now you can perform SQL queries on the local Oracle database using Adminer.
