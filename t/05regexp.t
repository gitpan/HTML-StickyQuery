
use Test;
use HTML::StickyQuery;

BEGIN{plan tests => 1}

my $s = HTML::StickyQuery->new(
			       regexp => '^/cgi-bin/'
			      );
$s->sticky(
	    file => './t/test3.html',
	    param => {SID => 'xxx'}
	   );
ok($s->output,
   '<a href="./test.cgi?foo=bar"><a href="/cgi-bin/test.cgi?SID=xxx">');
