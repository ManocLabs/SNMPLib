package SNMPLib::MIB;

use warnings;
use strict;
use Carp;
use Data::Dumper; 


use metaclass (
	       'attribute_metaclass' => 'SNMPLib::MyAttrClass',
	       );

__PACKAGE__->meta->add_attribute( 'MIB_name' => 
			       ( accessor  => 'MIB_name',
				 ));

sub Method (&) { return  $_[0];}

my $Debug; 
my $Logger;


=head1 NAME



=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use SNMPLib;

    my $foo = SNMPLib->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 FUNCTIONS

=head2 new 

=cut
  
    sub new {
	my $class = shift or croak "Error: Bad Invocation!";
	
	$Debug  = SNMPLib::debug_mode();
	$Logger = SNMPLib::Logger::get_default_instance();
	return $class->meta->new_object;
    }



=head2 

=cut
    #crea la subroutine utilizzata per implementare la funzione 
    #di Singleton
    sub _create_default_instance_sub {
	my $class    = shift or croak "Invocation error";
	my $instance;
	
	return Method {
	    my $self     = shift or croak "Error: Bad Invocation ";
	    
	    $instance = $self->new() unless($instance);
	    return $instance;
	}; 
    }

=head2 set_MIB

Questa funzione deve essere invocata da ogni sottoclasse di MIB.
Serve per poter settare il nome "reale" del MIB, in modo tale che Net::SNMP
riesca a caricare il file corretto per poter fornire il servizio di traduzione
tra oid testuali e numerici.
    es. la classe MIB::RFC1213 dovrà invocare la subroutine passando come 
    parametro: 'RFC1213-MIB', ovvero il nome del file MIB RFC1213-MIB.txt 
N.B. inizialmente MIB_name è un attributo della classe MIB. dopo questa chiamata
diventa un attributo della classe MIB::XXX in modo che ogni istanza di questo tipo
 di classe ha un attributo MIB_name tutto suo

=cut

    sub set_MIB {
	my $class = shift or croak "Error: Bad Invocation!";
	my $name  = shift or croak "You must pass the MIB name!";
	
	my $attr = $class->meta->find_attribute_by_name('MIB_name');
	$class->meta->add_attribute($attr->clone( default => $name ));
	
	$class->meta->add_method('default_instance' =>
				 $class->_create_default_instance_sub );
    }

=head2 add_scalar

Definisce uno scalare in una sottoclasse di MIB.
es. __PACKAGE__->add_scalar('sysDescr',\&munger_sysDescr,'alias')
N.B. il secondo e terzo argomento sono opzionali

=cut
    
    sub add_scalar {
      my $class  = shift or croak "Error: Bad Invocation!";
      my $leaf   = shift or croak "You must pass at least the name of the scalar!";
      my $munger = shift;
      my $alias  = shift;	
      
      $class->meta->add_attribute( $leaf => ( scalar   => 1,
					      default  => 
					      sub {{munger => $munger,
						      alias  => $alias}},
					      accessor => $leaf.'_opt',
					    )
				 );  
    }
    


=head2 add_function

Definisce una subroutine da aggiungere

=cut
    
    sub add_function {
      my $class  = shift or croak "Error: Bad Invocation!";
      my $leaf   = shift or croak "You must pass at least the name of the funcs!";
      my $ref    = shift or croak "You must pass a reference";
      
   
      $class->meta->add_attribute( $leaf => ( funcs    => 1,
					      default  => sub{$ref},
					      accessor => $leaf.'_opt',
					    )
				 );  
    }
    

=head2 set_munger

Subroutine per settare i munger degli oid sia scalari che tabellari una
volta istanziata la classe MIB::XXX della quale si vuole cambiare il munger di 
default di un attributo

=cut

    sub set_munger {
	my $class  = shift or croak "Error: Bad Invocation!";
	my $name   = shift or croak "You must pass the name of the munger!";
	my $val    = shift or croak "You must pass the value of the munger!";
	my $val2   = shift;
	my $sub_name     = $name.'_opt';
	my $opt          = $class->$sub_name();

	if( !defined($val2) ){
	    #scalar attribute
	    $opt->{'munger'} = $val;
	    $Debug and $Logger->debug("Munger $name correctly setted");
	}
	else {
	  #table attribute
	  $opt->{$val} = $val2;
	}
	$class->$sub_name($opt);
      }

=head2 set_alias
TODO: decidere se può essere utile o meno

