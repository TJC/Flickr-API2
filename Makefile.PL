use inc::Module::Install;

name     'Flickr-API2';
all_from 'lib/Flickr/API2.pm';
author   q{Toby Corkindale <tjc@cpan.org>};
license  'perl';

build_requires 'Test::More';
build_requires 'Test::Exception';

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

auto_install;

WriteAll;
