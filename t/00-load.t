#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'SNMPLib' );
}

diag( "Testing SNMPLib $SNMPLib::VERSION, Perl $], $^X" );
