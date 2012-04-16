use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'SNMPLib',
    AUTHOR              => 'Enrico Liguori <rigo@rigo.it>',
    VERSION_FROM        => 'lib/SNMPLib.pm',
    ABSTRACT_FROM       => 'lib/SNMPLib.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'SNMPLib-*' },
);
