# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)
use strict;
use Test;

BEGIN {plan tests => 4 }

# use
use HTML::StickyQuery;
ok(1);

# file
my $s = HTML::StickyQuery->new;
$s->sticky(
	   file => 'test.html',
	   param => {SID => 'xxx'}
	   );
ok($s->output,'<a href="./test.cgi?SID=xxx">');

# scalarref
open(FILE,"./test.html") or die $!;
my $data = join('',<FILE>);
close(FILE);
$s->sticky(
	   scalarref => \$data,
	   param => {SID => 'xxx'}
	   );
ok($s->output,'<a href="./test.cgi?SID=xxx">');

# override
my $s2 = HTML::StickyQuery->new(override => 1);
$s2->sticky(
	    file => './test2.html',
	    param => {SID => 'xxx'}
	   );
ok($s2->output,'<a href="./test.cgi?SID=xxx">');

