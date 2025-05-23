---
title: Setup
---

## Setup

::::::::::::::::::::::::::::::::::::::::::  prereq

### Data

This lesson uses specific data files from the [Portal Project Teaching Database](https://figshare.com/articles/Portal_Project_Teaching_Database/1314459). To have access to the files, go to the [data location on figshare](https://figshare.com/articles/Portal_Project_Teaching_Database/1314459). You don't need to download the files, as you can open them directly from the figshare page. However, if you want to download them, you can do so by clicking on the "Download" button on the right side of the page.

See the
[Ecology Workshop Overview Page](https://datacarpentry.org/ecology-workshop/) for more details about the data set.

::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::  prereq

### Database Access

A sample schema has been set up for you in the **BODC Oracle** database. The necessary tables are already created, so no additional database setup is required.

To connect to the database, you can use one of the following tools:

* [SQL Developer](https://www.oracle.com/uk/database/sqldeveloper/technologies/download/) (recommended)
* [DBeaver](https://dbeaver.io/)
* [Adminer](https://www.adminer.org/)

All of these tools require a `TNSNAMES.ORA` file, which contains the connection details (hostname, port, and service name).

### Steps to connect:

1. **Download the TNSNAMES.ORA file**
   Go to the [TNSNAMES.ORA file location](https://github.com/NOC-OI/sql-ecology-lesson/blob/main/utils/oracle_db/TNSNAMES.ORA) and then click in the `Download Icon` to download the file. Save it in a folder on your computer.

2. **Install SQL Developer (recommended GUI)**

   * Go to the [SQL Developer download page](https://www.oracle.com/uk/database/sqldeveloper/technologies/download/).
   * Download the version that includes Java.
   * Follow the installation instructions for your OS:

     * **Windows**: Unzip the download and run `sqldeveloper.exe`.
     * **Mac**: Drag SQL Developer into the Applications folder.

3. **Launch and configure SQL Developer**

   * On first launch, you may be asked to provide the path to the Java Development Kit (JDK). If needed, download it from the [Oracle JDK download page](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html).

4. **Set the TNSNAMES.ORA path**

   * In SQL Developer, go to `Tools > Preferences > Database > Advanced`.
   * Under **TNSNAMES Directory**, browse and select the folder containing your `TNSNAMES.ORA` file.

5. **Create a new connection**
   (This step will be completed during the workshop.)

   * Click the green `+` icon in SQL Developer to create a new connection.
   * Enter the following details:

     * **Connection Name**: e.g., `PORTAL MAMMALS`
     * **Username**: Provided by your instructor
     * **Password**: Provided by your instructor
     * **Connection Type**: `TNS`
     * **Network Alias**: `LIVDV1`

> **Note**: Each participant will receive a unique username and password for querying and updating the database. Please confirm your credentials with your instructor during the session.

::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::  prereq

### Am I ready?

To confirm everything is working correctly, follow the instructions in [Episode 1](episodes/00-sql-introduction.md) of the lesson. It includes steps for connecting to the database and select the data.
You can also test your environment by referring to the section on [Relational Databases](../episodes/00-sql-introduction.md#relational-databases).

::::::::::::::::::::::::::::::::::::::::::::::::::
