package SNMPLib::MIB::CISCO_CDP;

use strict;
use warnings;

use base qw(SNMPLib::MIB);

my @OPER_STATUS = qw (
		   nop up down testing dormant notPresent lowerLayerDown
		   );

my @ADDR_TYPE = qw (
		   nop other volatile nonVolatile
		   );

my @DUPLEX_TYPE = qw (
		   nop unknown halfduplex fullduplex
		   );

__PACKAGE__->set_MIB('CISCO-CDP-MIB');

 __PACKAGE__->add_scalar('cdpGlobalRun');
 __PACKAGE__->add_scalar('cdpGlobalMessageInterval');
 __PACKAGE__->add_scalar('cdpGlobalHoldTime');
 __PACKAGE__->add_scalar('cdpGlobalDeviceId');
 __PACKAGE__->add_scalar('cdpGlobalLastChange');
 __PACKAGE__->add_scalar('cdpGlobalDeviceIdFormatCpb');
 __PACKAGE__->add_scalar('cdpGlobalDeviceIdFormat');

__PACKAGE__->add_table('cdpInterfaceTable',{
				  index => {
				      name => 'cdpInterfaceIfIndex',
				      munger => undef,
					   },
				  columns => [
					      {
						  name  => 'cdpInterfaceEnable',
 					      },
 					      {
						  name => 'cdpInterfaceMessageInterval',
 					      },
					      {
						  name => 'cdpInterfaceGroup',
 					      },
					      {
						  name => 'cdpInterfacePort',
					      },
					      ]
				 }
		      );

__PACKAGE__->add_table('cdpInterfaceExtTable',{
				  index => {
				      name => 'ifIndex',
				      munger => undef,
					   },
				  columns => [
					      {
						  name  => 'cdpInterfaceExtendedTrust',
 					      },
 					      {
						  name => 'cdpInterfaceCosForUntrustedPort',
 					      },
					      ]
					      }
		      );

__PACKAGE__->add_table('cdpCacheTable',{
				  index => {
				      name => 'cdpCacheIfIndex, cdpCacheDeviceIndex',
				      munger => undef,
					   },
				  columns => [
					      {
						  name  => 'cdpCacheIfIndex',
						  #munger=> \&
 					      },
 					      {
						  name => 'cdpCacheDeviceIndex',
 					      },
					      {
						  name => 'cdpCacheAddressType',
 					      },
					      {
						  name => 'cdpCacheAddress',
					      },
					      {
						  name => 'cdpCacheVersion',
					      },
					      {
						  name => 'cdpCacheDeviceId',
					      },
					      {
						  name => 'cdpCacheDevicePort',
 					      },
					      {
						  name => 'cdpCachePlatform',
					      },
					      {
						  name => 'cdpCacheCapabilities',
					      },
					      {
						  name => 'cdpCacheVTPMgmtDomain',
					      },
					      {
						  name => 'cdpCacheNativeVLAN',
 					      },
					      {
						  name => 'cdpCacheDuplex',
						  munger=> \&munge_cdpCacheDuplex
					      },
					      {
						  name => 'cdpCacheApplianceID',
					      },
					      {
						  name => 'cdpCacheVlanID',
					      },
					      {
						  name => 'cdpCachePowerConsumption',
 					      },
					      {
						  name => 'cdpCacheMTU',
					      },
					      {
						  name => 'cdpCacheSysName',
					      },
					      {
						  name => 'cdpCacheSysObjectID',
					      },
					      {
						  name => 'cdpCachePrimaryMgmtAddrType',
 					      },
					      {
						  name => 'cdpCachePrimaryMgmtAddr',
					      },
					      {
						  name => 'cdpCacheSecondaryMgmtAddrType',
					      },
					      {
						  name => 'cdpCacheSecondaryMgmtAddr',
					      },
					      {
						  name => 'cdpCachePhysLocation',
 					      },
					      {
						  name => 'cdpCacheLastChange',
					      },
					      ]
				 }
		      );




sub munge_ifRcvAddressType {
    my $value = shift;

    return $ADDR_TYPE[$value];
}

sub munge_cdpCacheDuplex {
    my $value = shift;

    return $DUPLEX_TYPE[$value];
}

# sub munge_index_ifStackTable{
#     my $value = shift;

#     return $OPER_STATUS[$value];
# }

