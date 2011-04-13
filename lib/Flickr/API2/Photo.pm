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

# Incomplete/untested
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

# Doesn't quite work right yet.
sub page_url {
    my $self = shift;
    return sprintf('http://flickr.com/photos/%s/%d',
        ($self->path_alias || $self->owner_name || $self->owner_id),
        $self->id
    );
}

__PACKAGE__->meta->make_immutable;
1;
