#!perl
use strict;
use warnings;
use LWP::Online ':skip_all';

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

# Find by username
my $user = $api->people->findByUsername('wintrmute');
isa_ok($user, 'Flickr::API2::User');
is($user->username, 'Wintrmute', "Found me by username");

# TODO: Improve the way info is returned..
my $info = $user->getInfo;
is($info->{realname}->{_content}, 'Toby Corkindale',
   ".. and they know my name"
);

my @pics = $user->getPublicPhotos(per_page => 3);
is(scalar(@pics), 3, "Three pics from user returned");
isa_ok($pics[0], 'Flickr::API2::Photo');
ok($pics[0]->id, "First picture has an ID");

# Find by email address (don't have a valid email to test with yet)
# my $user = $api->people->findByEmail('tjc@wintrmute.net');

done_testing();
