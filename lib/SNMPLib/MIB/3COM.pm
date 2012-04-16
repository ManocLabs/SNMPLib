package SNMPLib::MIB::3COM;

use strict;
use warnings;

use base qw(SNMPLib::MIB);

__PACKAGE__->set_MIB('3COM-MIB');

__PACKAGE__->add_scalar('securityUserTable');

1;
