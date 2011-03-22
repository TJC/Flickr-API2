package Flickr::API2::Base;
use Mouse;

has 'api' => (
    is => 'ro',
    isa => 'Flickr::API2',
    required => 1,
);

__PACKAGE__->meta->make_immutable;
1;
