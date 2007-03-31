#!/usr/bin/perl

=head1 NAME

Sub::ArgShortcut - simplify writing functions that use default arguments

=head1 VERSION

This document describes Sub::ArgShortcut version 1.0

=cut

=head1 SYNOPSIS

 use Sub::ArgShortcut::Attr;

 sub basename :ArgShortcut { s!.*/!! for @_ }
 
 for ( '/path/to/foo', '/some/path/to/bar' ) {
     print "Munging " . basename . "\n";
     open my $fh, '<', $_ or die $!;
     # ...
 }

=head1 DESCRIPTION

This module encapsulates the logic required for functions that use default arguments, as many core Perl functions do. You only need to write code which modifies the elements of C<@_> in-place. This module will then layer the following two behaviours on top of your code:

=over 4

=item *

If no arguments are given, the function will use C<$_> as its input.

=item *

If no return value is expected, it will modify its arguments in-place.

=back

=head2 C<argshortcut(&)>

This function takes a code reference as input, wraps a function around it and returns a reference to that function. The code that is passed in should modify the values in C<@_> in whatever fashion desired. The returned wrapped function will do the same thing as the unwrapped function, but will assume C<$_> as its input when called with an empty argument list and will return modified copies of the argument list elements if called in any context other than void.

The code from the L<synopsis|/SYNOPSIS> can therefore also be written like this:

 use Sub::ArgShortcut;

 my $basename = argshortcut { s!.*/!! for @_ };
 
 for ( '/path/to/foo', '/some/path/to/bar' ) {
     print "Munging " . $basename->() . "\n";
     open my $fh, '<', $_ or die $!;
     # ...
 }

This function is exported by default.

=head2 Sub::ArgShortcut::Attr and C<:ArgShortcut> - The attribute interface

Instead of using L<argshortcut/C<argshortcut(&)>> to wrap a code reference, you can use an L<Attribute::Handler>-based interface to add Sub::ArgShortcut functionality to regular subs. Simply C<use Sub::Shortcut::Attr> instead of Sub::Shortcut, then request its behaviour using the C<:ArgShortcut> attribute on functions:

 sub basename :ArgShortcut { s!.*/!! for @_ }

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to L<mailto:bug-sub-argshortcut@rt.cpan.org>, or through the web interface at L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=sub-argshortcut>.


=head1 AUTHOR

Aristotle Pagaltzis  L<mailto:pagaltzis@gmx.de>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2006, Aristotle Pagaltzis. All rights reserved.

This module is free software; you can redistribute it and/or modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.

=cut

package Sub::ArgShortcut;

$VERSION = '1.0';

use strict;
use warnings;

sub croak { require Carp; goto &Carp::croak }

sub argshortcut(&) {
	my ( $code ) = @_;
	return sub {
		my @byval;
		my $nondestructive = defined wantarray;
		$code->(
			$nondestructive
			? ( @byval = @_ ? @_ : $_ )
			: (          @_ ? @_ : $_ )
		);
		return $nondestructive ? @byval[ 0 .. $#byval ] : ();
	};
}

sub import {
	my $class = shift;
	my $install_pkg = caller;
	die q(Something mysterious happened) if not defined $install_pkg;
	{ no strict 'refs'; *{"${install_pkg}::argshortcut"} = \&argshortcut; }
}

1;
