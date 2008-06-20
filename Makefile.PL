use ExtUtils::MakeMaker;
WriteMakefile(
	'NAME'         => 'Sub::ArgShortcut',
	'VERSION_FROM' => 'lib/Sub/ArgShortcut.pm',
	'PREREQ_PM'    => {
		'Test::More' => '0',
		$] < 5.007003 ? ( 'Attribute::Handlers' => 0 ) : (),
	},
	'INSTALLDIRS'  => 'site',
	'EXE_FILES'    => [],
	'PL_FILES'     => {}
);
