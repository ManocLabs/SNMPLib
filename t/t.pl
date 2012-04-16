#!/usr/bin/perl -w

use warnings;
use strict;

#package main;

use Class::MOP;
    use Data::Dumper;



 my $t = Class::MOP::Class->create(
      'Bar' => (
          version      => '0.01',
        #  superclasses => ['SNMP'],
          attributes   => [
              Class::MOP::Attribute->new('attr1'),
              Class::MOP::Attribute->new('attr2'),
          ],
        
      )
  );

$t->attr1("YOOHOO");

print Dumper($t);

