package Calc2;
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

sub calc {
    my $self = shift;
    my @result = $self->do_calc;
    my @new_result;
    #say Dumper(\@result);
    for my $r (@result){
        #say "r is " . Dumper($r);
        push @new_result, [map {$self->data->[$_]} @$r];
    }
    return \@new_result;
}
sub do_calc {
    my $self = shift;
    my $data = $self->data;
    my $total = $self->total;
    my @total_result;
    my @current_result = (0);
    my $sum = 0;

    # my $advance = sub;
    while(1){
        $DB::single = 1;
        if($current_result[-1] > $#$data){
            pop @current_result;
            last unless @current_result;
            $sum -= $data->[$current_result[-1]];
            $current_result[-1] ++;
            next;
        }
        $sum += $data->[$current_result[-1]];
        if($sum == $total){
            push @total_result, [@current_result];
            $sum -= $data->[$current_result[-1]];
            $current_result[-1]++;
            next;
        }
        if($sum > $total){
            $sum -= $data->[$current_result[-1]];
            $current_result[-1]++;
            next;
        }
        if($sum < $total){
            push @current_result, $current_result[-1] + 1;
            next;
        }
    }
    return @total_result;
}

1;
