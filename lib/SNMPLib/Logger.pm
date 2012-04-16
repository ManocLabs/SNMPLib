package SNMPLib::Logger;

use warnings;
use strict;

use Carp;
use Data::Dumper;


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

=head1 FUNCTIONS


=head2 new

=cut

my $Default_istance;

sub new{
  my $proto     = shift;
  my $class     = ref($proto) || $proto;
  my %args      = @_;
  
  my $self  = {};
  bless $self, $class;
  return $self;
}

=head2  get_default_instance



=cut

sub get_default_instance {
  return $Default_istance  if(defined($Default_istance));
  
  $Default_istance = SNMPLib::Logger->new();
  return $Default_istance ;
}

=head2  set_default_instance



=cut
    
sub set_default_instance {
  my $self = shift or croak "Invocation error";
  $Default_istance = $self;
  
  return $Default_istance ;
}


=head2 debug

=cut

sub debug{
    my $self = shift or croak "Invocation Error!";
    my $msg  = shift or croak "Missing message parameter!";

    print "[DEBUG]:$msg\n";
}

=head2 info

=cut

sub info{
    my $self = shift or croak "Invocation Error!";
    my $msg  = shift or croak "Missing message parameter!";

    print "[INFO]:$msg\n";
}

=head2 error

=cut

sub error{
    my $self = shift or croak "Invocation Error!";
    my $msg  = shift or croak "Missing message parameter!";
    
    print "[ERROR]:$msg\n";
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
