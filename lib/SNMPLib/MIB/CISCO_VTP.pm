package SNMPLib::MIB::CISCO_VTP;

use strict;
use warnings;

use base qw(SNMPLib::MIB);
use Data::Dumper;

my @VLAN_TYPES = qw( nop ethernet fddi tokenRing fddiNet
                   trNet  deprecated );
my @VLANSTATE_TYPES = qw(  nop operational suspended mtuTooBigForDevice
			   mtuTooBigForTrunk );
my @TRUNKDYN_STATUS = qw(nop trunking  notTrunking );

my @TRUNKDYN_STATE = qw(nop on  off desiderable auto onNoNegotiate );

my @DOMAIN_MODES = qw(nop client server transparent off );

my @DOMAIN_VERSION = qw(nop version1 version2 none version3  );

my @STP_TYPE = qw(nop ieee ibm hybrid );

my @AUTH_TYPE = qw(nop plaintext hidden );

__PACKAGE__->set_MIB('CISCO-VTP-MIB');

 __PACKAGE__->include_MIB('VPN-TC-STD-MIB');

__PACKAGE__->add_scalar('vtpVersion');
#__PACKAGE__->add_scalar('managementDomainName');
__PACKAGE__->add_scalar('vtpMaxVlanStorage');
__PACKAGE__->add_scalar('vtpNotificationsEnabled');

__PACKAGE__->add_function('vlan',\&i_vlan);


__PACKAGE__->add_table('managementDomainTable',{
				       index   => {
						   name => 'managementDomainIndex',
						 #  munger => \&munge_,
						  },
				       columns => [
						   {
						    name => 'managementDomainName',
						   },
						   {
						    name  => 'managementDomainLocalMode',
						    munger=> \&munge_managementDomainLocalMode
						   },
						   {
						    name => 'managementDomainConfigRevNumber',
						   },
						   {
						    name => 'managementDomainLastUpdater',
						   },
						   {
						    name => 'managementDomainLastChange',
						   },
						   {
						    name => 'managementDomainRowStatus',
						   },
						   {
						    name => 'managementDomainTftpServer',
						   },
						   {
						    name => 'managementDomainTftpPathname',
						   },
						   {
						    name => 'managementDomainPruningState',
						   },
						   {
						    name => 'managementDomainVersionInUse',
						    munger=> \&munge_managementDomainVersionInUse,
						   },
						  ]
				      }
		      );



 __PACKAGE__->add_table('vtpAuthenticationTable',{
 				       index   => {
 						   name => 'managementDomainIndex',
 						 #  munger => \&munge_,
 						  },
 				       columns => [
 						   {
 						    name => 'vtpAuthPassword',
 						   },
 						   {
 						    name  => 'vtpAuthPasswordType',
 						    munger=> \&munge_vtpAuthPasswordType
 						   },
 						   {
 						    name => 'vtpAuthSecretKey',
 						   },
 						  ]
 				      }
 		      );



__PACKAGE__->add_table('vtpVlanTable',{
				       index   => {
						   name => 'vtpVlanIndex',
						   munger => \&munge_vtpVlanIndex,
						  },
				       columns => [
						   {
						    name => 'vtpVlanName',
						   },
						   {
						    name  => 'vtpVlanState',
						    munger=> \&munge_vtpVlanState
						   },
						   {
						    name => 'vtpVlanType',
						   },
						   {
						    name => 'vtpVlanMtu',
						   },
						   {
						    name => 'vtpVlanDot10Said',
						   },
						   {
						    name => 'vtpVlanRingNumber',
						   },
						   {
						    name => 'vtpVlanBridgeNumber',
						   },
						   {
						    name => 'vtpVlanStpType',
						    munger=> \&munge_vtpVlanStpType
						   },
						   {
						    name => 'vtpVlanParentVlan',
						   },
						   {
						    name => 'vtpVlanTranslationalVlan1',
						   },
						   {
						    name => 'vtpVlanTranslationalVlan2',
						   },
						   {
						    name => 'vtpVlanBridgeType',
						   },
						   {
						    name => 'vtpVlanAreHopCount',
						   },
						   {
						    name => 'vtpVlanSteHopCount',
						   },
						   {
						    name => 'vtpVlanTypeExt',
						   },
						   {
						    name => 'vtpVlanIfIndex',
						   },
						   ]
				      }
		      );


