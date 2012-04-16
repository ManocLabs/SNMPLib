package SNMPLib::MIB::CISCO_VLAN_MEMB;

use strict;
use warnings;

use base qw(SNMPLib::MIB);

__PACKAGE__->set_MIB('CISCO-VLAN-MEMBERSHIP-MIB');


__PACKAGE__->add_scalar('vmNotificationsEnabled');
__PACKAGE__->add_scalar('vmVmpsVQPVersion');
__PACKAGE__->add_scalar('vmVmpsCurrent');



__PACKAGE__->add_table('vmMembershipTable',{
				       index   => {
						   name => 'ifIndex',
						 #  munger => \&SNMPLib::MIB::RFC1213::munge_ifIndex,
						  },
				       columns => [
						   {
						    name => 'vmVlanType',
						   },
						   {
						    name => 'vmVlan',
						   },
						   {
						    name => 'vmPortStatus',
						   },
						   {
						    name => 'vmVlans2k',
						   },
						   {
						    name => 'vmVlans3k',
						   },
						   {
						    name => 'vmVlans4k',
						   },
						   ]
				      }
		      );
__PACKAGE__->add_table('vmVoiceVlanTable',{
				       index   => {
						   name => 'ifIndex',
						 #  munger => \&SNMPLib::MIB::RFC1213::munge_ifIndex,
						  },
				       columns => [
						   {
						    name => 'vmVoiceVlanId',
						   },
						   {
						    name => 'vmVoiceVlanCdpVerifyEnable',
						   },
						   ]
				      }
		      );







# sub munge_vlanTrunkPortDynamicStatus {
#   my $value = shift;
  
#   return $TRUNKDYN_STATUS[$value];
# }

1;
