package SNMPLib::MIB::CISCO_CDP;

use strict;
use warnings;

use base qw(SNMPLib::MIB);
use Data::Dumper;

my @OPER_STATUS = qw (
		   nop up down testing dormant notPresent lowerLayerDown
		   );

my @ADDR_TYPE = qw (
		   nop other volatile nonVolatile
		   );


__PACKAGE__->set_MIB('CISCO-CDP-MIB');


 __PACKAGE__->add_scalar('cdpGlobalRun');
 __PACKAGE__->add_scalar('cdpGlobalMessageInterval');
 __PACKAGE__->add_scalar('cdpGlobalHoldTime');
 __PACKAGE__->add_scalar('cdpGlobalDeviceId');
# __PACKAGE__->add_scalar('');
# __PACKAGE__->add_scalar('');
# __PACKAGE__->add_scalar('');
# __PACKAGE__->add_scalar('');
# __PACKAGE__->add_scalar('');
# __PACKAGE__->add_scalar('');
# __PACKAGE__->add_scalar('');
# __PACKAGE__->add_scalar('');
# __PACKAGE__->add_scalar('');
# __PACKAGE__->add_scalar('');
# __PACKAGE__->add_scalar('');
# __PACKAGE__->add_scalar('');
# __PACKAGE__->add_scalar('');
# __PACKAGE__->add_scalar('');
# __PACKAGE__->add_scalar('');


__PACKAGE__->add_table('cdpCacheTable', {
				  index => {
				      name => 'cdpCacheIfIndex',
				      munger => \&munge_cdpCacheIfIndex,
					   },
				  columns => [
					      {
						  name  => 'cdpCacheAddressType',
 					      },
 					      {
						  name => 'cdpCacheAddress',
						  munger => \&munge_null,
 					      },
					      {
						  name => 'cdpCacheVersion',
						  munger => \&munge_null,
 					      },
					      {
						  name => 'cdpCacheDeviceId',
						  munger => \&munge_null,
					      },
					      {
						  name => 'cdpCacheDevicePort',
						  munger => \&munge_null,
					      },
					      {
						  name => 'cdpCachePlatform',
						  munger => \&munge_null,
					      },
					      {
						  name => 'cdpCacheCapabilities',
						  munger => \&SNMPLib::MIB::munge_caps,
					      },
					      {
						  name => 'cdpCacheVTPMgmtDomain',
						  munger => \&munge_null,
					      },
					      {
						  name => 'cdpCacheNativeVLAN',
					      },
					      {
						  name => 'cdpCacheDuplex',
					      },
					      {
						  name => 'cdpCachePowerConsumption',
						  munger => \&munge_power,
					      },
					      ]
				 }
		      );

  __PACKAGE__->add_function('cdpIpList',\&c_ip);
  __PACKAGE__->add_function('cdpCacheIfIndex',\&cdpCacheIfIndex);
  __PACKAGE__->add_function('get_neighbors',\&get_neighbors);


   sub c_ip {
     my $self = shift;
        
      my $c_addr  = $self->cdpCacheTable('cdpCacheAddress') || {};
      my $c_proto = $self->cdpCacheTable('cdpCacheAddressType') || {};

       my %c_ip;

      foreach my $key ( keys %$c_addr ) {
         my $addr  = $c_addr->{$key}->{'cdpCacheAddress'};
         my $proto = $c_proto->{$key}->{'cdpCacheAddressType'};
         next unless defined $addr;
         #WARN: modificare in caso di munger
         next if ( defined $proto and $proto ne (1 or 'ip') );
         #$addr =~ s/^0x//;
         my $ip = SNMPLib::MIB::munge_ip($addr);#join( '.', unpack( 'C4', $addr ) );
	 $c_ip{$key} = $ip;
       }
   	return \%c_ip;
 
   }

   sub munge_cdpCacheIfIndex{
     my $index = shift;
     $index =~ s/\.\d+$//;
     return $index;
   }

   sub cdpCacheIfIndex{
     my $self=shift or die "Invocation error";
     my $index_name = $self->index_cdpCacheTable;
     my $result = {};

     my $t = $self->cdpCacheTable('cdpCacheAddress');
     foreach my $k (keys (%$t)){
       $result->{$k} = $t->{$k}->{$index_name}
     }

     return $result;
   }

 sub munge_power {
     my $power = shift;
     my $decimal = substr( $power, -3 );
     $power =~ s/$decimal$/\.$decimal/;
     return $power;
 }



 sub munge_null {
     my $text = shift || return;

     $text =~ s/\0//g;
     return $text;
 }


 sub munge_ifOperStatus {
     my $value = shift;

     return $OPER_STATUS[$value];
 }

 sub munge_ifRcvAddressType {
     my $value = shift;

     return $ADDR_TYPE[$value];
 }

#------------------------------------------------------------------------------------------#

sub get_neighbors {
    my $self = shift;

    #my $logger = $self->{manoc_logger};
    my $host   = $self->{host};

    my %res;

    my $interfaces      = $self->interfaces();
    my $c_if            = $self->cdpCacheIfIndex;
    my $c_ip            = $self->cdpIpList();
    my $c_port          = $self->cdpCacheTable('cdpCacheDevicePort');
    my $c_capabilities  = $self->cdpCacheTable('cdpCacheCapabilities');

    foreach my $neigh (keys %$c_if) {
	my $port  = $interfaces->{$c_if->{$neigh}}->{'ifDescr'};
	
	my $neigh_ip     = $c_ip->{$neigh}   || "no-ip";
	
	my $neigh_port = '';
	defined($c_port->{$neigh}) and $neigh_port = $c_port->{$neigh}->{'cdpCacheDevicePort'};

	my $cap = $c_capabilities->{$neigh};
	#$logger && $logger->debug("$host/$port connected to $neigh_ip ($cap)");
	$cap and $cap = pack('B*', $cap);
	if($neigh_port and $neigh_ip and $cap){
	    my $entry = {
		port		=> $neigh_port,
		addr		=> $neigh_ip,
		bridge		=> vec($cap, 2, 1),
		switch		=> vec($cap, 4, 1),
	    };
	    push(@{$res{$port}}, $entry) if defined($port);
	}
    }
    return \%res;
}

#------------------------------------------------------------------------------------------#