__PACKAGE__->add_table('vlanTrunkPortTable',{
 				  index   => {
 					      name => 'vlanTrunkPortIfIndex',
 					      #munger => \&,
 					   },
 				  columns => [
 					      {
  					       name  => 'vlanTrunkPortManagementDomain',
  					      },
  					      {
  					       name => 'vlanTrunkPortNativeVlan',
  					      },  
 					      {
  					       name => 'vlanTrunkPortDynamicState',
					       munger => \&munge_vlanTrunkPortDynamicState,
  					      },    
 					      {
  					       name => 'vlanTrunkPortVtpEnabled',
  					      },    
 					      {
  					       name => 'vlanTrunkPortDynamicStatus',
					       munger => \&munge_vlanTrunkPortDynamicStatus  					      },    
 					      {
  					       name => 'vlanTrunkPortEncapsulationType',
 					      },    
 					      {
  					       name => 'vlanTrunkPortVlansEnabled',
					      },    
 					      {
  					       name => 'vlanTrunkPortNativeVlan',
 					      },    
 					      {
  					       name => 'vlanTrunkPortRowStatus',
					      },    
 					      {
  					       name => 'vlanTrunkPortInJoins',
 					      } ,   
 					      {
  					       name => 'vlanTrunkPortOutJoins',
					      },    
 					      {
  					       name => 'vlanTrunkPortOldAdverts',
 					      },    
					      {
  					       name => 'vlanTrunkPortVtpEnabled',
					      },    
 					      {
  					       name => 'vlanTrunkPortDot1qTunnel',
 					      },
					     ]
				 }
		      );



sub munge_vtpVlanIndex{
  
  my $value = shift;
  $value =~ s/^1\.//;
  return $value;
}

sub munge_managementDomainLocalMode{
    my $value = shift;
    
    return $DOMAIN_MODES[$value];    
}

sub munge_managementDomainVersionInUse{
    my $value = shift;
  
    return $DOMAIN_VERSION[$value];
}

sub munge_vtpAuthPasswordType{
    my $value = shift;
  
    return $AUTH_TYPE[$value];
}

sub munge_vtpVlanStpType{
    my $value = shift;
    
    return $STP_TYPE[$value];
}


sub munge_vtpVlanState{
  my $value = shift;
  
  return $VLANSTATE_TYPES[$value];
}

sub munge_vlanTrunkPortDynamicStatus {
  my $value = shift;
  
  return $TRUNKDYN_STATUS[$value];
}

sub munge_vlanTrunkPortDynamicState {
  my $value = shift;
  
  return $TRUNKDYN_STATE[$value];
}

 sub i_vlan {
     my $self     = shift;
    
     my $vlan_info      = 
	 $self->vlanTrunkPortTable('vlanTrunkPortNativeVlan','vlanTrunkPortDynamicStatus') || {};
     my $i_vlan         = $self->vmMembershipTable('vmVlan')            || {};

     my %i_vlans;

       # Get access ports
       foreach my $port ( keys %$i_vlan ) {
           my $vlan = $i_vlan->{$port}->{'vmVlan'};
           next unless defined $vlan;

           $i_vlans{$port} = $vlan;
       }

        # Get trunk ports
        foreach my $port ( keys %$vlan_info ) {
            my $vlan = $vlan_info->{$port}->{'vlanTrunkPortNativeVlan'};
            next unless defined $vlan;
            my $stat = $vlan_info->{$port}->{'vlanTrunkPortDynamicStatus'};
             if ( defined $stat and $stat =~ /^trunking/ ) {
                 $i_vlans{$port} = $vlan;
 	      }
        }

       #  Check in CISCO-VLAN-IFTABLE-RELATION-MIB
       #  Is this only for Aironet???  If so, it needs
       #  to be removed from this class

        my $v_cvi_if = $self->cviVlanInterfaceIndexTable('cviRoutedVlanIfIndex');
        if ( defined $v_cvi_if ) {

            # Translate vlan.physical_interface -> iid
            #       to iid -> vlan
            foreach my $i ( keys %$v_cvi_if ) {
                my ( $vlan, $phys ) = split( /\./, $i );
                my $iid = $v_cvi_if->{$i}->{'cviRoutedVlanIfIndex'};

                $i_vlans{$iid} = $vlan;
            }
        }

     return \%i_vlans;
 }








1;
