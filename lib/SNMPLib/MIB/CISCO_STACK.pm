package SNMPLib::MIB::CISCO_STACK;

use strict;
use warnings;

use base qw(SNMPLib::MIB);
use Data::Dumper;
my @PORT_DUPLEX = qw( nop half full disagree auto );


__PACKAGE__->set_MIB('CISCO-STACK-MIB');


__PACKAGE__->add_table('portTable',{
				  index   => {
					      name => 'portModuleIndex,portIndex',
					      #munger => \&test,
					   },
				  columns => [
					      {
						  name => 'portDuplex',
					          munger => \&munge_portDuplex,
 					      },  
					      {
						  name => 'portIfIndex',
 					      },  
					      {
						  name => 'portIndex',
 					      },  
					      {
						  name => 'portName',
					      },    
					      {
						  name => 'portType',
					      },  
					      {
					       name => 'portAdminSpeed',
					      },
					      
					      ]
				 }
		      );

__PACKAGE__->add_table('portCpbTable',{
				  index   => {
					      name => 'portCpbModuleIndex,portCpbPortIndex',
					      #munger => \&test,
					   },
				  columns => [
					      {
						  name => 'portCpbDuplex',
					          munger => \&SNMPLib::MIB::munge_bits,
 					      },  
					      {
						  name => 'portCpbSpeed',
 					      },  
					      {
						  name => 'portCpbTrunkMode',
 					      },  
					      {
						  name => 'portCpbPortfast',
					      },
					      ]
				 }
		      );

  sub munge_portDuplex {
    my $value = shift;
    return $PORT_DUPLEX[$value];
 }


__PACKAGE__->add_function('i_duplex',\&i_duplex);
__PACKAGE__->add_function('i_duplex_admin',\&i_duplex_admin);


sub i_duplex {
    my $self   = shift;
    
    my $el_duplex = $self->dot3StatsTable;
    my $i_duplex = {};

    if(defined($el_duplex)){
      foreach my $el_port ( keys %$el_duplex ) {
	my $duplex = $el_duplex->{$el_port}->{'dot3StatsDuplexStatus'};
	next unless defined $duplex;
	
	$i_duplex->{$el_port} = 'half' if $duplex =~ /half/i;
	$i_duplex->{$el_port} = 'full' if $duplex =~ /full/i;
      }
    }
    else{
    
      my $p_table = $self->portTable('portDuplex','portIfIndex');
      my $p_duplex_cap = $self->portCpbTable('portCpbDuplex') || {};   #portCpbTable
      
      foreach my $port ( keys %$p_table ) {
	my $iid = $p_table->{$port}->{'portIfIndex'};
	next unless defined $iid;
	#next if ( defined $partial and $iid !~ /^$partial$/ );
	
	# Test for gigabit
	if ( $p_duplex_cap->{$port}->{'portCpbDuplex'} eq 0 ) {
	  $i_duplex->{$iid} = 'full';
	}
	
	# Auto is not a valid operational state
 	elsif ( $p_table->{$port}->{'portDuplex'} eq 'auto' ) {
          next;
	}
	else {
	  $i_duplex->{$iid} = $p_table->{$port}->{'portDuplex'};
	}
      }
    }
    return $i_duplex;
  }


sub i_duplex_admin {
    my $self   = shift;

    my $el_duplex = $self->dot3StatsTable;
    my $i_duplex_admin = {};
    my $p_table = $self->portTable('portDuplex','portIfIndex','portAdminSpeed') || {};

    return unless(defined($p_table));

    # Newer software
    if ( defined $el_duplex and scalar( keys %$el_duplex ) ) {
        #my $p_port   = $self->p_port()   || {};
        #my $p_duplex = $self->p_duplex() || {};

        foreach my $port ( keys %$p_table ) {
            my $iid = $p_table->{$port}->{'portIfIndex'};
            next unless defined $iid;

            $i_duplex_admin->{$iid} = $p_table->{$port}->{'portDuplex'};
        }
    }

    # Fall back to CiscoStack method
    else {
      my $p_duplex_cap = $self->portCpbTable('portCpbDuplex') || {};   #portCpbTable

      foreach my $port ( keys %$p_table ) {
	my $iid = $p_table->{$port}->{'portIfIndex'};
	next unless defined $iid;
	#next if ( defined $partial and $iid !~ /^$partial$/ );
	
	# Test for gigabit
	if ( $p_duplex_cap->{$port}->{'portCpbDuplex'} eq 0 ) {
	  $i_duplex_admin->{$iid} = 'full';
	}
	
	# Auto is not a valid operational state
 	elsif ( $p_table->{$port}->{'portAdminSpeed'} =~ /auto/ ) {
	  $i_duplex_admin->{$iid} = 'auto';
	}
	else {
	  $i_duplex_admin->{$iid} = $p_table->{$port}->{'portDuplex'};
	}
      }
    }
    return $i_duplex_admin;
  }
