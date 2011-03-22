package Flickr::API2::Photos;
use Mouse;
use Flickr::API2::Photo;
extends 'Flickr::API2::Base';

=head2 search

Search for photos, for eg:

my @photos = $flickr->photos->search(tags => 'kitten,pony');

For parameters, see:

http://www.flickr.com/services/api/flickr.photos.search.html

This returns an array of Flickr::API2::Photo objects.

=cut

sub search {
    my $self = shift;
    my %args = @_;
    $args{extras} ||= join(',',
        qw(
            date_upload date_taken owner_name url_s url_m url_l path_alias
        )
    );

    my $r = $self->api->execute_method(
        'flickr.photos.search', \%args
    );
    die("Didn't understand response (or no photos)")
        unless exists $r->{photos};

    my @photos = map {
        Flickr::API2::Photo->new(
            api => $self->api,
            id => $_->{id},
            title => $_->{title},
            date_upload => $_->{date_upload},
            date_taken => $_->{date_taken},
            owner_name => $_->{owner_name},
            url_s => $_->{url_s},
            url_m => $_->{url_m},
            url_l => $_->{url_l},
            path_alias => $_->{path_alias},
        )
    } @{ $r->{photos}->{photo} };

    return @photos;
}

__PACKAGE__->meta->make_immutable;
1;
