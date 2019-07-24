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
sub calc{
  my $self = shift;
  return [$self->do_calc($self->total, 0, 0)];
}
sub do_calc{
  my ($self, $total, $i, $layer ) = @_;
  my $data = $self->sorted_data;
  say "." x $layer, $data->[$i] // '' if $DEBUG;
  say "$total, $i" if $DEBUG;

  # the numbers before this one is the answer, no need to check more
  return ([]) if $total == 0;
  #no result
  return () if $i > $#$data || $total < 0;

  my @total_result;

  # the results that include this one
  my @result = $self->do_calc($total - $data->[$i], $i+1, $layer+1);
  for my $r (@result){
    # return data or index
    unshift @$r, $data->[$i];
  }
  push @total_result, @result;

  @result = $self->do_calc($total, $i+1, $layer+1);
  push @total_result, @result;

  return @total_result;
}

1;
