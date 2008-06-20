use strict;
use warnings;
use Module::Build;

# can't use `create_makefile_pl` because MB::Compat
# won't detect the conditional dep

my $class = Module::Build->subclass(
	code => q{
		sub ACTION_dist {
			my $self = shift;
			my @r = $self->SUPER::ACTION_dist( @_ );
			print "\n\n**** Remember: Makefile.PL is not automatically updated ****\n\n";
			return @r[0..$#r];
		}
	},
);

my $builder = $class->new(
	#create_makefile_pl  => 'traditional',
	module_name         => 'Sub::ArgShortcut',
	license             => 'perl',
	dist_author         => 'Aristotle Pagaltzis <pagaltzis@gmx.de>',
	build_requires      => { 'Test::More' => 0 },
	add_to_cleanup      => [ 'Sub-ArgShortcut-*' ],
	requires            => {
		$] < 5.007003 ? ( 'Attribute::Handlers' => 0 ) : (),
	},
);

$builder->create_build_script();
