package SNMPLib::MIB::BRIDGE;

use strict;
use warnings;
use Data::Dumper;
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



__PACKAGE__->set_MIB('BRIDGE-MIB');

__PACKAGE__->add_scalar('dot1dBaseBridgeAddress');
__PACKAGE__->add_scalar('dot1dBaseNumPorts');
__PACKAGE__->add_scalar('dot1dBaseType');

__PACKAGE__->add_scalar('dot1dStpProtocolSpecification',\&munge_dot1dStpProtocolSpecification);
__PACKAGE__->add_scalar('dot1dStpPriority');
__PACKAGE__->add_scalar('dot1dStpTimeSinceTopologyChange');
__PACKAGE__->add_scalar('dot1dStpTopChanges');
__PACKAGE__->add_scalar('dot1dStpDesignatedRoot');
__PACKAGE__->add_scalar('dot1dStpRootCost');
__PACKAGE__->add_scalar('dot1dStpRootPort');
__PACKAGE__->add_scalar('dot1dStpMaxAge');
__PACKAGE__->add_scalar('dot1dStpHelloTime');
__PACKAGE__->add_scalar('dot1dStpHoldTime');
__PACKAGE__->add_scalar('dot1dStpForwardDelay');
__PACKAGE__->add_scalar('dot1dStpBridgeMaxAge');
__PACKAGE__->add_scalar('dot1dStpBridgeHelloTime');
__PACKAGE__->add_scalar('dot1dStpBridgeForwardDelay');
__PACKAGE__->add_scalar('dot1dTpLearnedEntryDiscards');
__PACKAGE__->add_scalar('dot1dTpAgingTime');


__PACKAGE__->add_function('portState',\&i_stp_state);
__PACKAGE__->add_function('get_mat',\&get_mat);



__PACKAGE__->add_table('dot1dBasePortTable',{
				  index   => {
					      name => 'dot1dBasePort',
					      #munger => \&test,
					   },
				  columns => [
					      {
						  name => 'dot1dBasePortIfIndex',
 					      },  
					      {
						  name => 'dot1dBasePortCircuit',
 					      },  
					      {
						  name => 'dot1dBasePortDelayExceededDiscards',
 					      },  
					      {
						  name => 'dot1dBasePortMtuExceededDiscards',
					      },  
					      ]
				 }
		      );
                     
__PACKAGE__->add_table('dot1dStpPortTable',{
				  index   => {
					      name => 'dot1dStpPort',
					      #munger => \&test,
					   },
				  columns => [
					      {
						  name => 'dot1dStpPortPriority',
 					      },  
					      {
						  name   => 'dot1dStpPortState',
						  munger => \&munge_dot1dStpPortState
 					      },  
					      {
						  name => 'dot1dStpPortEnable',
						  munger => \&munge_dot1dStpPortEnable
						  },  
					      {
						  name => 'dot1dStpPortPathCost',
					      },  
					      {
						  name => 'dot1dStpPortDesignatedRoot',
						  munger => \&SNMPLib::MIB::munge_mac,
					      },
					      {
						  name => 'dot1dStpPortDesignatedCost',
					      },
					      {
						  name => 'dot1dStpPortDesignatedBridge',
						  munger => \&SNMPLib::MIB::munge_mac,

					      }, 
					      {
						  name => 'dot1dStpPortDesignatedPort',
						  munger => \&SNMPLib::MIB::munge_mac,
					      },
					      {
						  name => 'dot1dStpPortForwardTransitions',
					      },
					      {
						  name => 'dot1dStpPortPathCost32',
					      },
					      ]
				 }
		      );


