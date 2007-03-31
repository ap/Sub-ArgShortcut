use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
	module_name         => 'Sub::ArgShortcut',
	license             => 'perl',
	dist_author         => 'Aristotle Pagaltzis <pagaltzis@gmx.de>',
	dist_version_from   => 'lib/Sub/ArgShortcut.pm',
	requires => {
		'Test::More' => 0,
	},
	add_to_cleanup      => [ 'Sub-ArgShortcut-*' ],
	create_makefile_pl  => 'traditional',
);

$builder->create_build_script();
