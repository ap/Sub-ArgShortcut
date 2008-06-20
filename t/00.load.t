use Test::More tests => 2;

BEGIN {
	use_ok 'Sub::ArgShortcut'
		or BAIL_OUT( 'testing pointless if the module won\'t even load' );
}

is( \&argshortcut, \&Sub::ArgShortcut::argshortcut, 'argshortcut exported' );
