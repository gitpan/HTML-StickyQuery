use Test;
use HTML::StickyQuery;

BEGIN{plan tests => 3}

{
    my $s = HTML::StickyQuery->new;
    $s->sticky(
       file => './t/test2.html',
       param => {
	   SID => 'xyz',
	   foo => 'baz'
       }
    );
    ok($s->output, qr/SID=xyz/);
    ok($s->output, qr/foo=baz/);
}

{
    my $s = HTML::StickyQuery->new(keep_original => 0);
    $s->sticky(
       file => './t/test2.html',
       param => {SID => 'xyz'}
    );
    ok($s->output, '<a href="./test.cgi?SID=xyz">');
}
