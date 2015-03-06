DROP TABLE IF EXISTS author;

CREATE TABLE author(
    id        INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    firstname TEXT    DEFAULT '' NOT NULL,
    lastname  TEXT    NOT NULL
);

CREATE UNIQUE INDEX author_idx ON author(firstname, lastname);

DROP TABLE IF EXISTS book;

CREATE TABLE book(
    id     INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    author INTEGER REFERENCES author(id),
    title  TEXT    DEFAULT '' NOT NULL
);

CREATE UNIQUE INDEX book_idx ON book(author, title);
