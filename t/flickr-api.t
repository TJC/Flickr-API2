#!perl
use Test::More;
use Test::Exception;

use_ok('Flickr::API2');

# TODO: Skip online tests if we can't contact the Flickr::API..

# create an api object

my $api = new Flickr::API2(
    {
        'key'    => 'made_up_key',
        'secret' => 'my_secret',
    }
);

# check we get the 'method not found' error
throws_ok {
    $api->execute_method( 'fake.method', {} );
} qr/method .+ not found/i, 'Correct error for method not found';

# check the API-key-is-not-valid error
throws_ok {
$rsp = $api->execute_method( 'flickr.test.echo' );
} qr/Invalid API Key/i, 'Correct error for invalid api key';


##################################################
#
# check the signing works properly
#

ok(
    '466cd24ced0b23df66809a4d2dad75f8' eq $api->sign_args( { 'foo' => 'bar' } ),
    "Signing test 1"
);
ok(
    'f320caea573c1b74897a289f6919628c' eq $api->sign_args( { 'foo' => undef } ),
    "Signing test 2"
);

##################################################
#
# check the auth url generator is working
#

my $uri = $api->request_auth_url( 'r', 'my_frob' );

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

##################################################
#
# check we can't generate a url without a secret
#

$api = new Flickr::API2( { 'key' => 'key' } );
$uri = $api->request_auth_url( 'r', 'frob' );

ok( !defined $uri, "Checking URL generation without a secret" );

done_testing();
