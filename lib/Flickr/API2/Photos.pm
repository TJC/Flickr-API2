package Flickr::API2::Photos;
use Mouse;
extends 'Flickr::API2::Base';

=head1 NAME

Flickr::API2::Photos

=head1 SYNOPSIS

See search() below.

=head1 METHODS

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
            date_upload date_taken owner_name url_s url_m url_l url_o path_alias
        )
    );

    my $r = $self->api->execute_method(
        'flickr.photos.search', \%args
    );
    die("Didn't understand response (or no photos)")
        unless exists $r->{photos};

    return $self->_response_to_photos($r->{photos})
}

__PACKAGE__->meta->make_immutable;
1;
