package SNMPLib::SessionFactory;

use warnings;
use strict;
use Carp;
use Data::Dumper; 

use SNMPLib;
use SNMPLib::Session;
use SNMPLib::Device::Generic;

use FindBin;
use lib "$FindBin::Bin/../lib";

use metaclass (
	       'attribute_metaclass' => 'SNMPLib::MyAttrClass',
	      );


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

sub new{
  my $proto     = shift;
  my $class     = ref($proto) || $proto;
  my %args      = @_;
	
  my $self  = {};
  $self->{'cb'} = $args{'post_req'};
  bless $self, $class;
	
  SNMPLib::set_factory( $self );
  return $self
}


=head2 open

TODO: Sistemare metodo d'invocazione a Session (dovrebbe permettere di
      passare alla open anche opzioni di Net-SNMP)

=cut


sub open {
  my $self    = shift or croak "Invocation Error!";
  my %args    = @_;
  my $logger  = $args{'logger'};
  my $debug   = $args{'debug'};
  my $addr    = $args{'host'}      or croak "You must pass a valid hostname!";
  my $comm    = $args{'community'} or croak "You must pass a community name!";
  my $version = $args{'version'}   or croak "You must pass a SNMP version number!";
  #  my $user    = $args{'username'};
  #  my $pass    = $args{'password'};

  if ($debug) {
    SNMPLib::debug_mode($debug);
  } else {
    $debug = SNMPLib::debug_mode();
  }
  if ($logger) {
    SNMPLib::Logger::set_default_instance($logger);
  } else {
    $logger =  SNMPLib::Logger::get_default_instance();
  }   

  my $d = SNMPLib::Device::Generic->new();
  $d->create_traits();
   
  my $temp_sess = new Session_Generic(   
				      hostname   => $addr,
				      community  => $comm,
				      version    => $version,
				      name       => 'Generic',
				     );
  if(!defined($temp_sess)){
    $logger->error("Could not open a connection with $addr!");
    return undef;
  }
  my ($sess, $desc);
  $desc = $temp_sess->sysDescr;

  if (defined($desc)) {
    $sess = $self->get_session_obj($desc,$addr,$comm,$version);
    if($sess){
	#$logger->info("Connection with $addr established");
	$temp_sess->close_session();
    }
    else {
	$logger->info("Session type returned is Generic");
	$sess = $temp_sess;
    }
  } else {
    $logger->error("Cannot get the system description!");
    $sess = $temp_sess;
    $logger->info("Device $addr not recognized. The object type returned is Generic");
  }
  return $sess;
}



=head2 get_session_obj

=cut