=cut

    sub set_alias {
	my $class  = shift or croak "Error: Bad Invocation!";
	my $name   = shift or croak "You must pass the name of the attribute!";
	my $val    = shift or croak "You must pass the value of the alias!";
	
	my $sub_name     = $name.'_opt';
	my $opt          = $class->$sub_name();
	$opt->{'alias'} = $val;
	$class->$sub_name($opt);
    }



=head2 add_table

Subroutine utilizzata per definire una tabella di un MIB. 
es. __PACKAGE__->add_table('tableName',{
				  index   => {
					      name => 'indexName',
					      munger => \&munger_indexName
					   },
				  columns => [
					      {
 					       name  => 'column1Name',
 					       munger=> \&munger_column1Name
 					      },
					      .
					      .
					      .
					      ]
				 }
		      );
N.B. gli attributi munger sono opzionali

=cut

    sub add_table {
	my $class   = shift or croak "Error: Bad Invocation!";
	my $leaf    = shift or croak "You must pass  the name of the table!";
	my $col_ref = shift or croak "Columns missing!";
	
	my @columns = @{$col_ref->{'columns'}};
	#TODO: nel caso di aggiunta di alias alle colonne modificare qui 
 	my %default = map { $_->{'name'} => $_->{'munger'} } @columns;
	my $index   = $col_ref->{'index'};
	$default{$index->{'name'}}  = $index->{'munger'} if($index->{'munger'});

	$class->meta->add_attribute($leaf => ( table    => 1,
 					       default  => sub {\%default},
 					       accessor => $leaf.'_opt',
					       index    => $index->{'name'},
 					       )  );
    }

=head2 add_trait

Subroutine chiamata dalla classe Device per aggiungere un particolare trait 
(definito nella classe SNMPLib::MIB:XXX) alla classe Session corrispondente.

=cut
    
    sub add_trait {
      my $class    = shift or croak "Error: Bad Invocation!";
      my $session  = shift or croak "Error: Must provide a valid session class!";
      
      foreach my $attr ( $class->meta->get_all_attributes ){
	next if($attr->name eq 'MIB_name');
	
	if( $attr->is_scalar ){
	  my $opt_acc   = $attr->name.'_opt';
	  my $opt       = $class->$opt_acc;
	  my $alias     = $opt->{'alias'};
	  my $meth_name = $alias || $attr->name;
	  
	  $session->meta->add_method($meth_name => 
				     $class->_create_scalar_sub($attr->name) );
	}
	elsif ( $attr->is_table ){
	  $session->meta->add_method($attr->name => 
				     $class->_create_table_sub($attr->name,$attr->index) );
	    $session->meta->add_method( 'index_'.$attr->name => sub{return $attr->index} );
	  
	}
	elsif ( $attr->is_funcs ) {
	  my $opt_acc   = $attr->name.'_opt';
	  my $ref = $class->$opt_acc;
	  $session->meta->add_method( $attr->name => $ref );
	}
    }
}
    

=head2 _create_scalar_sub

=cut
    #crea la subroutine che verrà aggiunta alla classe Session_XXX
    sub _create_scalar_sub {
	my $mib_class    = shift or croak "Invocation error";
	my $name         = shift or croak "Error: !";
	my $opt_acc      = $name.'_opt';
	my $opt          = $mib_class->$opt_acc;
	my $munger       = $opt->{'munger'};


	return Method {
	    my $self     = shift or croak "Error: Bad Invocation ";
	   
	    my $result = $self->_get_scalar($name);
	    return defined($munger) ? $munger->($result) :
		$result;
	}; 
    }

=head2 _create_table_sub

=cut
    #crea la subroutine che verrà aggiunta alla classe Session_XXX
    sub _create_table_sub {
	my $mib_class    = shift or croak "Invocation error";
	my $name         = shift or croak "Error: missing table name!";
	my $index        = shift or croak "Error: missing index table name!";
	
	my $opt_acc      = $name.'_opt';
	my $columns      = $mib_class->$opt_acc;

	return Method {
	  my $self     = shift or croak "Error: Bad Invocation ";
	  my @spec_clms  = @_;
	  my %ref_clms = %$columns;

	  scalar(@spec_clms) and 
	    %ref_clms =  map { $_  => $columns->{$_} } @spec_clms;
	  
	  $ref_clms{$index} = $columns->{$index};
	  my $result = $self->_get_table($name,\%ref_clms,$index);
	  return $result;
	}; 
	
      }

=head2 include_MIB

=cut
 
    sub include_MIB {
	my $mib_class    = shift or croak "Invocation error";
	my $name         = shift or croak "Error: missing MIB name!";

	SNMPLib::Session->load_MIB($name);
    }


