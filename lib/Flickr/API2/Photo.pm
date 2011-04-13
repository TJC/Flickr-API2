package Flickr::API2::Photo;
use Mouse;
extends 'Flickr::API2::Base';

=head1 NAME

Flickr::API2::Photo

=head1 SYNOPSIS

Represents a Flickr photo, with helper methods. (Incomplete)

=head1 ATTRIBUTES

title

date_upload

date_taken

owner_name

url_s url_m url_l

description

path_alias

=cut

has 'id' => (
    is => 'ro',
    required => 1,
);
has 'title' => ( is => 'rw' );
has 'date_upload' => ( is => 'rw' );
has 'date_taken' => ( is => 'rw' );
has 'owner_id' => ( is => 'rw' );
has 'owner_name' => ( is => 'rw' );
has 'url_s' => ( is => 'rw' );
has 'url_m' => ( is => 'rw' );
has 'url_l' => ( is => 'rw' );
has 'description' => ( is => 'rw' );
has 'path_alias' => ( is => 'rw' );

=head1 METHODS

=head2 info

Returns getInfo results for this photo; not really tested much yet.

=cut

sub info {
    my ($self) = shift;
    my $response = $self->api->execute_method(
        'flickr.photos.getInfo',
        {
            photo_id => $self->id,
        }
    );
    return $response;
}

=head2 sizes

Returns getSizes results for this photo.

=cut

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

=head2 page_url

Returns the URL for this photo's page on Flickr.

=cut

# See http://www.flickr.com/services/api/misc.urls.html
# for generation method
sub page_url {
    my $self = shift;
    return sprintf('http://flickr.com/photos/%s/%d',
        ($self->path_alias || $self->owner_name || $self->owner_id),
        $self->id
    );
}

=head2 short_url

Returns the shortened URL for the photo page, ie. at http://flic.kr/

NOT YET IMPLEMENTED

=cut

sub short_url {
    my $self = shift;
    # TODO: implement base58 encoding of the id
    sprintf('http://flic.kr/p/%s', $self->id);
}

__PACKAGE__->meta->make_immutable;
1;
