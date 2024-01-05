#!/usr/bin/perl
use strict;
use warnings;
use lib '/Users/evgenijtretakov/PerlProject/tasks/tools';
use tools;

my( $action, $user_name, $password, $change_password )= @ARGV;

if ( $action eq "log" ) {
    tools::login( $user_name,$password );
} elsif ( $action eq "reg" && @ARGV==3 ) {
    tools::check_user_name( $user_name );
    tools::check_user_password( $password );
    my %clients =tools::reg_user( $user_name,$password );
    tools::rewrite_config( %clients );
}elsif ( $action eq "del" && @ARGV==2 ){
    tools::del_user( $user_name );
}elsif ( $action eq "change" && @ARGV==3 ){
    tools::change_password( $user_name, $password );
}elsif ( $action eq "-h" ){
    tools::help();
}
else{tools::help();
}
