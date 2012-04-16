package SNMPLib::MIB::IF_TABLE_REL;

use strict;
use warnings;

use base qw(SNMPLib::MIB);

__PACKAGE__->set_MIB('CISCO-VLAN-IFTABLE-RELATIONSHIP-MIB');






__PACKAGE__->add_table('cviVlanInterfaceIndexTable',{
				       index   => {
						   name => 'index',
						  },
				       columns => [
						   {
						    name => 'cviVlanId',
						   },
						   {
						    name => 'cviPhysicalIfIndex',
						   },
						   {
						    name => 'cviRoutedVlanIfIndex',
						   },
						   ]
				      }
		      );




1;
