package SNMPLib;

use warnings;
use strict;

use SNMPLib::SessionFactory;
use SNMPLib::Logger;

use metaclass ('attribute_metaclass' => 'SNMPLib::MyAttrClass');
use Data::Dumper;
use Carp;


=head1 NAME

SNMPLib - The great new SNMPLib!

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

=head2 set_factory

=cut

my $Default_factory;

sub set_factory {
  my $opt = shift or croak "You must pass a valid factory obj!";
  $Default_factory =  $opt;
}

=head2 get_factory

=cut

sub get_factory {
   return $Default_factory;
}

=head2 debug_mode

=cut
my $Debug;

sub debug_mode {
  my $arg = shift;
  $Debug = $arg if(defined($arg));
  return $Debug;
}


=head2 open

=cut


sub open {
  my %args   = @_;

  
  #init default opts
  $args{'debug'}  = debug_mode(0) unless(defined($args{'debug'}));
  set_factory(SNMPLib::SessionFactory->new()) unless($Default_factory);
  $args{'logger'} =  SNMPLib::Logger::get_default_instance()
      unless(defined($args{'logger'}));
  #Ask to default factory to open a connection with the device
  $Default_factory->open(%args);
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

1; # End of SNMPLib
