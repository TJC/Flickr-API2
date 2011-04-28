package Flickr::API2::Raw;
use strict;
use warnings;
use JSON qw(decode_json);
use Digest::MD5 qw(md5_hex);
use Compress::Zlib;
use LWP::UserAgent;
use parent qw(LWP::UserAgent);

=head1 NAME

Flickr::API2::Raw

=head1 DESCRIPTION

This module encapsulates the raw interactions with Flickr's API - the creation
of an HTTP request, signing of arguments, checking of response codes, and so
forth.

End users shouldn't need to use this module - instead, use the Flickr::API2
object, and call 'execute_method' on it.

=head1 METHODS

=cut

=head2 new

Constructor - takes arguments of:
  key (api key)
  secret (api key's secret)
  rest_uri (which URL at flickr to use - defaults to the correct value)
  auth_uri (which URL at flickr for authentication - defaults to correct value)

=cut

sub new {
    my $class   = shift;
    my $options = shift;
    my $self    = LWP::UserAgent->new;

    $self->{api_key}    = $options->{key};
    $self->{api_secret} = $options->{secret};
    $self->{rest_uri}   = $options->{rest_uri}
      || 'http://api.flickr.com/services/rest/';
    $self->{auth_uri} = $options->{auth_uri}
      || 'http://api.flickr.com/services/auth/';

    $self->default_header( 'Accept-Encoding' => 'gzip' );
    bless $self, $class;
}

=head2 sign_args ($secret, \%args)

Signs the given arguments with the given secret key.

=cut

sub sign_args {
    my ($self, $sig, $args) = @_;

    foreach my $key ( sort { $a cmp $b } keys %{$args} ) {
        my $value = ( defined( $args->{$key} ) ) ? $args->{$key} : "";
        $sig .= $key . $value;
    }

    return md5_hex($sig);
}

=head2 request_auth_url

Builds the full URL to be requested from the Flickr API.

=cut

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

    $args{api_sig} = $self->sign_args( $self->{api_secret}, \%args );

    my $uri = URI->new( $self->{auth_uri} );
    $uri->query_form(%args);

    return $uri;
}

=head2 execute_request

Called from execute_method() to kick off the API query process.
Either dies with an exception, or returns a hash-reference of the results.

=cut

sub execute_request {
    my ( $self, $request ) = @_;

    $request->{api_args}->{method}  = $request->{api_method};
    $request->{api_args}->{api_key} = $self->{api_key};

    if ( defined( $self->{api_secret} ) && length( $self->{api_secret} ) ) {
        $request->{api_args}->{api_sig} =
          $self->sign_args( $self->{api_secret}, $request->{api_args} );
    }

    $request->encode_args();

    my $response = $self->request($request);

    die("API returned a non-200 status code: " . $response->{_rc} . "\n")
        unless $response->{_rc} == 200;

    my $content = $response->decoded_content();
    $content = $response->content() unless defined $content;

    my $json = eval { decode_json($content) };
    if ($@) {
        die("Failed to parse API response as JSON: $@\n");
    }

    if ( $json->{stat} eq 'ok' ) {
        return $json;
        # Do we still care about returning the $response somehow?
        # It doesn't have much of interest at this stage, I think.
    }

    die(sprintf("API call failed: \%s (\%s)\n",
                $json->{message}, $json->{code})
    );
}

1;
