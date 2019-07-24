package Calc;
use strict;
use warnings;
use feature qw(state say);
use Moo;
use Data::Dumper;
our $DEBUG = 0;
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
  my ($self, $total, $i) = @_;
  my @stack;
  my $total_result = [];
  push @stack($total, $i, $total_result);

  while(@stack){
    my $item = pop @stack;
    my ($total, $i, $total_result) = @$item;

    my $data = $self->sorted_data;
    # the numbers before this one are the answer, no need to check more
    return ([]) if $total == 0;
    #no result
    return () if $i > $#$data || $total < 0;

    my @total_result;

    # the results that include this one
    my @result = $self->do_calc($total - $data->[$i], $i+1);
    for my $r (@result) {
      # return data or index
      unshift @$r, $data->[$i];
    }
    push @total_result, @result;

    # the results that not include this one
    @result = $self->do_calc($total, $i+1);
    push @total_result, @result;

    return @total_result;

  }
}

1;
