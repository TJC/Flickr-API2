package Flickr::API2::Base;
use Mouse;
use Flickr::API2::Photo;

=head1 NAME

Flickr::API2::Base

=head1 DESCRIPTION

Base class for most of the API-helper classes.

=head1 ATTRIBUTES

=head2 api

A reference to the parent API object.

=cut

has 'api' => (
    is => 'ro',
    isa => 'Flickr::API2',
    required => 1,
);

=head1 METHODS

=head2 _response_to_photos

Converts an API raw response (containing photo lists) into an array of
our Photo objects.

=cut

sub _response_to_photos {
    my ($self, $photos) = @_;

    my @photos = map {
        Flickr::API2::Photo->new(
            api => $self->api,
            id => $_->{id},
            title => $_->{title},
            date_upload => $_->{date_upload},
            date_taken => $_->{date_taken},
            owner_id => $_->{owner},
            owner_name => $_->{owner_name},
            url_s => $_->{url_s},
            url_m => $_->{url_m},
            url_l => $_->{url_l},
            url_o => $_->{url_o},
            path_alias => $_->{path_alias},
        )
    } @{ $photos->{photo} };

    return @photos;
}

__PACKAGE__->meta->make_immutable;
1;
