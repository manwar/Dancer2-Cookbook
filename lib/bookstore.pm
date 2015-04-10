package bookstore;

use Data::Dumper;
use JSON;
use Try::Tiny;

use Dancer2;
use Dancer2::Plugin::DBIC qw(schema);
use Dancer2::Plugin::Ajax;
use Dancer2::Plugin::Auth::Tiny;
use Dancer2::Plugin::Passphrase;
use Dancer2::Plugin::Captcha;
use Dancer2::Plugin::Chain;

use Dancer2::Core::Error;
use Dancer2::Session::Simple;

=head1 NAME

Dancer2 Cookbook - BookStore

=head1 VERSION

Version 0.12

=head1 DESCRIPTION

=head1 METHODS

=head1 AUTHOR

Mohammad S Anwar, C<< <mohammad.anwar at yahoo.com> >>

=cut

$bookstore::VERSION   = '0.12';
$bookstore::AUTHORITY = 'cpan:MANWAR';

our $bookstore_schema = schema 'bookstore';

hook before => sub {
    printf "logged in? %s\n", session('username') ? session('username') : '-';
    if ( !session('username')
         && request->dispatch_path !~ m{^/login}
         && request->dispatch_path !~ m{^/register}
         && request->dispatch_path !~ m{^/get_captcha}
        ) {
        forward '/login', { return_url => request->dispatch_path };
    }
};

my $continent       = chain '/continent/:continent' => sub { var 'site'  => param('continent'); };
my $country         = chain '/country/:country'     => sub { var 'site'  => param('country');   };
my $event           = chain '/event/:event'         => sub { var 'event' => param('event');     };
my $continent_event = chain $continent, $event;

get chain $country, $event, '/schedule' => sub {
    return sprintf("schedule of %s in %s\n", var('event'), var('site'));
};

get chain $continent_event, '/schedule' => sub {
    return sprintf("schedule of %s in %s\n", var('event'), var('site'));
};

get chain $continent, sub { var 'temp' => var('site') },
          $country,   sub { var 'site' => join(', ', var('site'), var('temp')) },
          $event, '/schedule' => sub { return sprintf("schedule of %s in %s\n", var('event'), var('site')); };

get '/get_captcha' => sub {

    my $params = {
         new => {
             width   => 160,
             height  => 75,
             lines   => 5,
             gd_font => 'giant',
         },
         create   => [ normal => 'default' ],
         particle => [ 100 ],
         out      => { force => 'png' },
         random => _generate_captcha_keys(6),
    };

    return generate_captcha($params);
    #return generate_captcha();
};

get '/work' => sub {
    template 'work';
};

my $work_type = chain '/work/:type' => sub { var 'type' => param('type'); };
get chain $work_type, '/favourites' => sub {

    content_type 'application/json';
    my $type = var 'type';
    my ($subtitle, $tooltip, $data);

    my $title       = 'CPAN 2010 - 2015';
    my $yaxis_label = 'Favourites';
    my $series_name = 'Favourites';

    if ($type eq 'github') {
        $subtitle   = 'Source: <a href="https://github.com/Manwar">GitHub</a>';
        $tooltip    = 'Favourites (GitHub): <b>{point.y:.0f}</b>';
        $data       = _github_favourites();
    }
    elsif ($type eq 'metacpan') {
        $subtitle   = 'Source: <a href="https://metacpan.org/author/MANWAR">MetaCPAN</a>';
        $tooltip    = 'Favourites (MetaCPAN): <b>{point.y:.0f}</b>';
        $data       = _metacpan_favourites();
    }

    return _highchart($title, $subtitle, $series_name, $tooltip, $yaxis_label, $data);
};

get '/register' => sub {
    template 'register';
};

post '/register' => sub {
    my $username = params->{username};
    my $password = params->{password};
    if (defined $username && defined $password) {
        $password = passphrase($password)->generate;
        _register_user($username, $password->rfc2307());

        session username => $username;
        my $return_url = params->{return_url} || '/';
        print STDERR "Added user [$username] ...\n";
        redirect '/';
    }
    else {
        #Dancer2::Core::Error->new(
        #    response => response(),
        #    status   => 406,
        #    message  => 'Username and password required.',
        #    template => 'register')->throw;
        template 'register' => {
            error    => "Username and password required.",
            username => $username,
            password => $password
        };
    }
};

get '/login' => sub {
    template 'login' => { return_url => params->{return_url} };
};

