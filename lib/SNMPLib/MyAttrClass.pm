package SNMPLib::MyAttrClass;

use strict;
use warnings;

use base 'Class::MOP::Attribute';

SNMPLib::MyAttrClass->meta->add_attribute('scalar'  => (reader   => 'is_scalar'));
SNMPLib::MyAttrClass->meta->add_attribute('table'   => (reader   => 'is_table'));
SNMPLib::MyAttrClass->meta->add_attribute('index'   => (accessor => 'index'));
SNMPLib::MyAttrClass->meta->add_attribute('funcs'   => (reader   => 'is_funcs'));

#MyAttrClass->meta->add_attribute('columns' => ( default  => sub { {} },
#						accessor => 'columns')
#				 );

#MyAttrClass->meta->add_attribute('munger'  => (accessor => 'munger'));
#MyAttrClass->meta->add_attribute('alias'  => (accessor => 'alias'));



1;

