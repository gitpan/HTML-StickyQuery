
use Test;
use HTML::StickyQuery;

BEGIN{plan tests => 1}

# file
my $s = HTML::StickyQuery->new;
$s->sticky(
	   file => './t/test.html',
	   param => {SID => 'xxx'}
	   );
ok($s->output,'<a href="./test.cgi?SID=xxx">');
