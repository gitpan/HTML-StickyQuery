
use Test;
use HTML::StickyQuery;

BEGIN{plan tests => 1}

# scalarref
open(FILE,"./t/test.html") or die $!;
my @data = <FILE>;
close(FILE);

my $s = HTML::StickyQuery->new;
$s->sticky(
	   arrayref => \@data,
	   param => {SID => 'xxx'}
	   );

ok($s->output,'<a href="./test.cgi?SID=xxx">');
