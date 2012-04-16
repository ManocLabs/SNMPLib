package SNMPLib::MIB::IP;

use strict;
use warnings;

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



__PACKAGE__->set_MIB('IP-MIB');




__PACKAGE__->add_table('ipNetToMediaTable',{
				  index   => {
					      name => 'ipNetToMediaIfIndex',
					      #munger => \&test,
					   },
				  columns => [
					      {
						  name => 'ipNetToMediaPhysAddress',
						  munger => \&SNMPLib::MIB::munge_mac,
						  
 					      },  
					      {
						  name => 'ipNetToMediaNetAddress',
 					      },  
					      {
						  name => 'ipNetToMediaType',
 					      },
					      ]
				 }
		      );



 
#  sub munge_FdbTableIndex{
#      my $idx = shift;
#      my @values = split( /\./, $idx );
#      my $fdb_id = shift(@values);
#      return ( $fdb_id.' '.join( ':', map { sprintf "%02x", $_ } @values ) );
#  }


