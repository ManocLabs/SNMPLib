package SNMPLib::Session;

use warnings;
use strict;

use Net::SNMP;
use SNMP;

use Carp;
use Data::Dumper;

use metaclass (
	       'attribute_metaclass' => 'SNMPLib::MyAttrClass',
	       );

my @MIB_DIRS = qw (
		   /usr/share/snmp/mibs/
		   );

my $Logger;
my $Debug;
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

=head2 add_MIBdir

=cut

sub add_MIBdir{
    my $self    = shift or croak "Invocation Error!";
    my $dir     = shift or croak "Error: missing directory!";

    unless( $dir =~ '/$'){
	$dir=$dir.'/';
    }
    push @MIB_DIRS, $dir;
}

=head2 get_MIBdir

=cut

sub get_MIBdirs{
    return @MIB_DIRS;
}

=head2 new
Apre la connessione ed inizializza la cache

=cut


    sub new {
	my $proto     = shift or croak "Invocation Error!";
	my $class     = ref($proto) || $proto;
	my $self  = {};
	my %args      = @_;
	$self->{'name'} = $args{'name'};
	$self->{'host'} = $args{'hostname'};
	
	%args = map {$_=>$args{$_}}  grep(!/^name$/, keys %args);

	bless $self, $class;
	
	$Debug  = SNMPLib::debug_mode();
	$Logger = SNMPLib::Logger::get_default_instance();
	
	#initialize the cache
	$self->{'cache'} = {};
        #Session Options:
        #    [-hostname      => $hostname,] ------> required
        #    [-port          => $port,]  
        #    [-localaddr     => $localaddr,]
        #    [-localport     => $localport,]
        #    [-nonblocking   => $boolean,]
        #    [-version       => $version,]  ------> required  
        #    [-domain        => $domain,]
        #    [-timeout       => $seconds,]
        #    [-retries       => $count,]
        #    [-maxmsgsize    => $octets,]
        #    [-translate     => $translate,]
        #    [-debug         => $bitmask,]
        #    [-community     => $community,]# v1/v2c ------> required
        #    [-username      => $username,]    # v3
        #    [-authkey       => $authkey,]     # v3
        #    [-authpassword  => $authpasswd,]  # v3
        #    [-authprotocol  => $authproto,]   # v3
        #    [-privkey       => $privkey,]     # v3
        #    [-privpassword  => $privpasswd,]  # v3
        #    [-privprotocol  => $privproto,]   # v3


	my ($session, $error) = Net::SNMP->session( %args );

	if(!defined($session)){
	    croak "Session error: $error";
	    return undef;
	}

	#Test the connectivity
	#my $oid = $self->translate('sysDescr');
	#$oid = $oid.'.0';
	my $result = $session->get_request( '-varbindlist'  => ['1.3.6.1.2.1.1.1.0'] );
	if(!defined($result)){
	    return undef;
	}
	

	$session->translate(
                             [
                                '-all'            => 1 ,
                                '-octetstring'    => 0 ,
                                '-null'           => 1 ,
                                '-timeticks'      => 0 ,
                                '-opaque'         => 1 ,
                                '-nosuchobject'   => 1 ,
                                '-nosuchinstance' => 1 ,
                                '-endofmibview'   => 1 ,
                                '-unsigned'       => 1 ,
                               ]);

	
	$session and $self->set_session($session);


	return $self;
    }

=head2 close_session

=cut

    sub close_session {
	my $self    = shift or croak "Invocation Error!";
	my $session = $self->get_session;
	my $name    = $self->{'name'};
	$session->close;
	$self->set_session(undef);
      	$Debug and $Logger->debug("Session Session_$name closed");
    }

=head2 set_session

=cut

    sub set_session {
	my $self = shift or croak "Invocation Error!";
	my $sess = shift;
        $self->{'session'} = $sess;
    }

=head2 get_session

=cut

    sub get_session {
	my $self = shift or croak "Invocation Error!";
	return $self->{'session'};
    }


=head2 clear_cache

=cut

    sub clear_cache {
    }

=head2 translate
Traduce OID in stringhe 

