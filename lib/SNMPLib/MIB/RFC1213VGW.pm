package SNMPLib::MIB::RFC1213VGW;

use strict;
use warnings;

use base qw(SNMPLib::MIB);

my @IF_TYPES = qw( 
		   nop  none other regular1822 hdh1822 ddn-x25 rfc877-x25
		   ethernet-csmacd iso88023-csmacd iso88024-tokenBus
		   iso88025-tokenRing iso88026-man starLan
		   proteon-10Mbit proteon-80Mbit hyperchannel fddi
		   lapb sdlc ds1 e1 basicISDN primaryISDN
		   propPointToPointSerial ppp softwareLoopback eon
		   ethernet-3Mbit nsip slip ultra ds3 sip frame-relay
		   );

my @RTO_ALGO = qw (
		   nop other constant rsre
		   vanj  rfc2988
		   );
my @IF_STATUS = qw (
		   nop up down testing
		   );

my @ROUTE_TYPE = qw (
		   nop other invalid direct indirect 
		   );
my @IP_PROTO = qw (
		   nop other local netmgmt icmp egp ggp hello rip is-is      
		   es-is ciscoIgrp  bbnSpfIgp ospf bgp 
		   );
my @CONN_STATE = qw (
		   nop closed  listen synSent synReceived established  
                   finWait1 finWait2 closeWait lastAck closing timeWait
                   deleteTCB
		   );


my %SPEED_MAP = (
    '56000'      => '56 kbps',
    '64000'      => '64 kbps',
    '115000'     => '115 kpbs',
    '1500000'    => '1.5 Mbps',
    '1536000'    => 'T1',
    '1544000'    => 'T1',
    '2000000'    => '2.0 Mbps',
    '2048000'    => '2.048 Mbps',
    '3072000'    => 'Dual T1',
    '3088000'    => 'Dual T1',
    '4000000'    => '4.0 Mbps',
    '10000000'   => '10 Mbps',
    '11000000'   => '11 Mbps',
    '20000000'   => '20 Mbps',
    '16000000'   => '16 Mbps',
    '16777216'   => '16 Mbps',
    '44210000'   => 'T3',
    '44736000'   => 'T3',
    '45000000'   => '45 Mbps',
    '45045000'   => 'DS3',
    '46359642'   => 'DS3',
    '51850000'   => 'OC-1',
    '54000000'   => '54 Mbps',
    '64000000'   => '64 Mbps',
    '100000000'  => '100 Mbps',
    '149760000'  => 'ATM on OC-3',
    '155000000'  => 'OC-3',
    '155519000'  => 'OC-3',
    '155520000'  => 'OC-3',
    '400000000'  => '400 Mbps',
    '599040000'  => 'ATM on OC-12',
    '622000000'  => 'OC-12',
    '622080000'  => 'OC-12',
    '1000000000' => '1.0 Gbps',
    '2488000000' => 'OC-48',
);


__PACKAGE__->set_MIB('RFC1213-MIB');


__PACKAGE__->add_scalar('sysDescr');
__PACKAGE__->add_scalar('sysName');
__PACKAGE__->add_scalar('tcpRtoAlgorithm',\&munge_tcpRtoAlgorithm);
__PACKAGE__->add_scalar('ipForwarding');
__PACKAGE__->add_scalar('sysServices');
__PACKAGE__->add_scalar('ifNumber');
__PACKAGE__->add_scalar('sysObjectID');
__PACKAGE__->add_scalar('sysUpTime');
__PACKAGE__->add_scalar('sysContact');
__PACKAGE__->add_scalar('sysLocation');
__PACKAGE__->add_scalar('sysServices');
__PACKAGE__->add_scalar('ipDefaultTTL');
__PACKAGE__->add_scalar('ipInReceives');
__PACKAGE__->add_scalar('ipInHdrErrors');
__PACKAGE__->add_scalar('ipInAddrErrors');
__PACKAGE__->add_scalar('ipForwDatagrams');
__PACKAGE__->add_scalar('ipInUnknownProtos');
__PACKAGE__->add_scalar('ipInDiscards');
__PACKAGE__->add_scalar('ipInDelivers');
__PACKAGE__->add_scalar('ipOutRequests');
__PACKAGE__->add_scalar('ipOutDiscards');
__PACKAGE__->add_scalar('ipOutNoRoutes');
__PACKAGE__->add_scalar('ipReasmTimeout');
__PACKAGE__->add_scalar('ipReasmReqds');
__PACKAGE__->add_scalar('ipReasmOKs');
__PACKAGE__->add_scalar('ipReasmFails');
__PACKAGE__->add_scalar('ipFragOKs');
__PACKAGE__->add_scalar('ipFragFails');
__PACKAGE__->add_scalar('ipFragCreates');
 __PACKAGE__->add_scalar('tcpRtoMin');
 __PACKAGE__->add_scalar('tcpRtoMax');
 __PACKAGE__->add_scalar('tcpMaxConn');
 __PACKAGE__->add_scalar('tcpActiveOpens');
 __PACKAGE__->add_scalar('tcpPassiveOpens');
 __PACKAGE__->add_scalar('tcpAttemptFails');
 __PACKAGE__->add_scalar('tcpEstabResets');
 __PACKAGE__->add_scalar('tcpCurrEstab');
 __PACKAGE__->add_scalar('tcpInSegs');
 __PACKAGE__->add_scalar('tcpOutSegs');
 __PACKAGE__->add_scalar('tcpRetransSegs');
 __PACKAGE__->add_scalar('udpInDatagrams');
 __PACKAGE__->add_scalar('udpNoPorts');
 __PACKAGE__->add_scalar('udpInErrors');
 __PACKAGE__->add_scalar('udpOutDatagrams');

 __PACKAGE__->add_function('interfaces', \&emulate_interfaces );

