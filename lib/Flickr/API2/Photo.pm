package Flickr::API2::Photo;
use Encode::Base58;
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

license

tags

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
has 'url_sq' => (
    is => 'rw',
    lazy => 1,
    default => sub { $_[0]->populate_size_urls; $_[0]->url_sq; },
);
has 'url_t' => (
    is => 'rw',
    lazy => 1,
    default => sub { $_[0]->populate_size_urls; $_[0]->url_t; },
);
has 'url_s' => (
    is => 'rw',
    lazy => 1,
    default => sub { $_[0]->populate_size_urls; $_[0]->url_s; },
);
has 'url_m' => (
    is => 'rw',
    lazy => 1,
    default => sub { $_[0]->populate_size_urls; $_[0]->url_m; },
);
has 'url_l' => (
    is => 'rw',
    lazy => 1,
    default => sub { $_[0]->populate_size_urls; $_[0]->url_l; },
);
has 'url_o' => (
    is => 'rw',
    lazy => 1,
    default => sub { $_[0]->populate_size_urls; $_[0]->url_o; },
);
has 'description' => ( is => 'rw' );
has 'path_alias' => ( is => 'rw' );
has 'license' => ( is => 'rw' );
has 'tags' => ( is => 'rw' );

=head1 METHODS

=head2 info

Returns getInfo results for this photo; contains lots of info that isn't
currently available by simple accessors.

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

Note that you probably don't need to call this directly - instead, see the
various url accessors. If they're blank, try calling populate_size_urls()
first.

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

=head2 populate_size_urls

Populates all the various URLs to the differently-sized images by querying
the API. This *should* have been done automatically for you, the first time
you queried one of the url accessors.

=cut

our %label_to_accessor = (
    Square => 'url_sq',
    Thumbnail => 'url_t',
    Small => 'url_s',
    Medium => 'url_m',
    Large => 'url_l',
    Original => 'url_o',
);

sub populate_size_urls {
    my $self = shift;
    my $sizes = $self->sizes->{size};
    for my $s (@$sizes) {
        if (my $acc = $label_to_accessor{$s->{label}}) {
            $self->$acc($s->{source});
        }
    }
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

=cut

sub short_url {
    my $self = shift;
    sprintf('http://flic.kr/p/%s', encode_base58($self->id));
}

__PACKAGE__->meta->make_immutable;
1;
