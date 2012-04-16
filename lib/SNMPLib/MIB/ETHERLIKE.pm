package SNMPLib::MIB::ETHERLIKE;

use strict;
use warnings;

use base qw(SNMPLib::MIB);
use Data::Dumper;
my @PORT_DUPLEX = qw( nop unknown halfDuplex fullDuplex );


__PACKAGE__->set_MIB('ETHERLIKE-MIB');




__PACKAGE__->add_table('dot3StatsTable',{
				  index   => {
					      name => 'dot3StatsIndex',
					      #munger => \&test,
					   },
				  columns => [
					      {
						  name => 'dot3StatsDuplexStatus',
					          munger => \&munge_portDuplex,
 					      }, 
					      ]
				 }
		      );

  sub munge_portDuplex {
    my $value = shift;
    return $PORT_DUPLEX[$value];
 }
