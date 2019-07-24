use strict;
use warnings;
use feature qw(state say);
use Data::Dumper;
use Calc;

my $data = [(1..1000) x 2];
my $total = 2000;
print Dumper(Calc->new(data => $data, total => $total)->calc());
