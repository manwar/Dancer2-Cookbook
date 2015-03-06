package bookstore;

use Data::Dumper;
use Dancer2;
use Dancer2::Plugin::DBIC qw(schema resultset rset);

=head1 NAME

Dancer2 Cookbook - BookStore

=head1 VERSION

Version 0.1

=head1 DESCRIPTION

=head1 METHODS

=head1 AUTHOR

Mohammad S Anwar, C<< <mohammad.anwar at yahoo.com> >>

=cut

$bookstore::VERSION   = '0.1';
$bookstore::AUTHORITY = 'cpan:MANWAR';

get '/' => sub {
    template 'list' => { results => _list() };
};

get '/list' => sub {
    template 'list' => { results => _list() };
};

get '/search' => sub {
    template 'search';
};

post '/search' => sub {
    my $query   = param('query');
    my $results = [];
    $results    = _search($query) if (length $query);

    template 'result' => { query => $query, results => $results };
};

get '/delete/author' => sub {

    my $bookstore_schema = schema 'bookstore';
    my $authors = [];
    my $all_authors = _get_authors();
    foreach my $author (@$all_authors) {
        my @books = $bookstore_schema->resultset('Book')->search({ author => $author->{id} });
        push @$authors, $author unless (scalar(@books));
    }

    template 'delete_author' => { authors => $authors };
};

post '/delete/author' => sub {

    my $authors = param('author');
    my $bookstore_schema = schema 'bookstore';
    my $resultset = $bookstore_schema->resultset('Author')->search({ id => $authors });
    $resultset->delete_all;

    template 'list' => { results => _list() };
};

get '/add/author' => sub {
    template 'add_author';
};

post '/add/author' => sub {
    my $firstname = param('firstname');
    my $lastname  = param('lastname');
    _add_author($firstname, $lastname);

    template 'list' => { results => _list() };
};

get '/delete/book' => sub {

    template 'delete_book' => { books => _get_books() };
};

post '/delete/book' => sub {
    my $books = param('book');
    my $bookstore_schema = schema 'bookstore';
    my $resultset = $bookstore_schema->resultset('Book')->search({ id => $books });
    $resultset->delete_all;

    template 'list' => { results => _list() };
};

get '/add/book' => sub {

    template 'add_book' => { authors => _get_authors() };
};

post '/add/book' => sub {
    my $author = param('author');
    my $title  = param('title');
    _add_book($author, $title);

    template 'list' => { results => _list() };
};

#
#
# PRIVATE METHODS

sub _search {
    my ($query) = @_;

    my $bookstore_schema = schema 'bookstore';

    my $results = {};
    my @authors = $bookstore_schema->resultset('Author')->search(
        { -or => [ firstname => { like => "%$query%" },
                   lastname  => { like => "%$query%" },
                 ],
        });

    foreach my $author (@authors) {
        my $author_name = join(' ', $author->firstname, $author->lastname);
        $results->{$author_name} = [];
    }

    my @books = $bookstore_schema->resultset('Book')->search(
        { title => { like => "%$query%" } });

    foreach my $book (@books) {
        my $author_name = join(' ', $book->author->firstname, $book->author->lastname);
        push @{$results->{$author_name}}, $book->title;
    }

    my $output = [];
    foreach (keys %$results) {
        push @$output, { author => $_, books => $results->{$_} };
    }

    return $output;
}

sub _list {

    my $bookstore_schema = schema 'bookstore';

    my $results = {};
    my @authors = $bookstore_schema->resultset('Author')->search();
    my @books   = $bookstore_schema->resultset('Book')->search();

    foreach my $author (@authors) {
        my $author_name = join(' ', $author->firstname, $author->lastname);
        $results->{$author_name} = [];
    }

    foreach my $book (@books) {
        my $author_name = join(' ', $book->author->firstname, $book->author->lastname);
        push @{$results->{$author_name}}, $book->title;
    }

    my $output = [];
    foreach (keys %$results) {
        push @$output, { author => $_, books => $results->{$_} };
    }

    return $output;
}

sub _add_author {
    my ($firstname, $lastname) = @_;

    my $bookstore_schema = schema 'bookstore';
    $bookstore_schema->populate(
        'Author', [ ['firstname', 'lastname'], [$firstname, $lastname] ]);
}

sub _add_book {
    my ($author, $title) = @_;

    my $bookstore_schema = schema 'bookstore';
    $bookstore_schema->populate(
        'Book', [ ['title', 'author'], [$title, $author] ]);
}

sub _get_authors {
    my $bookstore_schema = schema 'bookstore';
    my @rows = $bookstore_schema->resultset('Author')->search();

    my $authors = [];
    foreach my $author (@rows) {
        push @$authors, {
            id   => $author->id,
            name => join( " ", $author->firstname, $author->lastname)
        };
    }

    return $authors;
}

sub _get_books {
    my $bookstore_schema = schema 'bookstore';
    my @rows = $bookstore_schema->resultset('Book')->search();

    my $books = [];
    foreach my $book (@rows) {
        push @$books, {
            id     => $book->id,
            title  => $book->title,
            author => join( " ", $book->author->firstname, $book->author->lastname)
        };
    }

    return $books;
}

true;
