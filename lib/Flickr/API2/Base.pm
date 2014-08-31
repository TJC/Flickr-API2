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
            date_upload => $_->{dateupload},
            date_taken => $_->{datetaken},
            owner_id => $_->{owner},
            owner_name => $_->{ownername},
            url_s => $_->{url_s},
            height_s => $_->{height_s},
            width_s => $_->{width_s},
            url_m => $_->{url_m},
            height_m => $_->{height_m},
            width_m => $_->{width_m},
            url_l => $_->{url_l},
            height_l => $_->{height_l},
            width_l => $_->{width_l},
            url_o => $_->{url_o},
            height_o => $_->{height_o},
            width_o => $_->{width_o},
            path_alias => $_->{pathalias},
            count_faves => $_->{count_faves},
            views => $_->{views},
        ),
    } @{ $photos->{photo} };

    return @photos;
}

__PACKAGE__->meta->make_immutable;
1;
