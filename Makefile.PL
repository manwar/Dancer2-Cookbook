
use 5.006;
use strict; use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME               => 'bookstore',
    AUTHOR             => q{Mohammad S Anwar <mohammad.anwar@yahoo.com>},
    VERSION_FROM       => 'lib/bookstore.pm',
    ABSTRACT           => 'lib/bookstore.pm',
    LICENSE            => 'artistic_2',
    PL_FILES           => {},
    dist               => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean              => { FILES => 'bookstore-*' },
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More'            => 0,
        'Plack::Test'           => 0,
        'HTTP::Request::Common' => 0,
    },
    PREREQ_PM => {
        'YAML'      => 0,
        'Try::Tiny' => 0,
        'Dancer2'   => 0.159001,
        'Dancer2::Plugin::DBIC'       => 0,
        'Dancer2::Plugin::Ajax'       => 0,
        'Dancer2::Plugin::Captcha'    => 0,
        'Dancer2::Plugin::Auth::Tiny' => 0,
        'Dancer2::Plugin::Passphrase' => 0,
        'Dancer2::Plugin::Chain'      => 0,
        'DBIx::Class::Schema::Loader' => 0,
        'Dancer2::Session::Simple'    => 0,
    },
);
