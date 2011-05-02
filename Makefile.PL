use inc::Module::Install;

name     'Flickr-API2';
author   q{Toby Corkindale <tjc@cpan.org>};
license  'perl';
abstract 'Perl bindings to Flickr API';
perl_version '5.008008';
all_from 'lib/Flickr/API2.pm';

build_requires 'Test::More';
build_requires 'Test::Exception';
build_requires 'LWP::Online';

requires 'parent';
requires 'LWP::UserAgent';
requires 'HTTP::Request';
requires 'HTTP::Response';
requires 'HTTP::Message' => 1.56;
requires 'URI' => 1.18;
requires 'Digest::MD5';
requires 'Compress::Zlib';
requires 'Mouse';
requires 'JSON';

recommends 'JSON::XS';

auto_install;

WriteAll;