post '/login' => sub {
    my $p = request->params;

    unless (is_valid_captcha(request->params->{captcha})) {
        return template 'login' => {
            error    => "Invalid captcha code",
            username => params->{username},
            password => params->{password}
        };
    }

    remove_captcha;

    if (_is_valid_user(params->{username}, params->{password})) {
        session username => params->{username};

        my $return_url = params->{return_url} || '/';
        print STDERR "Redirecting to [$return_url] ...\n";
        redirect $return_url;
    }
    else {
        #Dancer2::Core::Error->new(
        #    response => response(),
        #    status   => 406,
        #    message  => 'Invalid Username or password.',
        #    template => 'login')->throw;
        template 'login' => {
            error    => "Invalid username or password",
            username => params->{username},
            password => params->{password}
        };
    }
};

get '/logout' => sub {
    context->destroy_session;
    redirect '/';
};

ajax '/author/:id/books' => sub {
    my $id = params->{id};

    my $books = _get_books_by_author($id);
    my $response = "";
    foreach my $book (@$books) {
        my $book_id = $book->id;
        my $book_title = $book->title;
        $response .= qq{<input type="checkbox" name="book" value="$book_id">$book_title<br>};
    }

    content_type 'text/html';
    return $response;
};

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
    my $resultset = $bookstore_schema->resultset('Author')->search({ id => $authors });
    $resultset->delete_all;

    template 'list' => { results => _list() };
};

get '/edit/author/:id' => sub {

    my $id = params->{id};
    my @authors = $bookstore_schema->resultset('Author')->search({ id => $id });

    template 'edit_author' => {
        id        => $authors[0]->id,
        firstname => $authors[0]->firstname,
        lastname  => $authors[0]->lastname
    };
};

post '/edit/author/:id' => sub {

    my $id        = params->{id};
    my $firstname = param('firstname');
    my $lastname  = param('lastname');

    my $author = $bookstore_schema->resultset('Author')->find({ id => $id });
    $author->firstname($firstname);
    $author->lastname($lastname);
    $author->update;

    template 'list' => { results => _list() };
};

get '/add/author' => sub {
    template 'add_author';
};

post '/add/author' => sub {

    my $firstname = param('firstname');
    my $lastname  = param('lastname');
    try {
        _add_author($firstname, $lastname);
        template 'list' => { results => _list() };
    }
    catch {
        template 'add_author' => {
            error     => $_,
            firstname => $firstname,
            lastname  => $lastname
        };
    }
};

get '/delete/book' => sub {
    template 'delete_book' => { authors => _get_authors() };
};

post '/delete/book' => sub {

    my $books = param('book');
    my $resultset = $bookstore_schema->resultset('Book')->search({ id => $books });
    $resultset->delete_all;

    template 'list' => { results => _list() };
};

get '/edit/book/:id' => sub {

    my $id = params->{id};
    my $book = $bookstore_schema->resultset('Book')->find({ id => $id });

    template 'edit_book' => {
        id     => $id,
        author => join(" ", $book->author->firstname, $book->author->lastname),
        title  => $book->title
    };
};

post '/edit/book/:id' => sub {

    my $id    = params->{id};
    my $title = param('title');

    my $book = $bookstore_schema->resultset('Book')->find({ id => $id });
    $book->title($title);
    $book->update;

    template 'list' => { results => _list() };
};

get '/add/book' => sub {
    template 'add_book' => { authors => _get_authors() };
};

post '/add/book' => sub {
    my $author = param('author');
    my $title  = param('title');

    try {
        _add_book($author, $title);
        template 'list' => { results => _list() };
    }
    catch {
        template 'add_book' => {
            error    => $_,
            authors  => _get_authors(),
            title    => $title,
            selected => $author,
        };
    }
};

#
#
# PRIVATE METHODS

sub _generate_captcha_keys {
    my ($count) = @_;

    my @chars = ('A'..'Z','a'..'z',0..9);
    my $min   = 1;
    my $max   = scalar(@chars);

    my $random = '';
    foreach (1..$count) {
        $random .= $chars[int($min + rand($max - $min))];
    }

    return $random;
}

sub _register_user {
    my ($username, $password) = @_;

    $bookstore_schema->populate(
        'User', [ ['username', 'password'], [$username, $password] ]);
}

sub _is_valid_user {
    my ($username, $password) = @_;

    my $user = $bookstore_schema->resultset('User')->find({ username => $username });
    return 0 unless defined $user;
    my $saved_password = $user->password;

    (passphrase($password)->matches($saved_password))
        ?
        (return 1)
        :
        (return 0);
}

