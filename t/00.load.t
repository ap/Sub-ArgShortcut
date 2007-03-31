use Test::More tests => 2;

BEGIN { use_ok 'Sub::ArgShortcut'; }

is( \&argshortcut, \&Sub::ArgShortcut::argshortcut, 'argshortcut exported' );