__PACKAGE__->add_table('dot1dTpFdbTable',{
                                  index =>  {
				              name   => 'index',
					      munger => \&munge_FdbTableIndex,
					  },
				  columns => [
					      {
						  name => 'dot1dTpFdbPort',
 					      },  
					      {
						  name => 'dot1dTpFdbStatus',
						  munger => \&munge_dot1dTpFdbStatus
						},
					      {
						  name => 'dot1dTpFdbAddress',
						  munger => \&SNMPLib::MIB::munge_mac,
 					      },
					      ]
				 }
		      );


__PACKAGE__->add_table('dot1dTpPortTable',{
				  index   => {
					      name => 'dot1dTpPort',
					      #munger => \&test,
					   },
				  columns => [
					      {
						  name => 'dot1dTpPortMaxInfo',
 					      },  
					      {
						  name => 'dot1dTpPortInFrames',
 					      },  
					      {
						  name => 'dot1dTpPortOutFrames',
 					      },  
					      {
						  name => 'dot1dTpPortInDiscards',
					      },  
					      ]
				 }
		      );



__PACKAGE__->add_table('dot1dStaticTable',{
				  index   => {
					      name => 'dot1dStaticAddress,dot1dStaticReceivePort',
					      #munger => \&test,
					   },
				  columns => [
					      {
						  name => 'dot1dStaticReceivePort',
 					      },  
					      {
						  name => 'dot1dStaticAllowedToGoTo',
 					      },  
					      {
						  name => 'dot1dStaticStatus',
 					      }  
					      ]
				 }
		      );


1;


sub munge_dot1dStpProtocolSpecification {
    my $value = shift;

    return $PROT_SPEC[$value];
}


sub munge_dot1dStpPortState {
    my $value = shift;

    return $PORT_STATE[$value];
}

sub munge_dot1dTpFdbStatus {
    my $value = shift;

    return $FDB_STATUS[$value];
}

sub munge_dot1dStpPortEnable {
    my $value = shift;

    return $PORT_ENABLE[$value];
}
 
 sub munge_FdbTableIndex{
     my $idx = shift;
     my @values = split( /\./, $idx );
     my $fdb_id = shift(@values);
     return ( $fdb_id.' '.join( ':', map { sprintf "%02x", $_ } @values ) );
 }


sub i_stp_state {
    my $self  = shift;

    my $bp_index    = $self->dot1dBasePortTable('dot1dBasePortIfIndex');#bp_index();
    my $stp_p_state = $self->dot1dStpPortTable('dot1dStpPortState');#stp_p_state();

    my %i_stp_state;

    foreach my $index ( keys %$stp_p_state ) {
        my $state = $stp_p_state->{$index}->{'dot1dStpPortState'};
        my $iid   = $bp_index->{$index}->{'dot1dBasePortIfIndex'};
        next unless defined $iid;
        next unless defined $state;
        $i_stp_state{$iid} = $state;
    }

    return \%i_stp_state;
}

sub get_mat {
    my $self = shift;
    
    my $mat = $self->{'cache'}->{_manoc_mat};
    defined($mat) and return $mat;
    
    my $interfaces = $self->interfaces();
    my $fw_table   = $self->dot1dTpFdbTable; 
    my $bp_index   = $self->dot1dBasePortTable('dot1dBasePortIfIndex');#bp_index();
    
    my ($status, $mac, $bp_id, $iid, $port);
    $mat = {};
    foreach my $fw_index (keys %$fw_table) {
        $status = $fw_table->{$fw_index}->{'dot1dTpFdbStatus'};
        next if defined($status) and $status eq 'self';
        $mac   = $fw_table->{$fw_index}->{'dot1dTpFdbAddress'};
        $bp_id = $fw_table->{$fw_index}->{'dot1dTpFdbPort'};
        next unless defined $bp_id;
        $iid = $bp_index->{$bp_id}->{'dot1dBasePortIfIndex'};
        next unless defined $iid;
        $port  = $interfaces->{$iid}->{'ifDescr'};
        $port and $mat->{$mac} = $port;
    }

    $self->{'cache'}->{_manoc_mat} = $mat;
    return $mat;
}
