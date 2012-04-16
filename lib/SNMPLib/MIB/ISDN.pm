package SNMPLib::MIB::ISDN;

use strict;
use warnings;

use base qw(SNMPLib::MIB);



my @IF_OP_STATUS = qw (
		   nop idle connecting
		   connected active
		   );


my @ORIGIN = qw (
		   nop unknown originate answer callback
		   );

my @INFO = qw (
		   nop unknown speech unrestrictedDigital unrestrictedDigital56
	           restrictedDigital audio31 audio7 video packetSwitched
		   ); 


my @CH_TYPE = qw (
		   nop dialup leased
		   );


__PACKAGE__->set_MIB('ISDN-MIB');




__PACKAGE__->add_table('isdnBearerTable',{
				  index   => {
					      name => 'ifIndex',
					      #munger => \&,
					   },
				  columns => [
					      {
						  name => 'isdnBearerChannelType',
						  munger => \&munge_ch,

						  
 					      },  
					      {
						  name => 'isdnBearerOperStatus',
						  munger => \&munge_operstatus,

 					      },  
					      {
						  name => 'isdnBearerChannelNumber',
 					      },  
					      {
						  name => 'isdnBearerPeerAddress',
 					      },  
					      {
						  name => 'isdnBearerPeerSubAddress',
 					      },  
					      {
						  name => 'isdnBearerCallOrigin',
						  munger => \&munge_origin,

 					      },  
					      {
						  name => 'isdnBearerInfoType',
						  munger => \&munge_info,

 					      },  
					      {
						  name => 'isdnBearerMultirate',
 					      },  
					      {
						  name => 'isdnBearerCallSetupTime',
 					      },  
					      {
						  name => 'isdnBearerCallConnectTime',
 					      },  
					      {
						  name => 'isdnBearerChargedUnits',
 					      },
					      ]
				 }
		      );


   


sub munge_operstatus {

    my $value = shift;

    return $IF_OP_STATUS[$value];
}

sub munge_origin {

    my $value = shift;

    return $ORIGIN[$value];
}

sub munge_info {

    my $value = shift;

    return $INFO[$value];
}

sub munge_ch {

    my $value = shift;

    return $CH_TYPE[$value];
}
