
use Test;
use HTML::StickyQuery;

BEGIN{
    plan tests => 2
}

my $s = HTML::StickyQuery->new;
$s->sticky(
	   file => 't/test6.html',
	   param => {a => 'xxx'}
	   );
ok($s->output, qr/<!DOCTYPE/);
ok($s->output, qr/<!-- foobar -->/);


