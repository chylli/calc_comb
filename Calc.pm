package Calc;
use strict;
use warnings;
use feature qw(state say);
use Moo;
use Data::Dumper;

has data => (is => 'ro', required => 1);
has total => (is => 'ro', required => 1);
has sorted_data => (is => 'lazy');
sub _build_sorted_data {
  my $self = shift;
  return [reverse sort @{$self->data}];
}
has sums => (is => 'lazy');
sub _build_sums {
  my $self = shift;
  my $data = $self->sorted_data;

  my @sums;
  for my $j (0..$#$data) {
    my $k = $#$data - $j;
    my $result = $sums[0];
    $result += $data->[$k];
    unshift @sums, $result;
  }
  return @sums;
}
sub calc{
  my $self = shift;
  return [$self->do_calc($self->total, 0, 0)];
}
sub do_calc{
  my ($self, $total, $i, $layer ) = @_;
  $DB::single = 1;
  my $data = $self->sorted_data;
  say "." x $layer, $data->[$i] // 0;
  say "$total, $i";
  return () if $i > $#$data;
  # find it! return $i or $data$[i];
  return ([$data->[$i]]) if $total == $data->[$i];
  # bad comb
  #return () if sum($i+1) < $total - $data->[$i];
  return () if $total < 0;

  # the results that include this one
  my @total_result;
  my @result = $self->do_calc($total - $data->[$i], $i+1, $layer+1);
  for my $r (@result){
    # unshift $data->[$i] or [$i];
    unshift @$r, $data->[$i];
  }
  push @total_result, @result;
  
  @result = $self->do_calc($total, $i+1, $layer+1);
  push @total_result, @result;

  return @total_result;
}

sub calc_sum{
}

1;
