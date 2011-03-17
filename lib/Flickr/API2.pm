package Flickr::API2;

use strict;
use warnings;
use LWP::UserAgent;
use JSON qw(decode_json);
use Flickr::API2::Request;
use Flickr::API2::Response;
use Digest::MD5 qw(md5_hex);
use Compress::Zlib;

use parent qw(LWP::UserAgent);

our $VERSION = '2.00';

sub new {
    my $class   = shift;
    my $options = shift;
    my $self    = new LWP::UserAgent;
    $self->{api_key}    = $options->{key};
    $self->{api_secret} = $options->{secret};
    $self->{rest_uri}   = $options->{rest_uri}
      || 'http://api.flickr.com/services/rest/';
    $self->{auth_uri} = $options->{auth_uri}
      || 'http://api.flickr.com/services/auth/';

    $self->default_header( 'Accept-Encoding' => 'gzip' );

    warn "You must pass an API key to the constructor"
      unless defined $self->{api_key};

    bless $self, $class;
    return $self;
}

sub sign_args {
    my $self = shift;
    my $args = shift;

    my $sig = $self->{api_secret};

    foreach my $key ( sort { $a cmp $b } keys %{$args} ) {

        my $value = ( defined( $args->{$key} ) ) ? $args->{$key} : "";
        $sig .= $key . $value;
    }

    return md5_hex($sig);
}

sub request_auth_url {
    my $self  = shift;
    my $perms = shift;
    my $frob  = shift;

    return undef
      unless defined $self->{api_secret} && length $self->{api_secret};

    my %args = (
        'api_key' => $self->{api_key},
        'perms'   => $perms
    );

    if ($frob) {
        $args{frob} = $frob;
    }

    my $sig = $self->sign_args( \%args );
    $args{api_sig} = $sig;

    my $uri = URI->new( $self->{auth_uri} );
    $uri->query_form(%args);

    return $uri;
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

    $self->execute_request($request);
}

sub execute_request {
    my ( $self, $request ) = @_;

    $request->{api_args}->{method}  = $request->{api_method};
    $request->{api_args}->{api_key} = $self->{api_key};

    if ( defined( $self->{api_secret} ) && length( $self->{api_secret} ) ) {

        $request->{api_args}->{api_sig} =
          $self->sign_args( $request->{api_args} );
    }

    $request->encode_args();

    my $response = $self->request($request);
    bless $response, 'Flickr::API2::Response';
    $response->init_flickr();

    if ( $response->{_rc} != 200 ) {
        $response->set_fail( 0,
            "API returned a non-200 status code ($response->{_rc})" );
        return $response;
    }

    my $content = $response->decoded_content();
    $content = $response->content() unless defined $content;

    my $json = eval { decode_json($content) };
    if ($@) {
        $response->set_fail( 0, "Invalid API response: $@" );
        return $response;
    }

    if ( $json->{stat} eq 'ok' ) {
        $response->set_ok($json);
        return $response;
    }

    $response->set_fail(
        $json->{code},
        $json->{message}
    );

    return $response;
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
