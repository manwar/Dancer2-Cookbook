DROP TABLE IF EXISTS cpan_module_author;
DROP INDEX IF EXISTS cpan_module_author_pause_idx;
DROP INDEX IF EXISTS cpan_module_author_name_idx;

CREATE TABLE cpan_module_author(
    id          INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    pause_id    TEXT NOT NULL,
    first_name  TEXT NOT NULL,
    middle_name TEXT,
    last_name   TEXT NOT NULL
);

CREATE UNIQUE INDEX cpan_module_author_pause_idx ON cpan_module_author(pause_id);
CREATE UNIQUE INDEX cpan_module_author_name_idx  ON cpan_module_author(first_name, last_name);

DROP TABLE IF EXISTS cpan_module;
DROP INDEX IF EXISTS cpan_module_author_idx;

CREATE TABLE cpan_module(
    id           INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    author_id    INTEGER REFERENCES cpan_module_author(id),
    package_name TEXT NOT NULL
);

CREATE UNIQUE INDEX cpan_module_author_idx ON cpan_module(author_id, package_name);

DROP TABLE IF EXISTS cpan_module_detail;
DROP INDEX IF EXISTS cpan_module_detail_idx;

CREATE TABLE cpan_module_detail(
    id                 INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    module_id          INTEGER REFERENCES cpan_module(id),
    github_favourite   INTEGER DEFAULT 0 NOT NULL,
    metacpan_favourite INTEGER DEFAULT 0 NOT NULL
);

CREATE UNIQUE INDEX cpan_module_detail_idx ON cpan_module_detail(module_id);

INSERT INTO cpan_module_author(pause_id, first_name, middle_name, last_name)
     VALUES ('MANWAR', 'Mohammad', 'S', 'Anwar');

INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'Address::PostCode::Australia');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'Address::PostCode::India');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'Address::PostCode::UK');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'Address::PostCode::UserAgent');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'BankAccount::Validator::UK');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'Calendar::Bahai');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'Calendar::Hijri');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'Calendar::Persian');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'Calendar::Saka');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'Compare::Directory');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'CPAN::Search::Author');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'CPAN::Search::Tester');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'Crypt::Affine');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'Crypt::Hill');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'Crypt::Image');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'Crypt::Trifid');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'Dancer2::Plugin::Captcha');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'Dancer2::Plugin::Chain');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'Data::Password::Filter');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'Food::ECodes');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'Games::Cards::Pair');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'Games::Domino');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'Games::TicTacToe');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'IP::CountryFlag');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'IP::Info');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'Lingua::IND::Numbers');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'LWP::UserAgent::Anonymous');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'Map::Tube');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'Map::Tube::Barcelona');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'Map::Tube::CLI');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'Map::Tube::Delhi');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'Map::Tube::London');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'Map::Tube::NYC');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'Map::Tube::Plugin::Formatter');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'Map::Tube::Plugin::Graph');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'Map::Tube::Tokyo');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'MouseX::Params::Validate');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'Test::CSS');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'Test::Excel');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'Test::Internet');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'Test::Map::Tube');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'Text::MostFreqKDistance');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'WebService::Wikimapia');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'WWW::Google::APIDiscovery');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'WWW::Google::CustomSearch');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'WWW::Google::DistanceMatrix');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'WWW::Google::PageSpeedOnline');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'WWW::Google::Places');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'WWW::Google::URLShortener');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'WWW::Google::UserAgent');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'WWW::MovieReviews::NYT');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'WWW::OReillyMedia::Store');
INSERT INTO cpan_module(author_id, package_name) VALUES((SELECT id FROM cpan_module_author WHERE pause_id = 'MANWAR'), 'WWW::StatsMix');

INSERT INTO cpan_module_detail(module_id, github_favourite) VALUES ((SELECT id FROM cpan_module WHERE package_name = 'Address::PostCode::Australia'), 1);
INSERT INTO cpan_module_detail(module_id, github_favourite) VALUES ((SELECT id FROM cpan_module WHERE package_name = 'Calendar::Hijri'), 1);
INSERT INTO cpan_module_detail(module_id, github_favourite) VALUES ((SELECT id FROM cpan_module WHERE package_name = 'Crypt::Image'), 2);
INSERT INTO cpan_module_detail(module_id, github_favourite, metacpan_favourite) VALUES ((SELECT id FROM cpan_module WHERE package_name = 'Map::Tube'), 3, 2);
INSERT INTO cpan_module_detail(module_id, github_favourite, metacpan_favourite) VALUES ((SELECT id FROM cpan_module WHERE package_name = 'Map::Tube::London'), 1, 1);
INSERT INTO cpan_module_detail(module_id, github_favourite, metacpan_favourite) VALUES ((SELECT id FROM cpan_module WHERE package_name = 'Map::Tube::NYC'), 1, 1);
INSERT INTO cpan_module_detail(module_id, github_favourite, metacpan_favourite) VALUES ((SELECT id FROM cpan_module WHERE package_name = 'Map::Tube::Tokyo'), 1, 1);
INSERT INTO cpan_module_detail(module_id, github_favourite, metacpan_favourite) VALUES ((SELECT id FROM cpan_module WHERE package_name = 'Test::Excel'), 2, 1);
INSERT INTO cpan_module_detail(module_id, metacpan_favourite) VALUES ((SELECT id FROM cpan_module WHERE package_name = 'BankAccount::Validator::UK'), 1);
INSERT INTO cpan_module_detail(module_id, metacpan_favourite) VALUES ((SELECT id FROM cpan_module WHERE package_name = 'Games::Domino'), 1);
INSERT INTO cpan_module_detail(module_id, metacpan_favourite) VALUES ((SELECT id FROM cpan_module WHERE package_name = 'WebService::Wikimapia'), 1);
INSERT INTO cpan_module_detail(module_id, metacpan_favourite) VALUES ((SELECT id FROM cpan_module WHERE package_name = 'WWW::Google::APIDiscovery'), 1);
