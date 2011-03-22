package Flickr::API2::Photo;
use Mouse;
extends 'Flickr::API2::Base';

has 'id' => (
    is => 'ro',
    required => 1,
);

has 'title' => ( is => 'rw' );
has 'date_upload' => ( is => 'rw' );
has 'date_taken' => ( is => 'rw' );
has 'owner_name' => ( is => 'rw' );
has 'url_s' => ( is => 'rw' );
has 'url_m' => ( is => 'rw' );
has 'url_l' => ( is => 'rw' );
has 'description' => ( is => 'rw' );
has 'path_alias' => ( is => 'rw' );

sub info {
    my ($self) = shift;
    my $response = $self->api->execute_method(
        'flickr.photos.getInfo',
        {
            photo_id => $self->id,
        }
    );
    return $response->{sizes};
}

sub sizes {
    my ($self) = shift;
    my $response = $self->api->execute_method(
        'flickr.photos.getSizes',
        {
            photo_id => $self->id,
        }
    );
    return $response->{sizes};
}

__PACKAGE__->meta->make_immutable;
1;
