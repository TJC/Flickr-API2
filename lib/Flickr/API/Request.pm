package Flickr::API::Request;

use strict;
use warnings;
use HTTP::Request;
use URI;

our @ISA = qw(HTTP::Request);
our $VERSION = '0.03';

sub new {
	my $class = shift;
	my $options = shift;
	my $self = new HTTP::Request;
	$self->{api_method}	= $options->{method};
	$self->{api_args}	= $options->{args};
	$self->{rest_uri}	= $options->{rest_uri} || 'http://www.flickr.com/services/rest/';

	bless $self, $class;

	$self->method('POST');
        $self->uri($self->{rest_uri});

	return $self;
}

sub encode_args {
	my ($self) = @_;

	my $url = URI->new('http:');
	$url->query_form(%{$self->{api_args}});
	my $content = $url->query;

	$self->header('Content-Type' => 'application/x-www-form-urlencoded');
	if (defined($content)) {
		$self->header('Content-Length' => length($content));
		$self->content($content);
	}
}

1;

__END__

=head1 NAME

Flickr::API::Request - A request to the Flickr API

=head1 SYNOPSIS

  use Flickr::API;
  use Flickr::API::Request;

  my $api = new Flickr::API({'key' => 'your_api_key'});

  my $request = new Flickr::API::Request({
  	'method' => $method,
  	'args' => {},
  }); 

  my $response = $api->execute_request($request);


=head1 DESCRIPTION

This object encapsulates a request to the Flickr API.

C<Flickr::API::Request> is a subclass of C<HTTP::Request>, so you can access
any of the request parameters and tweak them yourself. The content, content-type
header and content-length header are all built from the 'args' list by the
C<Flickr::API::execute_request()> method.


=head1 AUTHOR

Copyright (C) 2004, Cal Henderson, E<lt>cal@iamcal.comE<gt>


=head1 SEE ALSO

L<Flickr::API>.

=cut
