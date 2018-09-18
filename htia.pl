#!/usr/bin/env perl
#
# htia - How Tipsy Is Andrew?
#        Look at the untapped entries for Andrew for today
#        and make a best guess on how tipsy he is.
#
# v0.1 - Inital Release

use strict;
use warnings;

use Credentials;
use Furl;
use JSON::MaybeXS 'decode_json';
use DateTime::Format::Strptime;

my $date = DateTime->now(time_zone => "local")->ymd('');

my $strp = DateTime::Format::Strptime->new(
    pattern  => '%a, %d %b %Y %H:%M:%S %z',
    on_error => 'croak'
);

my $untapped_api = "https://api.untappd.com/v4/user/checkins/" . $username .  
                                        "?limit=30&client_id=" . $client_id .  
                                             "&client_secret=" . $client_secret;
my $res = Furl->new->get($untapped_api);

if ($res->is_success) {
    my $content = decode_json($res->content);
    my $items = $content->{response}->{checkins}->{items};

    my $todays_count = 0;

    foreach my $item (@{$items}) { 

        my $dt = $strp->parse_datetime($item->{created_at});
        my  $checkin_date = $dt->ymd('');

        if ($checkin_date eq $date) {
           $todays_count++;
        }
    }

    my $squiffy;   

    if ($todays_count <= 1) { 
        $squiffy = "Stone Cold Sober";
    } elsif ($todays_count <= 3) {
        $squiffy = "Enjoying the beer";
    } elsif ($todays_count <= 5) {
        $squiffy = "Happy";
    } elsif ($todays_count <= 7) {
        $squiffy = "Having a session";
    } elsif ($todays_count <= 8) {
        $squiffy = "Into the first gallon";
    } elsif ($todays_count <= 9) {
        $squiffy = "Ready for more beer";
    } elsif ($todays_count <= 11) {
        $squiffy = "Could be hometime ...";
    } else {
        $squiffy = "2 gallons ... going to snore!";
    }

    print "Andrew has had " . $todays_count . " beers today.  ";
    print "Andrew is likely to be " . $squiffy . ".\n"; 

    exit $todays_count;

} else {
    print "I've no idea how Andrew is .... untapped is drunk.";
    exit 99;
}