sub _search {
    my ($query) = @_;

    my $results = {};
    my @authors = $bookstore_schema->resultset('Author')->search(
        { -or => [ firstname => { like => "%$query%" },
                   lastname  => { like => "%$query%" },
                 ],
        });

    my %authors = ();
    foreach my $author (@authors) {
        my $author_name = join(' ', $author->firstname, $author->lastname);
        $results->{$author_name} = [];
        $authors{$author_name} = $author->id;
    }

    my @books = $bookstore_schema->resultset('Book')->search(
        { title => { like => "%$query%" } });

    my %books = ();
    foreach my $book (@books) {
        my $author_name = join(' ', $book->author->firstname, $book->author->lastname);
        push @{$results->{$author_name}}, { id => $book->id, name => $book->title };
        $authors{$author_name} = $book->author->id;
    }

    my $output = [];
    foreach (keys %$results) {
        push @$output, {
            author => { id => $authors{$_}, name => $_ },
            books  => $results->{$_}
        };
    }

    return $output;
}

sub _list {

    my $results = {};
    my @authors = $bookstore_schema->resultset('Author')->search();
    my @books   = $bookstore_schema->resultset('Book')->search();

    my %authors = ();
    foreach my $author (@authors) {
        my $author_name = join(' ', $author->firstname, $author->lastname);
        $results->{$author_name} = [];
        $authors{$author_name} = $author->id;
    }

    my %books = ();
    foreach my $book (@books) {
        my $author_name = join(' ', $book->author->firstname, $book->author->lastname);
        push @{$results->{$author_name}}, { id => $book->id, name => $book->title };
    }

    my $output = [];
    foreach (keys %$results) {
        push @$output, {
            author => { id => $authors{$_}, name => $_ },
            books  => $results->{$_}
        };
    }

    return $output;
}

sub _add_author {
    my ($firstname, $lastname) = @_;

    $bookstore_schema->populate(
        'Author', [ ['firstname', 'lastname'], [$firstname, $lastname] ]);
}

sub _add_book {
    my ($author, $title) = @_;

    $bookstore_schema->populate(
        'Book', [ ['title', 'author'], [$title, $author] ]);
}

sub _get_authors {

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

sub _get_books_by_author {
    my ($author) = @_;

    my @books = $bookstore_schema->resultset('Book')->search({ author => $author });

    return \@books;
}


sub _highchart {
    my ($title, $subtitle, $series_name, $tooltip, $yaxis_label, $data) = @_;

    my $highchart = {
        'chart'    => { 'type' => 'column'  },
        'title'    => { 'text' => $title    },
        'subtitle' => { 'text' => $subtitle },
        'xAxis'    => {
            'type'   => 'category',
            'labels' => {
                'rotation' => -90,
                'style'    => { 'fontSize' => '9px', 'fontFamily' => 'Verdana, sans-serif' },
            },
        },
        'yAxis' => {
            'min'   => 0,
            'title' => { 'text' => $yaxis_label },
        },
        'legend'  => { 'enabled'     => 'false'  },
        'tooltip' => { 'pointFormat' => $tooltip },
        'series'  => [{
            'name' => $series_name,
            'data' => $data,
            'dataLabels' => {
                'enabled'  => 'false',
                'rotation' => -90,
                'color'    => '#FFFFFF',
                'align'    => 'right',
                'y'        => 2,
                'style'    => { 'fontSize' => '2px', 'fontFamily' => 'Verdana, sans-serif' },
            },
        }],
    };

    return to_json($highchart);
}

sub _fetch_favourites {
    my ($type) = @_;

    my @modules = $bookstore_schema->resultset('CpanModule')->search();
    my $favourites = [];
    foreach my $module (@modules) {
        my $module_id   = $module->id;
        my $module_name = $module->package_name;
        my $row = $bookstore_schema->resultset('CpanModuleDetail')->find({ module_id => $module_id });

        if (defined $row) {
            if ($type eq 'metacpan') {
                push @$favourites, [ $module_name, $row->metacpan_favourite ];
            }
            elsif ($type eq 'github') {
                push @$favourites, [ $module_name, $row->github_favourite ];
            }
        }
        else {
            push @$favourites, [ $module_name, 0 ];
        }
    }

    return $favourites;
}

sub _metacpan_favourites {

    return _fetch_favourites('metacpan');
}

sub _github_favourites {

    return _fetch_favourites('github');
}

true;
