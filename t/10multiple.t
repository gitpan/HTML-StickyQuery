
use Test;
use HTML::StickyQuery;

BEGIN{plan tests => 2}

# file
my $s = HTML::StickyQuery->new;
$s->sticky(
	   file => './t/test.html',
	   param => { SID => ['xxx', 'yyy'] }
	   );

ok($s->output, qr/SID=xxx/);
ok($s->output, qr/SID=yyy/);