#######################################################################
########################## U T I L S ##################################

=head2 munge_ip() 

Takes a binary IP and makes it dotted ASCII

=cut

sub munge_ip {
    my $ip = shift;
    return join( '.', unpack( 'C4', $ip ) );
}

=head2 munge_mac()

Takes an octet stream (HEX-STRING) and returns a colon separated ASCII hex
string.

=cut

sub munge_mac {
    my $mac = shift;
    return unless defined $mac;
    return unless length $mac;
    $mac = join( ':', map { sprintf "%02x", $_ } unpack( 'C*', $mac ) );
    return $mac if $mac =~ /^([0-9A-F][0-9A-F]:){5}[0-9A-F][0-9A-F]$/i;
    return;
}

=head2 munge_bool()


=cut

sub munge_bool {
    my $bool = shift;
    my @ARR = qw ( nop  false true);
   
     return $ARR[$bool];
}



sub munge_caps {
     my $caps = shift;
     return unless defined $caps;

     my $bits = substr( unpack( "B*", $caps ), -7 );
     return $bits;
}

=item munge_prio_mac()

Takes an 8-byte octet stream (HEX-STRING) and returns a colon separated ASCII
hex string.

=cut

sub munge_prio_mac {
    my $mac = shift;
    return unless defined $mac;
    return unless length $mac;
    $mac = join( ':', map { sprintf "%02x", $_ } unpack( 'C*', $mac ) );
    return $mac if $mac =~ /^([0-9A-F][0-9A-F]:){7}[0-9A-F][0-9A-F]$/i;
    return;
}

=item munge_octet2hex()

Takes a binary octet stream and returns an ASCII hex string

=cut

sub munge_octet2hex {
    my $oct = shift;
    return join( '', map { sprintf "%x", $_ } unpack( 'C*', $oct ) );
}

=item munge_dec2bin()

Takes a binary char and returns its ASCII binary representation

=cut

sub munge_dec2bin {
    my $num = shift;
    return unless defined $num;

    #return unless length($num);
    $num = unpack( "B32", pack( "N", $num ) );

    # return last 8 characters only
    $num =~ s/.*(.{8})$/$1/;
    return $num;
}

=item munge_bits

Takes a SNMP2 'BITS' field and returns the ASCII bit string

=cut

sub munge_bits {
    my $bits = shift;
    return unless defined $bits;

    return unpack( "b*", $bits );
}


=item munge_counter64

If $BIGINT is set to true, then a Math::BigInt object is returned.
See Math::BigInt for details.

=cut

sub munge_counter64 {
    my $counter = shift;
    return          unless defined $counter;
    #return $counter unless $BIGINT;
    my $bigint = Math::BigInt->new($counter);
    return $bigint;
}

=item munge_i_up

There is a collision between data in C<IF-MIB> and C<RFC-1213>. 
For devices that fully implement C<IF-MIB> it might return 7 for 
a port that is down.  This munges the data against the C<IF-MIB> 
by hand.

TODO: Get the precedence of MIBs and overriding of MIB data in Net-SNMP
figured out.  Heirarchy/precendence of MIBS in SNMP::Info.

=cut

sub munge_i_up {
    my $i_up = shift;
    return unless defined $i_up;

    $i_up = 'down' if $i_up eq '7';

    return $i_up;
}

=item munge_port_list

Takes an octet string representing a set of ports and returns a reference
to an array of binary values each array element representing a port. 

If the element has a value of '1', then that port is included in the set of
ports; the port is not included if it has a value of '0'.

=cut

sub munge_port_list {
    my $oct = shift;
    return unless defined $oct;

    my $list = [ split( //, unpack( "B*", $oct ) ) ];

    return $list;
}

=item munge_null()

Removes nulls from a string

=cut

# munge_null() - removes nulls (\0)
sub munge_null {
    my $text = shift || return;

    $text =~ s/\0//g;
    return $text;
}

=item munge_e_type()

Takes an OID and return the object name if the right MIB is loaded.

=cut

sub munge_e_type {
    my $oid = shift;

    my $name = &SNMP::translateObj($oid);
    return $name if defined($name);
    return $oid;
}

=head1 AUTHOR

Enrico Liguori, C<< <rigo at rigo.it> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-snmplib at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=SNMPLib>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc SNMPLib


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=SNMPLib>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/SNMPLib>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/SNMPLib>

=item * Search CPAN

L<http://search.cpan.org/dist/SNMPLib/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 Enrico Liguori, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; 
