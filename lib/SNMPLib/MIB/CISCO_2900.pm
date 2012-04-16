package SNMPLib::MIB::CISCO_2900;

use strict;
use warnings;
use Data::Dumper;

use base qw(SNMPLib::MIB);

my @PORT_DUP_STATUS = qw (
		   nop fullduplex halfduplex
		   );

my @PORT_DUP_STATE = qw (
		   nop fullduplex halfduplex auto
		   );

my @PORT_STATUS = qw (
		   nop other disabled blocking listening learning
		   preforwarding forwarding secureforwarding suspended
		   broken
		   );



__PACKAGE__->set_MIB('CISCO-C2900-MIB');


__PACKAGE__->add_function('i_duplex',\&i_duplex);
__PACKAGE__->add_function('i_duplex_admin',\&i_duplex_admin);


__PACKAGE__->add_table('c2900PortTable',{
				  index   => {
					      name => 'c2900PortModuleIndex, c2900PortIndex',
					      #munger => \&test,
					   },
				  columns => [
					      {
						  name => 'c2900PortDuplexStatus',
						  munger => \&munge_DuplexStatus,
					      },  
					      {
						  name => 'c2900PortDuplexState',
						  munger => \&munge_DuplexState,

 					      },  
					      {
						  name => 'c2900PortAdminSpeed',
 					      },  
					      {
						  name => 'c2900PortStatus',
						  munger => \&munge_PortStatus,
 					      },  
					      {
						  name => 'c2900PortSwitchPortIndex',
 					      },  
					      {
						  name => 'c2900PortIfIndex',
 					      },
					      ]
				 }
		      );


sub munge_DuplexStatus{
  my $value = shift;

  return $PORT_DUP_STATUS[$value];
}

sub munge_DuplexState{
  my $value = shift;
  return $PORT_DUP_STATE[$value];
}

sub munge_PortStatus{
  my $value = shift;

  return $PORT_STATUS[$value];
}


sub i_duplex {
    my $self   = shift;

    my $interfaces     = $self->interfaces();
    my $portIfIndex    = $self->c2900PortTable('c2900PortIfIndex') || {};
    my $c2900_p_duplex = $self->c2900PortTable('c2900PortDuplexStatus');


    my %c2900_p_index =  map {$_ => $portIfIndex->{$_}->{'c2900PortIfIndex'}} keys(%$portIfIndex);
    my %reverse_2900 = reverse %c2900_p_index;

     my %i_duplex;
     foreach my $if ( keys %$interfaces ) {
         my $port_2900 = $reverse_2900{$if};
         next unless defined $port_2900;
         my $duplex = $c2900_p_duplex->{$port_2900}->{'c2900PortDuplexStatus'};
         next unless defined $duplex;

         $duplex = 'half' if $duplex =~ /half/i;
         $duplex = 'full' if $duplex =~ /full/i;
         $i_duplex{$if} = $duplex;
     }
     return \%i_duplex;
}


sub i_duplex_admin {
    my $self   = shift;

    my $interfaces    = $self->interfaces();
    my $portIfIndex = $self->c2900PortTable('c2900PortIfIndex') || {};
    my $c2900_p_admin = $self->c2900PortTable('c2900PortDuplexState');



    my %c2900_p_index =  map {$_ => $portIfIndex->{$_}->{'c2900PortIfIndex'}} keys(%$portIfIndex);
    my %reverse_2900 = reverse %c2900_p_index;

    my %i_duplex_admin;
    foreach my $if ( keys %$interfaces ) {
        my $port_2900 = $reverse_2900{$if};
        next unless defined $port_2900;
        my $duplex = $c2900_p_admin->{$port_2900}->{'c2900PortDuplexState'};
        next unless defined $duplex;

        $duplex = 'half' if $duplex =~ /half/i;
        $duplex = 'full' if $duplex =~ /full/i;
        $duplex = 'auto' if $duplex =~ /auto/i;
        $i_duplex_admin{$if} = $duplex;
    }
    return \%i_duplex_admin;
}

1;
