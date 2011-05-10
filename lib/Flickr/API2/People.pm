package Flickr::API2::People;
use Mouse;
extends 'Flickr::API2::Base';
use Flickr::API2::User;

=head1 NAME

Flickr::API2::People

=head1 METHODS

=head2 findByEmail

Return a user's NSID, given their email address.

eg. $api->people->findByEmail('john.doe@example.com')

=cut

sub findByEmail {
    my ($self, $email) = @_;
    my $r = $self->api->execute_method(
        'flickr.people.findByEmail', { find_email => $email }
    );
    return Flickr::API2::User->new(
        api => $self->api,
        NSID => $r->{user}->{nsid},
        username => $r->{user}->{username}->{_content},
    );
}

=head2 findByUsername

Return a user's NSID, given their username.

eg. $api->people->findByUsername('fakeuser')

=cut

sub findByUsername {
    my ($self, $username) = @_;
    my $r = $self->api->execute_method(
        'flickr.people.findByUsername', { username => $username }
    );
    return Flickr::API2::User->new(
        api => $self->api,
        NSID => $r->{user}->{nsid},
        username => $r->{user}->{username}->{_content},
    );
}

=head2 getInfo

Get information about a user.

eg. $api->people->getInfo('12345678@N00');

or  $api->people->findByUsername('fakeuser')->getInfo;

=cut

sub getInfo {
    my ($self, $id) = @_;

    my $r = $self->api->execute_method(
        'flickr.people.getInfo', { user_id => $id }
    );
    return $r->{person};
}

=head2 getPublicPhotos

Get a list of public photos for the given user.

eg. $api->people->getPublicPhotos('12345678@N00')

or  $api->people->findByUsername('foobar')->getPublicPhotos( per_page => 10 )

See http://www.flickr.com/services/api/flickr.people.getPublicPhotos.html
for options.

=cut

sub getPublicPhotos {
    my ($self, $id, %args) = @_;

    $args{extras} ||= join(',',
        qw(
            date_upload date_taken owner_name url_s url_m url_l path_alias
        )
    );

    my $r = $self->api->execute_method(
        'flickr.people.getPublicPhotos', { user_id => $id, %args }
    );

    die("Didn't understand response (or no photos)")
        unless exists $r->{photos};

    return $self->_response_to_photos($r->{photos})
}

__PACKAGE__->meta->make_immutable;
1;
