package Flickr::API2::Interestingness;
use Mouse;
use Flickr::API2::Photo;
extends 'Flickr::API2::Base';

=head1 NAME

Flickr::API2::Interestingness

=head1 SYNOPSIS

See getList() below.

=head1 METHODS

=head2 getList

Returns the list of interesting photos for the most recent day or a
user-specified date.

See http://www.flickr.com/services/api/flickr.interestingness.getList.html
for available options.

=cut

# Note - this is basically a carbon-copy of the photos.search method :/
sub getList {
    my $self = shift;
    my %args = @_;

    $args{extras} ||= join(',',
        qw(
            date_upload date_taken owner_name url_s url_m url_l path_alias
        )
    );

    my $r = $self->api->execute_method(
        'flickr.interestingness.getList', \%args
    );
    die("Didn't understand response (or no photos)")
        unless exists $r->{photos};
    
    return $self->_response_to_photos($r->{photos})
}

__PACKAGE__->meta->make_immutable;
1;