sub emulate_interfaces {
    my $self = shift;
    my $table = $self->ifTable('ifName');

    foreach my $key (keys(%$table)) {
	$table->{$key}->{'ifDescr'} = undef;
    }

    return $table;
}

 __PACKAGE__->add_table('ifTable',{
 				  index   => {
 					      name => 'ifIndex',
    					   },
 				  columns => [
 					      {
  					       name  => 'ifDescr',
  					       #munger=> \&
  					      },
					      {
  					       name => 'ifType',
 					       munger=> \&munge_iftype,
  					      },  
 					      {
  					       name => 'ifMtu',
  					      },  
 					      {
  					       name => 'ifSpeed',
 					       munger=> \&munge_ifspeed,
  					      },  
 					      {
  					       name => 'ifPhysAddress',
  					      },  
 					      {
  					       name => 'ifAdminStatus',
 					       munger=> \&munge_ifstatus,
  					      },  
 					      {
  					       name => 'ifOperStatus',
 					   #    munger=> \&munge_ifstatus,
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

__PACKAGE__->add_table('ipRouteTable',{
				  index   => {
					      name => 'ipRouteIfIndex',
					      #munger => \&test,
					   },
				  columns => [
					      {
 					       name  => 'ipRouteDest',
 					      },
 					      {
 					       name => 'ipRouteAge',
 					      },  
					      {
 					       name => 'ipRouteMask',
 					      },  
					      {
 					       name => 'ipRouteMetric1',
 					      },  
					      {
 					       name => 'ipRouteMetric2',
 					      },  
					      {
 					       name => 'ipRouteMetric3',
 					      },  
					      {
 					       name => 'ipRouteIfIndex',
 					      },  
					      {
 					       name => 'ipRouteType',
 					       munger=> \&munge_ipRouteType
					       },  
					      {
 					       name => 'ipRouteProto',
 					       munger=> \&munge_ipRouteProto
 					      },  
					      {
 					       name => 'ipRouteType',
 					      },  
					      {
 					       name => 'ipRouteNextHop',
 					      },  
					      {
 					       name => 'ipRouteInfo',
 					      }
					     ]
				 }
		      );

__PACKAGE__->add_table('ipAddrTable',{
				  index   => {
					      name => 'ipAdEntAddr',
					      #munger => \&test,
					   },
				  columns => [
					      {
 					       name  => 'ipAdEntIfIndex',
 					       #munger=> \&
 					      },
 					      {
 					       name => 'ipAdEntNetMask',
 					      },  
					      {
 					       name => 'ipAdEntBcastAddr',
 					      },  
					      {
 					       name => 'ipAdEntReasmMaxSize',
 					      },
					     ]
				 }
		      );

__PACKAGE__->add_table('tcpConnTable',{
				  index   => {
					      name => 'tcpConnLocalAddress,tcpConnLocalPort,tcpConnRemAddress,tcpConnRemPor',
					     },
				  columns => [
					      {
 					       name  => 'tcpConnState',
 					       munger=> \&munge_tcpConnState
 					      },
 					      {
 					       name => 'tcpConnLocalAddress',
 					      },  
					      {
 					       name => 'tcpConnLocalPort',
 					      },  
					      {
 					       name => 'tcpConnRemAddress',
 					      },
					      {
 					       name => 'tcpConnRemPort',
 					      },
					     ]
				 }
		      );


__PACKAGE__->add_table('udpTable',{
				  index   => {
					      name => 'udpLocalAddress, udpLocalPort',
					     },
				  columns => [
					      {
 					       name  => 'udpLocalAddress',
 					      },
 					      {
 					       name => 'udpLocalPort',
 					      }
					     ]
				 }
		      );


1;





sub munge_ifspeed {
    my $speed = shift;
    my $map   = $SPEED_MAP{$speed};

    #print "  $speed -> $map  " if (defined $map);
    return $map || $speed;
}

sub munge_iftype {
    my $value = shift;

    return $IF_TYPES[$value];
}

sub munge_ifstatus {
    my $value = shift;

    return $IF_STATUS[$value];
}

sub munge_tcpRtoAlgorithm {

    my $value = shift;

    return $RTO_ALGO[$value];
}


sub munge_ipRouteType {

    my $value = shift;

    return $ROUTE_TYPE[$value];
}

sub munge_ipRouteProto {

    my $value = shift;

    return $IP_PROTO[$value];
}

sub munge_tcpConnState {

    my $value = shift;

    return $CONN_STATE[$value];
}
