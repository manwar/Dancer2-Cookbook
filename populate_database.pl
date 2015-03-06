package My::Bookstore::Schema;

use DBIx::Class::Schema::Loader;
use base qw(DBIx::Class::Schema::Loader);

package main;

my $schema = My::Bookstore::Schema->connect('dbi:SQLite:dbname=bookstore.db');

$schema->populate(
    'Author', [
        ['firstname', 'lastname'],
        ['Ian M.',    'Banks'   ],
        ['Richard',   'Matheson'],
        ['Frank',     'Herbert' ],
    ]);

my @books_list = (
    ['Consider Phlebas',    'Banks'   ],
    ['The Player of Games', 'Banks'   ],
    ['Use of Weapons',      'Banks'   ],
    ['Dune',                'Herbert' ],
    ['Dune Messiah',        'Herbert' ],
    ['Children of Dune',    'Herbert' ],
    ['The Night Stalker',   'Matheson'],
    ['The Night Strangler', 'Matheson'],
    );

# transform author names into ids
foreach (@books_list) {
    $_->[1] = $schema->resultset('Author')->find({ lastname => $_->[1] })->id;
}

$schema->populate('Book', [['title', 'author'], @books_list ]);
