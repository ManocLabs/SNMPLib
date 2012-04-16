package SNMPLib::MIB::CISCO_PORT_SECURITY;

use strict;
use warnings;

use base qw(SNMPLib::MIB);

my @SEC_STATUS = qw (
		   nop secureup Disabled shutdown
		   );
my @VIOL_ACT = qw (
		   nop shutdown dropNotify drop
		   );

__PACKAGE__->set_MIB('CISCO-PORT-SECURITY-MIB');

 __PACKAGE__->add_scalar('cpsGlobalMaxSecureAddress');
 __PACKAGE__->add_scalar('cpsGlobalTotalSecureAddress');
 __PACKAGE__->add_scalar('cpsGlobalPortSecurityEnable');
 __PACKAGE__->add_scalar('cpsGlobalSNMPNotifRate');
 __PACKAGE__->add_scalar('cpsGlobalSNMPNotifControl');
 __PACKAGE__->add_scalar('cpsGlobalClearSecureMacAddresses');


__PACKAGE__->add_table('cpsIfConfigTable',{
				  index => {
				      name => 'ifIndex',
				      munger => undef,
					   },
				  columns => [
 					      {
						  name => 'cpsIfPortSecurityEnable',
						  munger=> \&SNMPLib::MIB::munge_bool,
 					      },
					      {
						  name => 'cpsIfPortSecurityStatus',
						  munger=> \&munge_cpsIfPortSecurityStatus,
 					      },
					      {
						  name => 'cpsIfMaxSecureMacAddr',
					      },
					      {
						  name => 'cpsIfCurrentSecureMacAddrCount',
					      },
					      {
						  name => 'cpsIfSecureMacAddrAgingTime',
					      },
					      {
						  name => 'cpsIfSecureMacAddrAgingType',
					      },
					      {
						  name => 'cpsIfStaticMacAddrAgingEnable',
						  munger=> \&SNMPLib::MIB::munge_bool,
					      },
					      {
						  name => 'cpsIfViolationAction',
						  munger=> \&munge_cpsIfViolationAction

					      },
					      {
						  name => 'cpsIfViolationCount',
					      },
					      {
						  name => 'cpsIfSecureLastMacAddress',
						  munger=> \&SNMPLib::MIB::munge_mac

					      },
					      {
						  name => 'cpsIfClearSecureAddresses',
					      },
					      {
						  name => 'cpsIfUnicastFloodingEnable',
					      },
					      {
						  name => 'cpsIfShutdownTimeout',
					      },
					      {
						  name => 'cpsIfClearSecureMacAddresses',
					      },
					      {
						  name => 'cpsIfStickyEnable',
						  munger=> \&SNMPLib::MIB::munge_bool,
					      },
					      {
						  name => 'cpsIfInvalidSrcRateLimitEnable',
						  munger=> \&SNMPLib::MIB::munge_bool,
					      },
					      {
						  name => 'cpsIfInvalidSrcRateLimitValue',
					      },
					      {
						  name => 'cpsIfSecureLastMacAddrVlanId',
					      },
					      ]
				 }
		      );

__PACKAGE__->add_table('cpsSecureMacAddressTable',{
				  index => {
				      name => 'ifIndex, cpsSecureMacAddress',
				      munger => undef,
					   },
				  columns => [
					      {
						  name  => 'cpsSecureMacAddress',
						  munger=> \&SNMPlib::MIB::munge_mac
 					      },
 					      {
						  name => 'cpsSecureMacAddrType',
 					      },
					      {
						  name => 'cpsSecureMacAddrRemainingAge',
 					      },
					      {
						  name => 'cpsSecureMacAddrRowStatus',
					      },
					      ]
				 }
		      );

__PACKAGE__->add_table('cpsIfVlanTable',{
				  index => {
				      name => 'ifIndex, cpsIfVlanIndex',
				      munger => undef,
					   },
				  columns => [
					      {
						  name  => 'cpsIfVlanIndex',
 					      },
 					      {
						  name => 'cpsIfVlanMaxSecureMacAddr',
 					      },
					      {
						  name => 'cpsIfVlanCurSecureMacAddrCount',
 					      },
					      ]
				 }
		      );

__PACKAGE__->add_table('cpsIfMultiVlanTable',{
				  index => {
				      name => 'ifIndex, cpsIfMultiVlanIndex',
				      munger => undef,
					   },
				  columns => [
					      {
						  name  => 'cpsIfMultiVlanIndex',
						  #munger=> \&
 					      },
 					      {
						  name => 'cpsIfMultiVlanMaxSecureMacAddr',
 					      },
					      {
						  name => 'cpsIfMultiVlanSecureMacAddrCount',
 					      },
					      {
						  name => 'cpsIfMultiVlanClearSecureMacAddr',
					      },
					      {
						  name => 'cpsIfMultiVlanRowStatus',
					      },
					      ]
				 }
		      );


sub munge_cpsIfPortSecurityStatus {
    my $value = shift;

    return $SEC_STATUS[$value];
}


sub munge_cpsIfViolationAction {
    my $value = shift;

    return $VIOL_ACT[$value];
}

# sub munge_macaddr {
#      my $idx = shift;
#      my @values = split( /\./, $idx );
#      return (join( ':', map { sprintf "%02x", $_ } @values ) );
#  }
