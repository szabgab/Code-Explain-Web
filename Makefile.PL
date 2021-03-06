use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
	NAME                => 'Code-Explain-Web',
	AUTHOR              => q{Gabor Szabo <szabgab@cpan.org>},
	VERSION_FROM        => 'lib/Code/Explain/Web.pm',
	ABSTRACT            => 'YOUR APPLICATION ABSTRACT',
	($ExtUtils::MakeMaker::VERSION >= 6.3002
		? ('LICENSE'=> 'perl')
		: ()),
	PL_FILES            => {},
	PREREQ_PM => {
		'Test::More'    => 0,
		'YAML'          => 0,
		'Dancer'        => 1.2003,
		'Code::Explain' => '0.02',
		'Template'      => '2.25',
	},
	dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
	clean               => { FILES => 'Code::Explain::Web-*' },
);
