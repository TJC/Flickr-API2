package Flickr::API2::Test;
use Mouse;
extends 'Flickr::API2::Base';

=head2 echo

Echos back what you sent to Flickr.

=cut

sub echo {
    my ($self, %args) = @_;
    return $self->api->execute_method(
        'flickr.test.echo', \%args
    );
}

__PACKAGE__->meta->make_immutable;
1;
