
use Test;
use HTML::StickyQuery;

BEGIN{plan tests => 1}

my $s = HTML::StickyQuery->new;
$s->sticky(
	   file => 't/test5.html',
	   param => {SID => 'xxx'}
	   );
ok($s->output,qq{<a href="test.cgi?SID=xxx" name="&lt;&quot;&amp;foo&gt;">});
