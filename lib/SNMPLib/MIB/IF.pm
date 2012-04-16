package SNMPLib::MIB::IF;

use strict;
use warnings;

use base qw(SNMPLib::MIB);

my @OPER_STATUS = qw (
		   nop up down testing dormant notPresent lowerLayerDown
		   );

my @ADDR_TYPE = qw (
		   nop other volatile nonVolatile
		   );


__PACKAGE__->set_MIB('IF-MIB');

__PACKAGE__->add_scalar('ifNumber');
__PACKAGE__->add_scalar('ifTableLastChange');


__PACKAGE__->add_table('ifTable',{
				  index => {
				      name => 'ifIndex',
				      munger => undef,
					   },
				  columns => [
					      {
						  name  => 'ifDescr',
						  #munger=> \&
 					      },
					      {
						  name  => 'ifIndex',
						  #munger=> \&
 					      },
 					      {
						  name => 'ifPhysAddress',
 					      },
					      {
						  name => 'ifType',
 					      },
					      {
						  name => 'ifMtu',
					      },
					      {
						  name => 'ifSpeed',
					      },
					      {
						  name => 'ifPhysAddress',
					      },
					      {
						  name => 'ifAdminStatus',
					      },
					      {
						  name => 'ifOperStatus',
						  munger=> \&munge_ifOperStatus
					      },
					      {
						  name => 'ifLastChange',
					      },
					      {
						  name => 'ifInOctets',
					      },
					      {
						  name => 'ifInUcastPkts',
					      },
					      {
						  name => 'ifInNUcastPkts',
					      },
					      {
						  name => 'ifInDiscards',
					      },
					      {
						  name => 'ifInErrors',
					      },
					      {
						  name => 'ifInUnknownProtos',
					      },
					      {
						  name => 'ifOutOctets',
					      },
					      {
						  name => 'ifOutUcastPkts',
					      },
					      {
						  name => 'ifOutNUcastPkts',
					      },
					      {
						  name => 'ifOutDiscards',
					      },
					      {
						  name => 'ifOutErrors',
					      },
					      {
						  name => 'ifOutQLen',
					      },
					      {
						  name => 'ifSpecific',
					      },
					      ]
				 }
		      );

__PACKAGE__->add_table('ifStackTable',{
				  index => {
				      name => 'index_ifStackTable',
				      #munger => \&munge_index_ifStackTable,
					   },
				  columns => [
					      {
						  name => 'ifStackHigherLayer',
 					      },
					      {
						  name => 'ifStackLowerLayer',
 					      },
					      {
						  name => 'ifStackStatus',
					      }
					     ]
				 }
		      );

__PACKAGE__->add_table('ifRcvAddressTable',{
				  index => {
				      name => 'index_ifStackTable',
				      #munger => \&munge_index_ifStackTable,
					   },
				  columns => [
					      {
						  name => 'ifRcvAddressAddress',
 					      },
					      {
						  name => 'ifRcvAddressStatus',
 					      },
					      {
					       name => 'ifRcvAddressType',
					       munger => \&munge_ifRcvAddressType,
					      }
					     ]
				 }
		      );


sub munge_ifOperStatus {
    my $value = shift;

    return $OPER_STATUS[$value];
}

sub munge_ifRcvAddressType {
    my $value = shift;

    return $ADDR_TYPE[$value];
}

# sub munge_index_ifStackTable{
#     my $value = shift;

#     return $OPER_STATUS[$value];
# }
