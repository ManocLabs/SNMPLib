package SNMPLib::Device::Catalyst;

use strict;
use warnings;

use base qw(SNMPLib::Device);


#my $ref = MIB::RFC1213->new();
#$ref->set_munger('ifTable','ifDescr',\&test);

my @MIB_list = (  'RFC1213' ,'BRIDGE' , 'CISCO_VTP', 'CISCO_CDP', 'IP', 'CISCO_STACK',
	         'CISCO_PORT_SECURITY', 'CISCO_VLAN_MEMB' , 'IF_TABLE_REL' , 'CISCO_VTP','ETHERLIKE' );#$ref);

__PACKAGE__->set_dev('Catalyst');
 SNMPLib::Session->load_MIB('CISCO-PRODUCTS-MIB');
__PACKAGE__->add_MIB_list(\@MIB_list );


#__PACKAGE__->set_session_method();

__PACKAGE__->set_session_method('os',\&os);
__PACKAGE__->set_session_method('os_ver',\&os_ver);
__PACKAGE__->set_session_method('vendor', sub{return 'Cisco';});
__PACKAGE__->set_session_method('model',\&model);

__PACKAGE__->set_session_method('class_name', sub{return 'Device::Catalyst';} );
__PACKAGE__->set_session_method('cisco_comm_indexing', sub{return 1;} );


sub model {
    my $self = shift;
    my $id = $self->sysObjectID();

    unless ( defined $id ) {
	return;
    }

    my $model = $self->translate($id);

    return $id unless defined $model;

    $model =~ s/^cisco//i;
    $model =~ s/^catalyst//;
    $model =~ s/^cat//;
    return $model;
}


sub os {
    my $self = shift;
    my $descr = $self->sysDescr() || '';

    # order here matters - there are Catalysts that run IOS and have catalyst
    # in their description field.
    return 'ios'      if ( $descr =~ /IOS/ );
    return 'catalyst' if ( $descr =~ /catalyst/i );
    return;
}

sub os_ver {
    my $self    = shift;
    my $os    = $self->os();
    my $descr = $self->sysDescr();
    
    # Older Catalysts
    if (    defined $os
	    and $os eq 'catalyst'
	    and defined $descr
	    and $descr =~ m/V(\d{1}\.\d{2}\.\d{2})/ )
    {
        return $1;
    }
    
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





1;



