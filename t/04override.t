
use Test;
use HTML::StickyQuery;

BEGIN{plan tests => 1}

my $s = HTML::StickyQuery->new(override => 1);
$s->sticky(
	    file => './t/test2.html',
	    param => {SID => 'xxx'}
	   );
ok($s->output,'<a href="./test.cgi?SID=xxx">');
