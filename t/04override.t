
use Test;
use HTML::StickyQuery;

BEGIN{plan tests => 2}

{
    my $s = HTML::StickyQuery->new(override => 1);
    $s->sticky(
       file => './t/test2.html',
       param => {SID => 'xyz'}
    );
    ok($s->output,'<a href="./test.cgi?SID=xyz">');
}

{
    my $s = HTML::StickyQuery->new(override => 0);
    $s->sticky(
       file => './t/test2.html',
       param => {foo => 'baz'}
    );
    ok($s->output,'<a href="./test.cgi?foo=bar">');
}
