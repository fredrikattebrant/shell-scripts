#!/usr/bin/perl

sub randomPassword {
  my $password;
  my $_rand;

  my $password_length = $_[0];
  if (!$password_length) {
    $password_length = 10;
  }

  my @chars = split(" ",
    "a b c d e f g h i j k l m n o
     p q r s t u v w x y z A B C D
     E F G H I J K L M N O P Q R S
     T U V W X Y Z # 0 1 2 3 4 5 6
     7   . - = _ 8 9 ! % # ");
  push(@chars, ' ');
  srand;
  my $nchars = $#chars + 1;

  for (my $i=0; $i <= $password_length ;$i++) {
    $_rand = int(rand $nchars);
    $password .= $chars[$_rand];
  }
  return $password;
}

#print "\n\nRandom Password = ", randomPassword(9);
#print randomPassword(9);
#print randomPassword($length);
print randomPassword($ARGV[0]);
print "\n";
