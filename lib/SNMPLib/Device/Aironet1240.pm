package SNMPLib::Device::Aironet1240;

use strict;
use warnings;

use base qw(SNMPLib::Device);


#my $ref = MIB::RFC1213->new();
#$ref->set_munger('ifTable','ifDescr',\&test);

my @MIB_list = (  'RFC1213' , 'BRIDGE' , 'CISCO_VTP' 'CISCO_DOT11_ASSOCIATION' , 'CISCO_DOT11_IF' );#$ref);

__PACKAGE__->set_dev('Aironet1240');
__PACKAGE__->add_MIB_list(\@MIB_list );


#__PACKAGE__->set_session_method();

1;



