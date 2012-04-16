package SNMPLib::Device::Generic;

use strict;
use warnings;

use base qw(SNMPLib::Device);

my @MIB_list = ( 'RFC1213' , 'BRIDGE', 'CISCO_CDP','IF_TABLE_REL', 'IP' , 'CISCO_VTP' );

__PACKAGE__->set_dev('Generic');
__PACKAGE__->add_MIB_list(\@MIB_list );

__PACKAGE__->set_session_method('class_name', sub{return 'Device::Generic';} );
__PACKAGE__->set_session_method('cisco_comm_indexing', sub{return 0;} );
__PACKAGE__->set_session_method('model', sub{'Generic';} );
__PACKAGE__->set_session_method('os', sub{ return 'Unknown';} );
__PACKAGE__->set_session_method('os_ver', sub{ return 'Unknown';} );
__PACKAGE__->set_session_method('vendor', sub{ return 'Unknown';} );



1;



