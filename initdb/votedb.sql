create database votes CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

create user voteuser@'%' IDENTIFIED BY 'DcS5Gb7Gs2W#';
grant all privileges on votes.* to voteuser@'%';
flush privileges;

create table votes.votes (id INTEGER NOT NULL PRIMARY KEY auto_increment, emoji_id INTEGER NOT NULL, voting_date TIMESTAMP);