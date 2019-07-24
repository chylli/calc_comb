use strict;
use warnings;
use feature qw(state say);
use Data::Dumper;

my @data = reverse sort (1..3);

my $want_total = 4;

my @result = calc($want_total, 0, 0);
say Dumper(\@result);

sub calc{
  my ($total, $i, $layer ) = @_;
  say "." x $layer, "$data[$i]";
  # find it! return $i or $data$[i];
  return ([$data[$i]]) if $total == $data[$i];
  return () if $i > $#data;
  # bad comb
  #return () if sum($i+1) < $total - $data[$i];
  return () if $total < 0;

  my @total_result;
  for my $j ($i+1 .. $#data){
      my @result = calc($total - $data[$i], $i+1, $layer+1);
      for my $r (@result){
        # unshift $data[$i] or [$i];
        unshift @$r, $data[$i];
      }
      push @total_result, @result;

      @result = calc($total, $i+1, $layer+1);
      push @total_result, @result;

    }
  return @total_result;
}

sub sum{
  my $i = shift;
  state @sum = ();
  if(@sum == 0){
    for my $j (0..$#data) {
      my $k = $#data - $j;
          my $result = $sum[0];
          $result += $data[$k];
          unshift @sum, $result;
        }

  }
  return $sum[$i];
}