=cut

    sub translate {
	my $self    = shift or croak "Invocation Error!";
	my $baseoid = shift or croak "Missing OID Parameter";

	my $translated =  &SNMP::translateObj($baseoid);
	$translated || croak("Traduction error: oid $baseoid not found!");
	return $translated;
    }

=head2 get_scalar

=cut

    sub _get_scalar {
	my $self    = shift or croak "Invocation Error!";
	my $baseoid = shift or croak "Error: baseoid missing!";
	my $req = $baseoid;

	my $session = $self->get_session;

	if($baseoid !~ /^([\d\.]+)$/){
	    $baseoid = $self->translate($baseoid); 	    
	}
	#add istance number to the oid
	$baseoid .= '.0';
	
	my $cached = $self->{'cache'}->{$baseoid};
	return $cached if($cached);
	my $result = $session->get_request( '-varbindlist'  => [$baseoid] );
	$result or $Logger->error("Error: ".$session->error());

	$self->{'cache'}->{$baseoid} = $result->{$baseoid};
	if($Debug){
	    defined($result->{$baseoid}) ?  $Logger->debug("Request for $req successfully completed") : $Logger->debug("Request for $req NOT successfully completed (Maybe the OID is not implemented on this device?)"); }
	return $result->{$baseoid};
    }


=head2 get_table

=cut
     sub _get_table {
 	my $self         = shift or croak "Invocation Error!";
 	my $baseoid      = shift or croak "Error: baseoid missing!";
 	my $col_ref      = shift or croak "Error: columns missing!";
	my $index_name   = shift or croak "Error: index missing!";
	my $session      = $self->get_session;
	my $index_munger = $col_ref->{$index_name} || sub {$_[0]};
	my $req          = $baseoid;

	#TODO: SISTEMARE CACHE PER LE COLONNE
 	#my $cached  = $self->{'cache'}->{$baseoid};
	#return $cached if($cached);

	my @columns = grep(!/^$index_name$/ ,keys %{$col_ref});
 	my %columns_oid = map { $self->translate($_) => $_ } @columns;

 	my $t = $session->get_entries(-columns => [ keys %columns_oid ],
			             #-maxrepetitions => 1 #in order to perform get-next request to retrieve the table
				      );
	
	if($Debug){
	    defined($t) ?  
		$Logger->debug("Request for $req successfully completed") : 
		$Logger->debug("Request for $req NOT successfully completed (Maybe the OID is not implemented on this device?)"); 
	}
    
	#reorganization of the table
 	my %parsed_table;
 	my ($k ,$v);
	my $index;
 	while ( ($k ,$v) = each(%$t)) {
 	  foreach my $oid (keys %columns_oid) {
	    $k =~ /^$oid\Q.\E(.*)$/ or next;
 	    $index  = $1;
	    my $column = $columns_oid{$oid};
	    #if the munger for this column is defined munge the value $v
	    my $munger = $col_ref->{$column};
	    $v = $munger->($v) if (defined($munger));
	    $parsed_table{$index}->{$column} = $v;
	    
	    if(!$parsed_table{$index}->{$index_name}){ 
	      $parsed_table{$index}->{$index_name} = $index_munger->($index);
	    }
	    last;
	  }
	  
 	}
	
 	$self->{'cache'}->{$baseoid} = \%parsed_table;

 	
 	return \%parsed_table;
    }

=head2 load_MIB

=cut

    sub load_MIB {
	my $self = shift or croak "Invocation Error!";
	my $MIB  = shift or croak "Error: missing MIB!";

	my @DIRS = $self->get_MIBdirs;

	foreach my $dir (@DIRS) {
	    my $expl_path = $dir.$MIB;
	    if(-e $expl_path.".txt") {
		SNMP::loadModules($MIB);
		  $Debug and $Logger->debug("File $MIB.txt loaded!");
		  return;
	      }
	    elsif(-e $expl_path.".my") {
		SNMP::addMibFiles($expl_path.".my");
		  $Debug and $Logger->debug("File $MIB.my loaded!");
		  return;
	      }
	}
	$Logger->error("Could not find $MIB.*!");
    }


=head2 open_temp_connection

=cut

sub  open_temp_connection {
}

sub error {
    my $info = shift;
    my $error = shift;
    $Logger->error("Errore!!!");
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
