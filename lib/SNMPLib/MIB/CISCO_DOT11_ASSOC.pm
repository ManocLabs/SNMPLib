package SNMPLib::MIB::CISCO_DOT11_ASSOC;

use strict;
use warnings;

use base qw(SNMPLib::MIB);



__PACKAGE__->set_MIB('CISCO-DOT11-ASSOCIATION-MIB');


__PACKAGE__->add_scalar('cDot11ParentAddress',\&SNMPLib::MIB::munge_mac);

#__PACKAGE__->add_scalar('cDot11ParentAddress');
#__PACKAGE__->add_scalar('entPhysicalSerialNum');
#__PACKAGE__->add_scalar('');





 __PACKAGE__->add_table('cDot11ClientConfigInfoTable',{
 				       index   => {
 						   name => 'ifIndex,cd11IfAuxSsid,Dot11ClientAddress ',
 						 #  munger => \&munge_,
 						  },
 				       columns => [
 						   {
 						    name => 'cDot11ClientParentAddress',
 						    munger=> \&SNMPLib::MIB::munge_mac
 						   },
 						   {
 						    name  => 'cDot11ClientWepEnabled',
 						    #munger=> \&munge_vtpAuthPasswordType
 						   },
 						   {
 						    name => 'cDot11ClientMicEnabled',
 						   },
 						   {
 						    name => 'cDot11ClientDataRateSet',
 						   },
 						   {
 						    name => 'cDot11ClientVlanId',
 						   },
 						   {
 						    name => 'cDot11ClientIpAddress',
 						    munger=> \&SNMPLib::MIB::munge_ip,						   },
 						  ]
 				      }
 		      );



 __PACKAGE__->add_table('cDot11ClientStatistics',{
 				       index   => {
 						   name => 'cDot11ClientSignalStrength',
 						 #  munger => \&munge_,
 						  },
 				       columns => [
 						   {
 						    name => 'cDot11ClientSigQuality',
 						   },
 						   {
 						    name  => 'cDot11ClientAssociationState',
 						    #munger=> \&munge_vtpAuthPasswordType
 						   },
 						   {
 						    name => 'cDot11ClientAuthenAlgorithm',
 						   },
 						   {
 						    name => 'cDot11ClientAdditionalAuthen',
 						    munger=> \&munge_addauthen

 						   },
 						   {
 						    name => 'cDot11ClientDot1xAuthenAlgorithm',
 						    munger=> \&munge_1xauthen

 						   },
 						   {
 						    name => 'cDot11ClientKeyManagement',
 						    munger=> \&munge_keymgt
 						   },
 						   {
 						    name => 'cDot11ClientUnicastCipher',
 						    munger=> \&munge_cipher
 						   },
 						   {
						    name => 'cDot11ClientMulticastCipher',
 						    munger=> \&munge_cipher
						    },
 						  ]
 				      }
 		      );



 __PACKAGE__->add_table('cd11IfCipherStatsTable',{
 				       index   => {
 						   name => 'ifIndex',
 						 #  munger => \&munge_,
 						  },
 				       columns => [
 						   {
 						    name => 'cd11IfCipherMicFailClientAddress',
 						   },
 						   {
 						    name  => 'cd11IfCipherTkipLocalMicFailures',
 						    #munger=> \&munge_vtpAuthPasswordType
 						   },
 						   {
 						    name => 'cd11IfCipherTkipRemotMicFailures',
 						   },
						   ]
 				      }
 		      );

sub munge_keymgt {
    my $bits = shift;
    return {
	wpa	=> vec($bits, 7, 1),      
	cckm	=> vec($bits, 6, 1),
	}
}

sub munge_addauthen {
    my $bits = shift;
    return {
	mac	=> vec($bits, 7, 1),      
	eap	=> vec($bits, 6, 1),
    }
}


sub munge_1xauthen {
    my $bits = shift;
    return {
	md5	=> vec($bits, 7, 1),      
	leap	=> vec($bits, 6, 1),
	peap	=> vec($bits, 5, 1),
	eapTls	=> vec($bits, 4, 1),
	eapSim	=> vec($bits, 3, 1),
	eapFast	=> vec($bits, 2, 1),
    }
}

sub munge_cipher {
    my $bits = shift;
    return {
	ckip	=> vec($bits, 7, 1),      
	cmic	=> vec($bits, 6, 1),           
	tkip	=> vec($bits, 5, 1),   
	wep40	=> vec($bits, 4, 1),
	wep128	=> vec($bits, 3, 1), 
	aesccm	=> vec($bits, 2, 1)
	}
}



# sub munge_vlanTrunkPortDynamicStatus {
#   my $value = shift;
  
#   return $TRUNKDYN_STATUS[$value];
# }

# 1;
