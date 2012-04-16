package SNMPLib::Device::3Com;
use strict;
use warnings;

use base qw(SNMPLib::Device);

#my $ref = MIB::RFC1213->new();
#$ref->set_munger('ifTable','ifDescr',\&test);

my @MIB_list = (  'RFC1213' , 'BRIDGE' );

__PACKAGE__->set_dev('3Com');
__PACKAGE__->add_MIB_list(\@MIB_list );



1;



