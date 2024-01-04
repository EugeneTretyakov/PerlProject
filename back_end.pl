#!/usr/bin/perl
use strict;
use warnings;
use lib '/Users/evgenijtretakov/PerlProject/tasks/tools';
use tools;

my( $action, $user_name, $password, $change_password )= @ARGV;

if ($action eq "log") {
    tools::login( $user_name,$password );
} elsif ($action eq "reg") {
    tools::check_user_name( $user_name );
    tools::check_user_password( $password );
    my %clients =tools::reg_user( $user_name,$password );
    tools::rewrite_config( %clients );
}elsif ($action eq "del"){
    tools::del_user( $user_name );
}elsif ($action eq "change"){
    tools::change_password( $user_name, $password );
}
else {die "Тут может быть только 'log', 'reg', 'del' или 'change'.\n"};
