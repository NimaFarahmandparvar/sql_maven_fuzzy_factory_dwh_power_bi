# **Naming Conventions**

This document outlines the naming conventions used for schemas, tables, views, columns, and other objects in the data warehouse.

## **Table of Contents**

1. [General Principles](#general-principles)
2. [Stored Procedure](#stored-procedure)
---

## **General Principles**

- **Naming Conventions**: Use snake_case, with lowercase letters and underscores (`_`) to seperate words.
- **Language**: Use English for all names.

## **Stored Procedure**

- All stored procedures used for loading data must follow the naming pattern:
- **`proc_load_<layer>`**.
  
  - `<layer>`: Represents the layer being loaded, such as `bronze`, `silver`.
  - Example: 
    - `proc_load_bronze` &rarr; Stored procedure for loading data into the Bronze layer.
    - `proc_load_silver` &rarr; Stored procedure for loading data into the Silver layer.
