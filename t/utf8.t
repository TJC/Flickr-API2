#!perl
use strict;
use warnings;
use LWP::Online ':skip_all';
use Data::Dumper;
use utf8;

# Skip online tests if we can't contact the Flickr::API..
BEGIN {
    require Test::More;
    unless ( LWP::Online::online() ) {
        Test::More->import(
            skip_all => 'Test requires a working internet connection'
        );
    }
}

use Test::More;
use Test::Exception;

use_ok('Flickr::API2') or die;

my $api = new Flickr::API2(
    {
        'key'    => '0f868b48da5bbfc54b3ac5b04abfeb69',
        'secret' => 'c425dd1466adad4b',
    }
);
my %vars = (
    simple => 'Ümlaut',
    chinese => '孫奇',
);

my $result = $api->test->echo(%vars);

is($result->{simple}{_content}, $vars{simple}, "Simple utf8 worked");
is($result->{chinese}{_content}, $vars{chinese}, "Chinese chars worked");

# Can we search by a UTF-8 tag?
{
    my @photos = $api->photos->search(
        tags => 'gödöllő',
        per_page => 2,
    );
    is(scalar(@photos), 2, "Returned two photos");
    isa_ok($photos[0], 'Flickr::API2::Photo');
#    for my $p (@photos) {
#        diag("Photo title: " . $p->title);
#        diag("Photo title: " . $p->page_url);
#    }
}


done_testing();
