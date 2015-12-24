requires 'perl', '5.006';
requires 'strict';
requires 'warnings';
requires 'Carp';
requires 'Attribute::Handlers';

on test => sub {
	requires 'Test::More', '0.88';
};

# vim: ft=perl
