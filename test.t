use strict;
use warnings;
use Test::More;
use Calc;

for my $tdata (
               [[1], 0, [[]]],
               [[1], 1, [[1]]],
               [[1], 2, []],
               [[1,2], 0, [[]]],
               [[1,2], 1, [[1]]],
               [[1,2], 2, [[2]]],
               [[1,2], 3, [[2,1]]],
               [[1,2], 4, []],
               [[1..3], 0, [[]]],
               [[1..3], 1, [[1]]],
               [[1..3], 2, [[2]]],
               [[1..3], 3, [[3],[2,1]]],
               #[[1..3], 4, []],
               #[[1..3], 5, []],
               #[[1..3], 6, [[3,2,1]]],
               #[[1..3], 7, []],
              ){
  my $result;
  is_deeply($result = Calc->new(data => $tdata->[0], total => $tdata->[1])->calc(), $tdata->[2])
    or diag(explain($tdata, $result));
}
done_testing();
