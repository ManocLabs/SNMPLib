package SNMPLib::MIB::Q_BRIDGE;

use strict;
use warnings;

use base qw(SNMPLib::MIB);

my @PROT_SPEC = qw (
		   nop unknown  decLb100 ieee8021d
		   );

my @PORT_STATE = qw (
		   nop disabled blocking listening 
		   learning forwarding broken
		   );

my @PORT_ENABLE = qw (
		   nop enabled disabled
		   );

my @FDB_STATUS = qw (
		   nop other invalid learned self mgmt
		   );



__PACKAGE__->set_MIB('Q-BRIDGE-MIB');









__PACKAGE__->add_table('dot1qVlanStaticTable',{
				  index   => {
					      name => 'dot1qVlanIndex',
					      #munger => \&test,
					   },
				  columns => [
					      {
						  name => 'dot1qVlanStaticName',
 					      },  
					      {
						  name => 'dot1qVlanStaticEgressPorts',
 					      },  
					      {
						  name => 'dot1qVlanForbiddenEgressPorts',
 					      },  
					      {
						  name => 'dot1qVlanStaticUntaggedPorts',
					      },    
					      {
						  name => 'dot1qVlanStaticRowStatus',
					      },
					      ]
				 }
		      );
__PACKAGE__->add_table('dot1qVlanCurrentTable',{
				  index   => {
					      name => 'dot1qVlanIndex',
					      #munger => \&test,
					   },
				  columns => [
					      {
						  name => 'dot1qVlanCurrentEgressPorts',
 					      },  
					      {
						  name => 'dot1qVlanStatus',
 					      },  
					      {
						  name => 'dot1qVlanCurrentEgressPorts',
 					      },  
					      {
						  name => 'dot1qVlanCurrentUntaggedPorts',
					      },    
					      {
						  name => 'dot1qVlanTimeMark',
					      },
					      ]
				 }
		      );


 
#  sub munge_FdbTableIndex{
#      my $idx = shift;
#      my @values = split( /\./, $idx );
#      my $fdb_id = shift(@values);
#      return ( $fdb_id.' '.join( ':', map { sprintf "%02x", $_ } @values ) );
#  }


