#!/usr/bin/perl -T
use strict;
use warnings;

package Sub::ArgShortcut::Attr;

use Sub::ArgShortcut;
use Attribute::Handlers;

sub UNIVERSAL::ArgShortcut : ATTR(CODE) {
	my ( $package, $symbol, $referent, $attr, $data, $phase ) = @_;
	{ no warnings 'redefine'; *$symbol = argshortcut \&$referent; }
	return;
}

1;
