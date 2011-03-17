package Flickr::API2::Request;

use strict;
use warnings;
use HTTP::Request;
use URI;

our @ISA     = qw(HTTP::Request);
our $VERSION = '0.03';

sub new {
    my $class   = shift;
    my $options = shift;
    my $self    = new HTTP::Request;
    $self->{api_method} = $options->{method};
    $self->{api_args}   = $options->{args};
    $self->{rest_uri}   = $options->{rest_uri}
      || 'http://api.flickr.com/services/rest/';

    bless $self, $class;

    $self->{api_args}->{format}         = 'json';
    $self->{api_args}->{nojsoncallback} = 1;

    $self->method('POST');
    $self->uri( $self->{rest_uri} );

    return $self;
}

sub encode_args {
    my ($self) = @_;

    my $url = URI->new('http:');
    $url->query_form( %{ $self->{api_args} } );
    my $content = $url->query;

    $self->header( 'Content-Type' => 'application/x-www-form-urlencoded' );
    if ( defined($content) ) {
        $self->header( 'Content-Length' => length($content) );
        $self->content($content);
    }
}

1;

__END__

=head1 NAME

Flickr::API2::Request - A request to the Flickr API

=head1 SYNOPSIS

  use Flickr::API2;
  use Flickr::API2::Request;

  my $api = new Flickr::API2({'key' => 'your_api_key'});

  my $request = new Flickr::API2::Request({
  	'method' => $method,
  	'args' => {},
  }); 

  my $response = $api->execute_request($request);


=head1 DESCRIPTION

This object encapsulates a request to the Flickr API.

C<Flickr::API2::Request> is a subclass of C<HTTP::Request>, so you can access
any of the request parameters and tweak them yourself. The content, content-type
header and content-length header are all built from the 'args' list by the
C<Flickr::API2::execute_request()> method.


=head1 AUTHOR

Version 2.xx copyright 2011 Toby Corkindale, tjc@cpan.org

Original version 1.xx copyright (C) 2004-2005, Cal Henderson, E<lt>cal@iamcal.comE<gt>

=head1 SEE ALSO

L<Flickr::API2>.

=cut
