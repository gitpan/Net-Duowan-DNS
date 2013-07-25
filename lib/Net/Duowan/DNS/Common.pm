package Net::Duowan::DNS::Common;

use 5.006;
use warnings;
use strict;
use Carp qw/croak/;
use JSON;
use LWP::UserAgent;

use vars qw/$VERSION/;
$VERSION = '1.0';

sub new {
    my $class = shift;
    bless {},$class;
}

sub reqTemplate {
    my $self = shift;
    my $args = shift;

    my $url = 'https://cloudns.duowan.com/api/';
    my $ua = LWP::UserAgent->new;
    $ua->timeout(30);
    $ua->ssl_opts(verify_hostname => 0);

    my $req = HTTP::Request->new(POST => $url);
    $req->content_type('application/x-www-form-urlencoded');
    $req->content($args);

    my $res = $ua->request($req);
    if ($res->is_success ) {
        return decode_json($res->decoded_content);
    } else {
        croak $res->status_line;
    }
}

1;
