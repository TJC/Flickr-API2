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

  my $response = $api->execute_method('flickr.test.echo', {
		'foo' => 'bar',
		'baz' => 'quux',
	});

or

  use Flickr::API2;
  use Flickr::API2::Request;

  my $api = new Flickr::API2({'key' => 'your_api_key'});

  my $request = new Flickr::API2::Request({
		'method' => 'flickr.test.echo',
		'args' => {},
	});

  my $response = $api->execute_request($request);
  

=head1 DESCRIPTION

A simple interface for using the Flickr API.

C<Flickr::API2> is a subclass of L<LWP::UserAgent>, so all of the various
proxy, request limits, caching, etc are available.

=head2 METHODS

=over 4

=item C<execute_method($method, $args)>

Constructs a C<Flickr::API2::Request> object and executes it, returning a C<Flickr::API2::Response> object.

=item C<execute_request($request)>

Executes a C<Flickr::API2::Request> object, returning a C<Flickr::API2::Response> object. Calls are signed
if a secret was specified when creating the C<Flickr::API2> object.

=item C<request_auth_url($perms,$frob)>

Returns a C<URI> object representing the URL that an application must redirect a user to for approving
an authentication token.

For web-based applications I<$frob> is an optional parameter.

Returns undef if a secret was not specified when creating the C<Flickr::API2> object.

=item C<photos>

Returns a Flickr::API2::Photos object, which can be used to perform various
searches and stuff.

=item C<test>

Returns a Flickr::API2::Test object, which allows test-related API calls to be
performed.

=back


=head1 AUTHOR

Version 2.xx copyright 2011 Toby Corkindale, tjc@cpan.org

Original version 1.xx copyright (C) 2004-2005, Cal Henderson, E<lt>cal@iamcal.comE<gt>

Auth API patches provided by Aaron Straup Cope


=head1 SEE ALSO

L<Flickr::API2::Request>,
L<Flickr::API2::Response>,
L<XML::Parser::Lite>,
L<http://www.flickr.com/>,
L<http://www.flickr.com/services/api/>

=cut
