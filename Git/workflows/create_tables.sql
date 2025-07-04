CREATE DATABASE IF NOT EXISTS demo;

USE demo;

CREATE TABLE students (
    id    INT PRIMARY KEY AUTO_INCREMENT,
    name  VARCHAR(100),
    marks INT
);

INSERT INTO students (name, marks) VALUES
    ('Om',     85),
    ('Suresh', 90),
    ('Ramesh', 76);

3. mysql-ci.yml

name: MySQL CI

on:
  push:
    branches: [ main ]

jobs:
  mysql-job:
    runs-on: ubuntu-latest

    services:
      mysql:
        image: mysql:5.7
        env:
          MYSQL_ROOT_PASSWORD: root
        ports:
          - 3306:3306
        options: >-
          --health-cmd="mysqladmin ping --silent"
          --health-interval=10s
          --health-timeout=5s
          --health-retries=3

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Wait for MySQL to be ready
        run: |
          sleep 20
          echo "MySQL should be ready now."

      - name: Run SQL commands
        run: |
          sudo apt-get install -y mysql-client
          mysql -h 127.0.0.1 -P 3306 -u root -proot < create_tables.sql
          mysql -h 127.0.0.1 -P 3306 -u root -proot -e "USE demo; SELECT * FROM students;"
