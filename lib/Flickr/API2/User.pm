package Flickr::API2::User;
use 5.12.0;
use warnings;
use Moo;
extends 'Flickr::API2::Base';

=head2 NSID

Accessor for NSID

=cut

has 'NSID' => (
    is => 'rw',
);

=head2 username

accessor for username

=cut

has 'username' => (
    is => 'rw',
);

=head2 getInfo

Returns the info for this user by called flickr.people.getInfo with our ID.

=cut

sub getInfo {
    my $self = shift;
    $self->api->people->getInfo($self->NSID);
}

=head2 getPublicPhotos

Returns the user's public photos - see People::getPublicPhotos() for more info.

=cut

sub getPublicPhotos {
    my ($self, %args) = @_;
    $self->api->people->getPublicPhotos($self->NSID, %args);
}

1;
