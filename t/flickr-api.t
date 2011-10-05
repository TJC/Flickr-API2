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

# create an api object without a valid key:
{
    my $badapi = new Flickr::API2(
        {
            'key'    => 'made_up_key',
            'secret' => 'my_secret',
        }
    );

    # check the API-key-is-not-valid error
    throws_ok {
        $badapi->execute_method( 'flickr.test.echo' );
    } qr/Invalid API Key/i, 'Correct error for invalid api key';
}

# Now create an API object with real keys:
my $api = new Flickr::API2(
    {
        'key'    => '0f868b48da5bbfc54b3ac5b04abfeb69',
        'secret' => 'c425dd1466adad4b',
    }
);

# check we get the 'method not found' error
throws_ok {
    $api->execute_method( 'fake.method', {} );
} qr/method .+ not found/i, 'Correct error for method not found';

# Get some photos of kittens using the raw API:
{
    my $r = $api->execute_method('flickr.photos.search', {
        tags => 'kitten,kittens',
        per_page => 10,
    });
    ok($r->{photos}->{photo}->[0]->{id}, "Found at least one kitten photo");
}

# Get some photos of ponies via the cooked API
{
    my @photos = $api->photos->search(
        tags => 'pony,ponies',
        per_page => 10,
    );
    is(scalar(@photos), 10, "Returned ten photos");
    isa_ok($photos[0], 'Flickr::API2::Photo') and do {
        ok($photos[0]->id, "First photo has an id");
        ok($photos[0]->url_s, "First photo has a small URL");
        ok($photos[0]->page_url, "First photo has a generated page url");
    };
}

# See what the current interesting photo of the day is:
{
    my @photos = $api->interestingness->getList(
        per_page => 3,
    );
    is(scalar(@photos), 3, "Returned three interesting photos");
    isa_ok($photos[0], 'Flickr::API2::Photo') and do {
        ok($photos[0]->id, "First photo has an id");
        ok($photos[0]->url_s, "First photo has a small URL");
        ok($photos[0]->page_url, "First photo has a generated page url");
        ok($photos[0]->short_url, "First photo has a shortened URL");
    };
}

done_testing();
