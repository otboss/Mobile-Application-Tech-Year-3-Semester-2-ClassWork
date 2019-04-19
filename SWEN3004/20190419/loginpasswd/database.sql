CREATE DATABASE loginpasswd;
USE loginpasswd;

CREATE TABLE IF NOT EXISTS alembic_version ( 
    version_num VARCHAR(32) NOT NULL, 
    CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num) 
);

CREATE TABLE IF NOT EXISTS user ( 
    id INTEGER NOT NULL AUTO_INCREMENT, 
    username VARCHAR(64), 
    email VARCHAR(120), 
    profilePic LONGTEXT,
    password_hash VARCHAR(128), 
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    PRIMARY KEY (id) 
);

CREATE TABLE IF NOT EXISTS post ( 
    id INTEGER NOT NULL AUTO_INCREMENT, 
    body VARCHAR(140),
    user_id INTEGER, 
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    PRIMARY KEY (id), 
    FOREIGN KEY(user_id) REFERENCES user (id) 
);