sub get_session_obj{
  my $self    = shift or croak "Invocation Error!";
  my $desc    = shift or croak "Error: Missing Description!";
  my $addr    = shift or croak "Error: Missing Address!";
  my $comm    = shift or croak "Error: Missing Community!";
  my $version = shift or croak "You must pass a SNMP version number!";

  my $debug  = SNMPLib::debug_mode();
  my $logger = SNMPLib::Logger::get_default_instance();
    
  my $objtype; 
  $objtype = 'Catalyst' if $desc =~ /(C3550|C3560)/;
  $objtype = 'C4000' if $desc =~ /Catalyst 4[05]00/;
  $objtype = 'Foundry' if $desc =~ /foundry/i;
    
  # Aironet - older non-IOS
  $objtype = 'Aironet'
    if ($desc =~ /Cisco/
	and $desc =~ /\D(CAP340|AP340|CAP350|350|1200)\D/ );
  $objtype = 'Aironet'
    if ( $desc =~ /Aironet/ and $desc =~ /\D(AP4800)\D/ );
  $objtype = 'Catalyst' if $desc =~ /(c6sup2|c6sup1)/;
    
  # Next one untested. Reported working by DA
  $objtype = 'Catalyst'
    if ( $desc =~ /cisco/i and $desc =~ /3750/ );
  $objtype = 'Catalyst'
    if $desc =~ /(s72033_rp|s3223_rp|s222_rp)/;
    
  # HP, Foundry OEM
  $objtype = 'HP9300'
    if $desc =~ /\b(J4874A|J4138A|J4139A|J4840A|J4841A)\b/;
    
  # Nortel ERS (Passport) 1600 Series < version 2.1
  $objtype = 'N1600'
    if $desc =~ /(Passport|Ethernet\s+Routing\s+Switch)-16/i;
    
  #  ERS - BayStack Numbered
  $objtype = 'Baystack'
    if ( $desc
	 =~ /^(BayStack|Ethernet\s+Routing\s+Switch)\s[2345](\d){2,3}/i );
    
  # Nortel Alteon AD Series  
  $objtype = 'AlteonAD'
    if $desc =~ /Alteon\s[1A][8D]/;
    
  # Nortel Contivity
  $objtype = 'Contivity' if $desc =~ /\bCES\b/;
    
  # Allied Telesyn Layer2 managed switches. They report they have L3 support
  $objtype = 'Allied'
    if ( $desc =~ /Allied.*AT-80\d{2}\S*/i );
  # Mambro Categories
  $desc =~ /Cisco IOS Software, C1240 / and 
      $objtype = "Aironet1240";

  $desc =~ /Cisco.*?IOS.*? (C3750|C2960)/ and
      $objtype = "Catalyst";
  
  $desc =~ /IOS.*C2950/ and
    $objtype = "Catalyst";
  
  #Blade Switch
  $desc =~ /(CIGESM|CBS31X0)/ and
    $objtype = "Catalyst";
  #Wism
  $desc =~ /Cisco.*?IOS.*?vg224/ and
    $objtype = 'CiscoWism';
  #6500
  $desc =~ /(s72033_rp|s3223_rp|s222_rp)/ and 
    $objtype = 'Catalyst';
  #Voice Gateway
  $desc =~ /Cisco.*?IOS.*?2800/ and
    $objtype = 'CiscoVGW';
  #Wism
  $desc =~ /Cisco Controller/ and
    $objtype = 'CiscoWism';
  
   $desc =~ /C180X/ and
    $objtype = 'CiscoRouter';
  #XL series
  $desc =~ /(2900XL|3500XL)/ and
    $objtype = 'Cisco2900';

  
  if ($objtype) {
    $debug and $logger->debug("Device type (default routine): $objtype");
  } else {
    $debug and $logger->debug("Device type (default routine): unknown");
  }
  #process user callback's (if exist)
  if ( defined($self->{'cb'}) ) {
    my $temp_objtype = $self->{'cb'}->($desc);
    if (defined($temp_objtype)) {
      $debug and $logger->debug("Device type (user defined routine): $temp_objtype");
      $objtype = $temp_objtype;
    } 
    else {
      $objtype or $objtype  = 'Generic';
      $debug and $logger->debug("Device type (user defined routine): unknown");
    }
  }

  $logger->info("Device type of $addr:  $objtype");
    
  #definizioni di device e session
  my $dev_class  = 'SNMPLib::Device::'.$objtype;
  my $dev_path   = "SNMPLib/Device/$objtype.pm";
  my $sess_class = 'Session_'.$objtype;
  my $session;
  #creazione classe Device e aggiunta dei relativi traits
  eval {require $dev_path;};
  if($@) {
      $logger->error("$@");
      $logger->error("The device class $objtype doesn't exist.\nCreate it (inside SNMPLib/Device/)in order to specify which MIBs implements the device");
  }
  else {
      my $d = $dev_class->new();
      $d->create_traits();
      
      $session = $sess_class->new(  
				    hostname   => $addr,
				    community  => $comm,
				    version    => $version,
				    name       => $objtype,
				    );
  }

  if ($session) {
    $debug and $logger->debug("The object Session::$sess_class (associated with the device Device::$dev_class) was correctly created");
   # my @meth_names = $session->meta->get_all_method_names();
      
   # $debug and $logger->debug("$sess_class\'s methods list: ".join ("\n",@meth_names));
  }
  return $session;
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
