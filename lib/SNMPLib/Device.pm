package SNMPLib::Device;

use warnings;
use strict;
use Carp;
use Data::Dumper; 
use SNMPLib;
use SNMPLib::Session;

#use FindBin;
#use lib "$FindBin::Bin/../lib";

use metaclass (
	       'attribute_metaclass' => 'SNMPLib::MyAttrClass',
	       );

SNMPLib::Device->meta->add_attribute( 'dev_name' => 
			       ( accessor  => 'dev_name',
				 ));

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
    my $Logger;
    my $Debug;

    sub new {
	my $class = shift or croak "Error: Bad Invocation!";
	
	$Debug  = SNMPLib::debug_mode();
	$Logger = SNMPLib::Logger::get_default_instance();
	return $class->meta->new_object;
    }

=head2 add_MIB

Attraverso questa funzione è
possibile aggiungere direttamente istanze di MIB::XXX

=cut

    sub add_MIB {
	my $class  = shift or croak "Error: Bad Invocation";
	my $leaf   = shift or croak "Error: MIB name must be passed to add_MIB!";
  	if( !$class->meta->has_attribute('MIB_list') ) {
	    croak "Error!";
	} 
	
	my $attr = $class->meta->get_attribute('MIB_list');
	my @array =  @{$attr->default()->()};
	push  @array, $leaf;
	$class->meta->add_attribute($attr->clone(   default  => sub {\@array},
						    accessor => 'MIBS' ) 	);
    }


=head2 add_MIB_list

=cut
    
    sub add_MIB_list {
 	my $class      = shift or croak "Error: Bad Invocation";
	my $mibs_ref   = shift or croak "Error: a MIB_list must be passed!";
	my @mibs       = @{$mibs_ref};
		
        $class->meta->add_attribute( 'MIB_list' => (  default  => sub {\@mibs},
						      accessor => 'MIBS' )
				     );
    }

=head2 get_mibs

=cut

    sub get_mibs {
	my $class  = shift or croak "Error: Bad Invocation";
	my $attr = $class->meta->get_attribute('MIB_list') or croak "Error: ";
	my @array =  @{$attr->default()->()};		
	return @array;
    }    


=head2 set_session_method

=cut

    sub set_session_method {
      my $class     = shift or croak "Error: Bad Invocation";
      my $meth_name = shift or croak "Error: Bad mothod's name";
      my $meth_ref  = shift or croak "Error: Bad mothod's ref";
      my $name   = $class->meta->get_attribute('dev_name')->default or 
	croak "Error: ";
      my $session_name = 'Session_'.$name;

      $session_name->meta->add_method( $meth_name => $meth_ref );
    }




=head2 set_dev 

Subroutine che deve essere chiamata all \'inizio di ogni sottoclasse di Device.
Serve  per settare il nome del device e per creare la classe 
SNMPLib::Session::Session_XXX associata al device Device::XXX

=cut

    
sub set_dev {
	my ($class , $name) = @_;
	$class  or croak "Error: Bad Invocation"; 
	$name   or croak "Error: You must pass tha name of the Device!";


	#"move" attribute dev_name to the current class 
	my $attr = $class->meta->find_attribute_by_name('dev_name');  
	$class->meta->add_attribute($attr->clone( default => $name ));

	#add attribute (an array) MIB_list to the current class	
	$class->meta->add_attribute( 'MIB_list' => (  default  => sub {[]},
						      accessor => 'MIBS' ),
				     ); 
	#create the associated session class
    	Class::MOP::Class->create( 'Session_'.$name =>
				   (  superclasses => ['SNMPLib::Session'] ));	
    } 


=head2 create_traits

Deve essere chiamata dopo aver creato la classe Device::XXX. Serve
per aggiungere i vari trait definiti nelle classi MIB::YYY alla classe 
Session_XXX associata al particolare device

=cut

    sub create_traits {
	my $class  = shift or croak "Error: Bad Invocation";
	my @mibs   = $class->get_mibs;
       	my $name   = $class->meta->get_attribute('dev_name')->default or 
	    croak "Error: ";
	my $sess_name = 'Session_'.$name;
	
	foreach my $mib (@mibs) {
	  if (ref($mib)) {
	    $sess_name->load_MIB($mib->MIB_name);
	    $mib->add_trait('Session_'.$name);
	    $Debug and $Logger->debug("Adding $sess_name \'s methods defined in $mib");
	  } else {
	    my $mib_path = "SNMPLib/MIB/$mib.pm";
	    my $mib_class = 'SNMPLib::MIB::'.$mib;
	    eval{require $mib_path;};
	    if($@) {
	      $Logger->error("$@");
	      $Logger->error("Class MIB $mib_path doesn't exist. Create inside  SNMPLib/MIB/");
	    }
	    else {
	      my $mib_obj   = $mib_class->default_instance;
	      $sess_name->load_MIB($mib_obj->MIB_name);
	      $mib_obj->add_trait($sess_name);
	    }	
	  }
	}
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
