
use Test;
use HTML::StickyQuery;
use CGI;

BEGIN{plan tests => 3}

my $s = HTML::StickyQuery->new;
my $q = CGI->new({ foo => ['bar', 'baz'], bar => 'baz'});
$s->sticky(
	   file => './t/test.html',
	   param => $q
	   );
ok($s->output, qr/foo=bar/);
ok($s->output, qr/foo=baz/);
ok($s->output, qr/bar=baz/);
