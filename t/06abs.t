
use Test;
use HTML::StickyQuery;

BEGIN{plan tests => 2}

my $s = HTML::StickyQuery->new;
$s->sticky(
	    file => './t/test4.html',
	    param => {SID => 'xxx'}
	   );
ok($s->output,
   '<a href="./test.cgi?SID=xxx"><a href="http://127.0.0.1/test.cgi">'
  );

my $s2 = HTML::StickyQuery->new(
				abs => 1
			       );
$s2->sticky(
	    file => './t/test4.html',
	    param => {SID => 'xxx'}
	   );
ok($s2->output,
   '<a href="./test.cgi?SID=xxx"><a href="http://127.0.0.1/test.cgi?SID=xxx">'
  );




