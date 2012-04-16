package SNMPLib::MIB::CISCO_DOT11;

use strict;
use warnings;

use base qw(SNMPLib::MIB);



__PACKAGE__->set_MIB('CISCO-DOT11-IF-MIB');


 __PACKAGE__->add_table('cd11IfAuxSsidTable',{
 				       index   => {
 						   name => 'cd11IfAuxSsidIndex',
 						 #  munger => \&munge_,
 						  },
 				       columns => [
 						   {
 						    name => 'cd11IfAuxSsid',
 						   },
 						   {
 						    name  => 'cd11IfAuxSsidBroadcastSsid',
 						    #munger=> \&munge_vtpAuthPasswordType
 						   },
 						   {
 						    name => 'cd11IfAuxSsidMaxAssocSta',
 						   },
 						   {
 						    name => 'cd11IfAuxSsidMicAlgorithm',
 						   },
 						   {
 						    name => 'cd11IfAuxSsidWepPermuteAlg',
 						   },,
 						   {
 						    name => 'cd11IfAuxSsidBroadcastSsid',
 						   },
 						  ]
 				      }
 		      );


 __PACKAGE__->add_table('cd11IfPhyDsssTable',{
 				       index   => {
 						   name => 'ifIndex',
 						 #  munger => \&munge_,
 						  },
 				       columns => [
 						   {
 						    name => 'cd11IfPhyDsssMaxCompatibleRate',
 						   },
 						   {
 						    name  => 'cd11IfPhyDsssChannelAutoEnable',
 						   },
 						   {
 						    name => 'cd11IfPhyDsssCurrentChannel',
 						   }
 						  ]
 				      }
 		      );

 __PACKAGE__->add_table('cd11IfPhyDsssTable',{
 				       index   => {
 						   name => 'ifIndex',
 						 #  munger => \&munge_,
 						  },
 				       columns => [
 						   {
 						    name => 'cd11IfPhyDsssCurrentChannel',
 						   },
 						   {
 						    name  => '',
 						   },
 						  ]
 				      }
 		      );






# sub munge_vlanTrunkPortDynamicStatus {
#   my $value = shift;
  
#   return $TRUNKDYN_STATUS[$value];
# }

# 1;
