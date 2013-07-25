package Net::Duowan::DNS;

use 5.006;
use warnings;
use strict;
use Carp qw/croak/;
use LWP::UserAgent;
use Net::Duowan::DNS::Zones;
use Net::Duowan::DNS::Records;

use vars qw/$VERSION/;
$VERSION = '1.0';

sub new {
    my $class = shift;
    my %arg = @_;
    
    my $psp = $arg{passport} || croak "no passport provided"; 
    my $token = $arg{token} || croak "no token provided";

    eval {
        require LWP::Protocol::https;
    } or croak "LWP::Protocol::https along with LWP::UserAgent is required";

    bless { psp => $psp, token => $token }, $class;
}

sub zones {
    my $self = shift;
    return Net::Duowan::DNS::Zones->new($self->{psp},$self->{token} );
}

sub records {
    my $self = shift;
    return Net::Duowan::DNS::Records->new($self->{psp},$self->{token} );

}

1;

=head1 NAME

Net::Duowan::DNS - Perl client for Duowan.com's DNS API

=head1 VERSION

Version 1.0

=head1 SYNOPSIS

    use Net::Duowan::DNS;

    my $dwdns = Net::Duowan::DNS->new(passport => 'YY_Passport', 
                                      token => 'Token_to_verify');

    # the object for zones management
    my $z = $dwdns->zones;

    # the object for records management
    my $r = $dwdns->records;

    ##########################
    # zones management methods
    ###########################
    
    # fetch zones
    $re = $z->fetch;

    # check zones
    $re = $z->check('zone1.com','zone2.com');

    # create a zone
    $re = $z->create('zone3.com');

    # remove a zone
    $re = $z->remove('zone3.com');

    ##########################
    # records management methods
    ###########################

    # fetch records' size in a zone
    $re = $r->fetchSize('zone1.com');

    # fetch a record
    $r->fetchOne('zone1.com',rid=>123);

    # fetch all records from a zone
    $re = $r->fetchMulti('zone1.com');

    # fetch the specified range of records
    $re = $r->fetchMulti('zone1.com',offset=>0,number=>10);

    # fetch records by hostname
    $re = $r->fetchbyHost('zone1.com',name=>'www');

    # fetch records by matching host's prefix
    $re = $r->fetchbyPrefix('zone1.com',prefix=>'test*');

    # create a record
    $re = $r->create('zone1.com',name=>'www',content=>'11.22.33.44',isp=>'tel',type=>'A');

    # modify a record
    $re = $r->modify('zone1.com',rid=>123,name=>'www',content=>'5.6.7.8',isp=>'uni',type=>'A');

    # remove a record
    $re = $r->remove('zone1.com',rid=>123);

    # bulk create records
    my $rec =
        [ { type => "A",
            name => "test1",
            content => "1.2.3.4", 
            isp => "tel",
            ttl => 300 
          },
          { type => "A",
            name => "test1", 
            content => "5.6.7.8", 
            isp => "uni",
            ttl => 300 
          }
        ];

    $re = $r->bulkCreate('zone1.com',records=>$rec);

    # bulk remove records
    $re = $r->bulkRemove('zone1.com',rids=>[123,456]);

    # remove records by hostname
    $re = $r->removebyHost('zone1.com',name=>'www');

    # search records
    $r->search('zone1.com',keyword=>'test1');

    ##########################
    # print out the results
    ###########################
    
    # all results returned are hash reference, just dump it
    use Data::Dumper;
    print Dumper $re;


=head1 METHODS

=head2 new(passport=>'string', token=>'string')

The class method for initializing the object.

To use the API, you firstly should sign up an account on YY.com, that's your passport.

The token is obtained from Duowan DNS's user management panel.

For more details please check the API document:

    http://www.nsbeta.info/doc/YY-DNS-API.pdf

=head2 zones()

By calling this instance method, you get an object which has all methods for zones management.

=head2 records()

Similiar to the previous method, it gets all methods for records management.

=head1 AUTHOR

Ken Peng <yhpeng@cpan.org>

=head1 BUGS/LIMITATIONS

If you have found bugs, please send email to <yhpeng@cpan.org>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Net::Duowan::DNS

=head1 COPYRIGHT & LICENSE

Copyright 2013 Ken Peng, all rights reserved.

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.
