
use Test;
use HTML::StickyQuery;

BEGIN{plan tests => 1}

# scalarref
open(FILE,"./t/test.html") or die $!;
my $data = join('',<FILE>);
close(FILE);

my $s = HTML::StickyQuery->new;
$s->sticky(
	   scalarref => \$data,
	   param => {SID => 'xxx'}
	   );

ok($s->output,'<a href="./test.cgi?SID=xxx">');

