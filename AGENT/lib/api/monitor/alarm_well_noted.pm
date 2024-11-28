package api::monitor::alarm_well_noted;
use Dancer ':syntax';
use Dancer qw(cookie);
use Encode qw(encode);

use JSON qw();
use POSIX;
use api;
use Format;
use Digest::MD5;

=pod

监控系统/获取告警知晓

=cut

get '/monitor/alarm_well_noted' => sub {
    my @col = qw( caseuuid user );

    my $r = eval{ $api::mysql->query( sprintf( "select %s from openc3_monitor_alarm_well_noted", join( ',', @col)), \@col )}; 
    return +{ stat => $JSON::false, info => $@ } if $@;

    my %res;
    for( @$r ) { $res{$_->{caseuuid}} = $_->{user}; }
    return +{ stat => $JSON::true, data => \%res };
};

=pod

监控系统/提交告警知晓

=cut

post '/monitor/alarm_well_noted' => sub {
    my $param = params();
    my $error = Format->new( 
        uuid => qr/^[a-zA-Z0-9:\.T\-,]+$/, 1,
    )->check( %$param );

    return  +{ stat => $JSON::false, info => "check format fail $error" } if $error;
 
    my $user = $api::sso->run( cookie => cookie( $api::cookiekey ), map{ $_ => request->headers->{$_} }qw( appkey appname ) );

    eval{
        map{
            $api::mysql->execute( "replace into openc3_monitor_alarm_well_noted ( user,caseuuid ) values('$user','$_')" );
        }grep{ $_ }split /,/, $param->{uuid};
     };
    return $@ ? +{ stat => $JSON::false, info => $@ } : +{ stat => $JSON::true };
};

=pod

监控系统/获取告警知晓告警值班人

=cut

get '/monitor/alarm_well_noted_oncall' => sub {

    my %res;
    map{ $res{ "level$_" } = "null" }  1 ..3 ;
    if( -f '/data/glusterfs/oncall/data/wellnoted' )
    {
	map{ my $x = `c3mc-app-usrext '%wellnoted:$_'`; chomp $x, $res{"level$_"} = $x;  }1..3;
    }
    return +{ stat => $JSON::true, data => \%res };
};

true;
