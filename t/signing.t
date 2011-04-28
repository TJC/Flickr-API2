#!perl
use strict;
use warnings;
use Test::More;
use Test::Exception;

use_ok('Flickr::API2');
use_ok('Flickr::API2::Raw');

# create an api object without a valid key:
my $api = new Flickr::API2(
    {
        'key'    => 'made_up_key',
        'secret' => 'my_secret',
    }
);

##################################################
#
# check the signing works properly
#

is(
    Flickr::API2::Raw->sign_args('my_secret', { 'foo' => 'bar' } ),
    '466cd24ced0b23df66809a4d2dad75f8',
    "Signing test 1"
);
is(
    Flickr::API2::Raw->sign_args('my_secret', { 'foo' => undef } ),
    'f320caea573c1b74897a289f6919628c',
    "Signing test 2"
);

##################################################
#
# check the auth url generator is working
#

my $uri = $api->raw->request_auth_url( 'r', 'my_frob' );

my %expect = &parse_query(
'api_sig=d749e3a7bd27da9c8af62a15f4c7b48f&perms=r&frob=my_frob&api_key=made_up_key'
);
my %got = &parse_query( $uri->query );

sub parse_query {
    my %hash;
    foreach my $pair ( split( /\&/, shift ) ) {
        my ( $name, $value ) = split( /\=/, $pair );
        $hash{$name} = $value;
    }
    return (%hash);
}
foreach my $item ( keys %expect ) {
    is( $expect{$item}, $got{$item},
        "Checking that the $item item in the query matches" );
}
foreach my $item ( keys %got ) {
    is( $expect{$item}, $got{$item},
        "Checking that the $item item in the query matches in reverse" );
}

ok( $uri->path   eq '/services/auth/', "Checking correct return path" );
ok( $uri->host   eq 'api.flickr.com',  "Checking return domain" );
ok( $uri->scheme eq 'http',            "Checking return protocol" );

# check we can't generate a url without a secret
dies_ok {
    my $badapi = new Flickr::API2( { 'key' => 'key' } );
} "Can't create API object without keys";

done_testing();
