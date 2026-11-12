CREATE DATABASE IF NOT EXISTS newdb;
USE newdb;
CREATE TABLE IF NOT EXISTS signin (
  name     VARCHAR(100),
  gender   VARCHAR(10),
  password VARCHAR(100),
  email    VARCHAR(100),
  contact  VARCHAR(20)
);
