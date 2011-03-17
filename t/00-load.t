#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Flickr::API2' ) || print "Bail out!
";
}

diag( "Testing Flickr::API2 $Flickr::API2::VERSION, Perl $], $^X" );
