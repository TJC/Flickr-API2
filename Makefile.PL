use inc::Module::Install;

name     'Flickr-API2';
author   q{Toby Corkindale <tjc@wintrmute.net>};
license  'perl';
abstract 'Perl bindings to Flickr API';
perl_version '5.012000';
all_from 'lib/Flickr/API2.pm';

repository 'https://github.com/TJC/Flickr-API2';

test_requires 'Test::More';
test_requires 'Test::Exception';
test_requires 'LWP::Online';

requires 'parent';
requires 'LWP::UserAgent';
requires 'HTTP::Request';
requires 'HTTP::Response';
requires 'LWP::Protocol::https';
requires 'HTTP::Message' => 1.56;
requires 'URI' => 1.18;
requires 'Digest::MD5';
requires 'Compress::Zlib';
requires 'Moo';
requires 'Retry';
requires 'JSON';
requires 'Encode::Base58';

recommends 'JSON::XS';

auto_install;

WriteAll;
