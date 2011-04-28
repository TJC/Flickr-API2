#!perl
use strict;
use warnings;
use Test::More;
use Test::Exception;

use_ok('Flickr::API2') or die;

# TODO: Skip online tests if we can't contact the Flickr::API..

my $api = new Flickr::API2(
    {
        'key'    => '0f868b48da5bbfc54b3ac5b04abfeb69',
        'secret' => 'c425dd1466adad4b',
    }
);

# Find by username
my $user = $api->people->findByUsername('wintrmute');
is($user->username, 'Wintrmute', "Found me by username");

my $info = $user->getInfo;
is($info->{realname}->{_content}, 'Toby Corkindale',
   ".. and they know my name"
);

my @pics = $user->getPublicPhotos(per_page => 3);
is(scalar(@pics), 3, "Three pics from user returned");
ok($pics[0]->id, "First picture has an ID");

# Find by email address (don't have a valid email to test with yet)
# my $user = $api->people->findByEmail('tjc@wintrmute.net');

done_testing();
