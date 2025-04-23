---
title: Setup
---

## Setup

::::::::::::::::::::::::::::::::::::::::::  prereq

### Data

This lesson uses specific data files from the [Portal Project Teaching Database](https://figshare.com/articles/Portal_Project_Teaching_Database/1314459). While the original lesson was designed for a different database format (SQLite), we’ve adapted it and created a modified copy.
To access the data, visit the [OneDrive data folder](https://nocacuk-my.sharepoint.com/:f:/g/personal/tobfer_noc_ac_uk/Episk-ovbHdAv-CwEsJppjcB4Sei4kId3rGezf2qZiv8Qw?e=bAGdol) and click the **Download** button to download the ZIP file.

If you are working on this lesson on your own, you can move the zipped data file to
anywhere on your computer where it is easy to access, and unzip the files. If you
are working on this lesson as part of a workshop, your instructor may advise you
to unzip the data files in a specific location.

See the
[Ecology Workshop Overview Page](https://datacarpentry.org/ecology-workshop/) for more details about the data set.

::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::  prereq

### Database Access

For this lesson, we've set up a sample database using **Oracle-XE** along with **[Adminer](https://www.adminer.org/en/)**, a lightweight, web-based database management tool. Adminer functions similarly to tools like phpMyAdmin or DBeaver, but it's much easier to set up and use.

The database and tables have already been created for you—no setup is required on your end. Your task is simply to connect to the database using Adminer.

To do this, open your web browser and navigate to: [https://oracle-access.shop/](https://oracle-access.shop/). This will take you to the Adminer login screen. Use the following credentials:

- **System**: Oracle (beta)
- **Server**: `//oracle-service.default.svc.cluster.local:1521/PORTAL_MAMMALS`
- **Username**: `BODC`
- **Password**: `bodc`

> **Note:** These credentials provide access to the main database, which already contains preloaded data. During the workshop, you will receive your own individual username and password, which you’ll use to add and edit data. Please confirm your personal login details with your instructor.

::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::  prereq

### Am I ready?

The [first lesson episode](episodes/00-sql-introduction.md) has instructions
on loading the data in Adminer. To test your setup, you can follow the instructions for importing your data into DB Browser under the sections [Relational
Databases](../episodes/00-sql-introduction.md#relational-databases) or [Import](../episodes/00-sql-introduction.md#import).

::::::::::::::::::::::::::::::::::::::::::::::::::
