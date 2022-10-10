#!/usr/bin/perl

use warnings;
use strict;
use Test::Inter;
$::ti = new Test::Inter $0;
require "tests.pl";

our $obj1 = new Date::Manip::Date;
$obj1->config("forcedate","now,America/New_York");
our $obj2 = $obj1->new_delta();

sub test {
   my(@test)=@_;

   my $err = $obj1->parse(shift(@test));
   return $$obj1{"err"}  if ($err);
   $err = $obj2->parse(shift(@test));
   return $$obj2{"err"}  if ($err);

   my $obj3 = $obj1->calc($obj2,@test);
   return   if (! defined $obj3);
   $err = $obj3->err();
   return $err  if ($err);
   my $ret = $obj3->value();
   return $ret;
}

my $tests="

'1996-02-07 08:00' +1:1:1:1 0 => 1996020809:01:01

'1996-02-07 08:00' +1:1:1:1 1 => 1996020606:58:59

'1996-02-07 08:00' +1:1:1:1 2 => 1996020606:58:59

'1996-11-20 12:00:00' +0:5:0:0 0 => 1996112017:00:00

'1996-11-20 12:00:00' +0:5:0:0 1 => 1996112007:00:00

'1996-11-20 12:00:00' +0:5:0:0 2 => 1996112007:00:00

'1996-11-20 12:00:00' +0:13:0:0 0 => 1996112101:00:00

'1996-11-20 12:00:00' +0:13:0:0 1 => 1996111923:00:00

'1996-11-20 12:00:00' +0:13:0:0 2 => 1996111923:00:00

'1996-11-20 12:00:00' +3:2:0:0 0 => 1996112314:00:00

'1996-11-20 12:00:00' +3:2:0:0 1 => 1996111710:00:00

'1996-11-20 12:00:00' +3:2:0:0 2 => 1996111710:00:00

'1996-11-20 12:00:00' -3:2:0:0 0 => 1996111710:00:00

'1996-11-20 12:00:00' -3:2:0:0 1 => 1996112314:00:00

'1996-11-20 12:00:00' -3:2:0:0 2 => 1996112314:00:00

'1996-11-20 12:00:00' +3:13:0:0 0 => 1996112401:00:00

'1996-11-20 12:00:00' +3:13:0:0 1 => 1996111623:00:00

'1996-11-20 12:00:00' +3:13:0:0 2 => 1996111623:00:00

'1996-11-20 12:00:00' +6:2:0:0 0 => 1996112614:00:00

'1996-11-20 12:00:00' +6:2:0:0 1 => 1996111410:00:00

'1996-11-20 12:00:00' +6:2:0:0 2 => 1996111410:00:00

'1996-12-31 12:00:00' +1:2:0:0 0 => 1997010114:00:00

'2009-05-13 12:00:00' '+10 weeks' 0 => 2009072212:00:00

'2009-05-13 12:00:00' '+10 weeks' 1 => 2009030412:00:00

'2009-05-13 12:00:00' '+10 weeks' 2 => 2009030412:00:00

'2009-05-13 12:00:00' '-10 weeks' 0 => 2009030412:00:00

'2009-05-13 12:00:00' '-10 weeks' 1 => 2009072212:00:00

'2009-05-13 12:00:00' '-10 weeks' 2 => 2009072212:00:00

# Approximate deltas

'2009-05-13 12:00:00' '+ 1 year' 0 => 2010051312:00:00

'2009-05-13 12:00:00' '+ 1 year' 1 => 2008051312:00:00

'2009-05-13 12:00:00' '+ 1 year' 2 => 2008051312:00:00

2008022912:00:00 '+ 1 year' 0 => 2009022812:00:00

'2009-05-13 12:00:00' '+ 13 months' 0 => 2010061312:00:00

'2009-05-13 12:00:00' '+ 13 months' 1 => 2008041312:00:00

'2009-05-13 12:00:00' '+ 13 months' 2 => 2008041312:00:00

# Handle subtraction

'1998-11-28 00:00:00' 1:1:1:0:0:0:0 0 => 2000010400:00:00

'1998-11-28 00:00:00' 1:1:1:0:0:0:0 1 => 1997102100:00:00

'1998-11-28 00:00:00' 1:1:1:0:0:0:0 2 => 1997102100:00:00

'1999-01-04 00:00:00' 0:1:1:0:0:0:0 0 => 1999021100:00:00

'1999-01-04 00:00:00' 0:1:1:0:0:0:0 1 => 1998112700:00:00

'1999-01-04 00:00:00' 0:1:1:0:0:0:0 2 => 1998112800:00:00

1998112800:00:00 -0:1:1:0:0:0:0 0 => 1998102100:00:00

1998112800:00:00 -0:1:1:0:0:0:0 1 => 1999010400:00:00

1998112800:00:00 -0:1:1:0:0:0:0 2 => 1999010500:00:00

# Handle large deltas

'2000-01-01 00:00:00' 1:1:1:0:11111111:0:0  0 => 3268082623:00:00

'2000-01-01 00:00:00' -1:1:1:0:11111111:0:0 0 => 0731050801:00:00

'2000-01-01 00:00:00' 1:1:1:0:-11111111:0:0 0 => 0733072301:00:00

'2000-01-01 00:00:00' 1:1:1:0:11111111:0:0  1 => 0731050801:00:00

'2000-01-01 00:00:00' -1:1:1:0:11111111:0:0 1 => 3268082623:00:00

'2000-01-01 00:00:00' 1:1:1:0:-11111111:0:0 1 => 3266061123:00:00

'2000-01-01 00:00:00' 1:1:1:0:11111111:0:0  2 => 0731050701:00:00

'2000-01-01 00:00:00' -1:1:1:0:11111111:0:0 2 => 3268082623:00:00

'2000-01-01 00:00:00' 1:1:1:0:-11111111:0:0 2 => 3266061223:00:00

'1996-02-29 00:00:00' 1:1:1:0:11111111:0:0  0 => 3264102123:00:00

'1996-02-29 00:00:00' -1:1:1:0:11111111:0:0 0 => 0727070601:00:00

'1996-02-29 00:00:00' 1:1:1:0:-11111111:0:0 0 => 0729091701:00:00

'1996-02-29 00:00:00' 1:1:1:0:11111111:0:0  1 => 0727070601:00:00

'1996-02-29 00:00:00' -1:1:1:0:11111111:0:0 1 => 3264102123:00:00

'1996-02-29 00:00:00' 1:1:1:0:-11111111:0:0 1 => 3262080923:00:00

'1996-02-29 00:00:00' 1:1:1:0:11111111:0:0  2 => 0727070501:00:00

'1996-02-29 00:00:00' -1:1:1:0:11111111:0:0 2 => 3264102323:00:00

'1996-02-29 00:00:00' 1:1:1:0:-11111111:0:0 2 => 3262080923:00:00

'2000-01-01 00:00:00' 1:1:1:0:11111111111:0:0  0 => '[calc] Delta too large'

";

$::ti->tests(func  => \&test,
             tests => $tests);
$::ti->done_testing();

#Local Variables:
#mode: cperl
#indent-tabs-mode: nil
#cperl-indent-level: 3
#cperl-continued-statement-offset: 2
#cperl-continued-brace-offset: 0
#cperl-brace-offset: 0
#cperl-brace-imaginary-offset: 0
#cperl-label-offset: 0
#End:
