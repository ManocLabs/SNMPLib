package SNMPLib::Device::CiscoRouter;


use strict;
use warnings;

use base qw(SNMPLib::Device);


my @MIB_list = (  'RFC1213' ,'BRIDGE' , 'CISCO_VTP', 'CISCO_CDP', 'IP', 'CISCO_STACK',
	         'CISCO_PORT_SECURITY', 'CISCO_VLAN_MEMB' , 'IF_TABLE_REL' , 'CISCO_VTP','ETHERLIKE' );



__PACKAGE__->set_dev('CiscoRouter');
__PACKAGE__->add_MIB_list(\@MIB_list );

__PACKAGE__->set_session_method('os', sub{return 'ios';});
__PACKAGE__->set_session_method('os_ver',\&os_ver);
__PACKAGE__->set_session_method('vendor', sub{return 'Cisco';});
__PACKAGE__->set_session_method('model', sub{return 'Cisco Router';});

__PACKAGE__->set_session_method('class_name', sub{return 'Device::CiscoRouter';} );
__PACKAGE__->set_session_method('cisco_comm_indexing', sub{return 0;} );




sub os_ver {
    my $self    = shift;
    my $descr = $self->sysDescr();
    
      # Newer Catalysts and IOS devices
    if ( defined $descr
	 and $descr =~ m/Version (\d+\.\d+\([^)]+\)[^,\s]*)(,|\s)+/ )
      {
	return $1;
      }
    return;
  }


sub has_cd11 {
    return 0;
}

sub has_wcs {
    return 0;
}
