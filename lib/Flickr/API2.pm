package Flickr::API2;
use strict;
use warnings;
use Flickr::API2::Request;
use Flickr::API2::Photos;
use Flickr::API2::Test;
use Flickr::API2::Interestingness;
use Flickr::API2::People;
use Flickr::API2::Raw;

our $VERSION = '2.00';

sub new {
    my $class   = shift;
    my $options = shift;

    die "You must supply an API key and secret to the constructor"
      unless $options->{key} and $options->{secret};

    my $self = {
        _raw => Flickr::API2::Raw->new($options),
        rest_uri => $options->{rest_uri}
          || 'http://api.flickr.com/services/rest/',
    };

    bless $self, $class;
}

sub execute_method {
    my ( $self, $method, $args ) = @_;

    my $request = new Flickr::API2::Request(
        {
            method   => $method,
            args     => $args,
            rest_uri => $self->{rest_uri}
        }
    );

    $self->raw->execute_request($request);
}

sub raw {
    shift->{_raw};
}

sub photos {
    Flickr::API2::Photos->new( api => shift );
}

sub test {
    Flickr::API2::Test->new( api => shift );
}

sub interestingness {
    Flickr::API2::Interestingness->new( api => shift );
}

sub people {
    Flickr::API2::People->new( api => shift );
}

1;
__END__

=head1 NAME

Flickr::API2 - Perl interface to the Flickr API

=head1 SYNOPSIS

  use Flickr::API2;

  my $api = new Flickr::API2({'key'    => 'your_api_key',
                             'secret' => 'your_app_secret'});


  my @photos = $api->people->findByUsername('wintrmute')
                   ->getPublicPhotos(per_page => 10);

  for my $photo (@photos) {
    say "Title is " . $photo->title;
  }

  To access the raw flickr API, use methods like:

  my $response = $api->execute_method('flickr.test.echo', {
        'foo' => 'bar',
        'baz' => 'quux',
    }
  );

=head1 DESCRIPTION

A simple interface for using the Flickr API.

The API calls are made via Perl helper methods, and the data returned is
converted into Perl objects that can have further methods called upon them.

So for instance, you can fetch a user by username, by:

  my $user = $api->people->findByUsername('wintrmute')

You can then ask for photos by that user, by calling:

  my @photos = $user->getPublicPhotos;

And from there, you can query titles, URLs, etc of the photos with methods
such as:

  $photos[0]->title

So far only a few helper methods have been written, but more are coming.
Patches adding functionality will be greatly appreciated!

=head2 METHODS

=over 4

=item C<new>

Constructor - takes arguments of:
  key (api key)
  secret (api key's secret)
  rest_uri (which URL at flickr to use - defaults to the correct value)
  auth_uri (which URL at flickr for authentication - defaults to correct value)

=item C<execute_method($method, $args)>

Constructs a C<Flickr::API2::Request> object and executes it, returning the
response. Exceptions will be thrown if the request fails.

=item C<photos>

Returns a Flickr::API2::Photos object, which can be used to perform various
searches and stuff. See its docs for more info.

=item C<people>

Returns a Flickr::API2::People object, which can be used to perform various
searches and stuff. See its docs for more info.

=item C<interestingness>

Returns a Flickr::API2::Interestingness object, which can be used to perform
various searches and stuff. See its docs for more info.

=item C<raw>

Returns a Flickr::API2::Raw object, which allows low-level Flickr API calls to
be performed. See its docs for more info.

=item C<test>

Returns a Flickr::API2::Test object, which allows test-related API calls to be
performed.

=back

=head1 AUTHOR

Version 2.xx copyright 2011 Toby Corkindale, tjc@cpan.org

Original version 1.xx copyright (C) 2004-2005, Cal Henderson, E<lt>cal@iamcal.comE<gt>

Original version included Auth API patches provided by Aaron Straup Cope

=head1 SEE ALSO

L<Flickr::API2::Request>,
L<Flickr::API2::Raw>,
L<Flickr::API2::Base>,
L<Flickr::API2::People>,
L<Flickr::API2::User>,
L<Flickr::API2::Photos>,
L<Flickr::API2::Photo>,
L<Flickr::API2::Interestingness>,
L<http://www.flickr.com/>,
L<http://www.flickr.com/services/api/>

=cut
