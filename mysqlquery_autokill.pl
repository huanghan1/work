#!/usr/bin/perl
use utf8;
my @lines;
system('ps -ef | grep -v awk | awk \'/pt-kill/{system("kill -9 " $2)}\'');
#walking
$lines[1] =  'rm-uf68xkh6642410391.mysql.rds.aliyuncs.com walking 0pJEYXaYRq27Wgmm 8';
$lines[2] =  'rr-uf6n1y17d142d24wy.mysql.rds.aliyuncs.com walking 0pJEYXaYRq27Wgmm 8';
$lines[3] =  'rr-uf6a96g22f8x1o683.mysql.rds.aliyuncs.com walking 0pJEYXaYRq27Wgmm 8';

foreach (@lines) {
    chomp;
    my @fields = split(/\s+/);
    my $time;
    if(scalar(@fields) >= 3) {
        my $logfile = (split(/\./, $fields[0]))[0];
        my $cmd;
        $time = $fields[3]; 
        if ( $time < 1 ) {
            $time = 15;
        }

        if( $fields[0] =~  /^rr/ ) {
            $cmd = "kill-query";
        } else {
            $cmd = "kill-query";
        }

        system("pt-kill",
            "--host", $fields[0],
            "--user", $fields[1],
            "--password", $fields[2],
            "--no-version-check",
            "--victims", "all",
            "--busy-time", $time,
            "--interval", 5,
            "--$cmd",
            "--print",
            "--log", "/tmp/${logfile}.log",
            "--daemonize")
    }

}
#exit;

foreach (@lines) {
    chomp;
    my @fields = split(/\s+/);
    my $time;
    if(scalar(@fields) >= 3) {
        my $logfile = (split(/\./, $fields[0]))[0];
        $time = 1;

        system("pt-kill",
            "--host", $fields[0],
            "--user", $fields[1],
            "--password", $fields[2],
            "--no-version-check",
            "--victims", "all",
            "--busy-time", $time,
            "--interval", 3,
            "--print",
            "--log", "/tmp/slowsql__${fields[0]}__${fields[1]}__.log",
            "--daemonize")
    }
}

