package Flickr::API2::User;
use Mouse;
extends 'Flickr::API2::Base';

has 'NSID' => (
    is => 'rw',
);

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

__PACKAGE__->meta->make_immutable;
1;
