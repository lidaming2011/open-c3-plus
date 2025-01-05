package api::googleplay;
use Dancer ':syntax';
use Dancer qw(cookie);
use Encode qw(encode);
use JSON qw();
use POSIX;
use MIME::Base64;
use api;
use Format;
use uuid;

=pod

googleplay/获取评论列表

=cut

get '/googleplay/review' => sub {
    my $param = params();
#    my $pmscheck = api::pmscheck( 'openc3_ci_read', $param->{groupid} ); return $pmscheck if $pmscheck;

    my @col = qw( review_id device_name comment_time_seconds thumbs_up_count thumbs_down_count reviewer_language app_version_code app_version_name android_os_version star_rating user_comment developer_comment author_name package_name app_package_name callback );
    my $r = eval{ 
        $api::mysql->query( 
            sprintf( "select %s from openc3_ci_googleplay_review", join( ',', @col)), \@col )};


    for my $x ( @$r )
    {
        map{ 
            $x->{$_}  = Encode::decode("utf8", decode_base64( $x->{$_} ) ) if defined $x->{$_}
        }qw( user_comment developer_comment );

    }
    return $@ ? +{ stat => $JSON::false, info => $@ } : +{ stat => $JSON::true, data => $r  };
};

=pod

googleplay/评论上报

=cut

post '/googleplay/review/record' => sub {
    my $param = params();

    my @col = qw( review_id device_name comment_time_seconds thumbs_up_count thumbs_down_count reviewer_language app_version_code app_version_name android_os_version star_rating user_comment developer_comment author_name package_name app_package_name callback );
    my $error = Format->new( 
        map{ ( $_  => [ 'mismatch', qr/'/ ], 1, ) }grep{ !( $_ eq 'user_comment' || $_ eq 'developer_comment' ) }@col
    )->check( %$param );

    return  +{ stat => $JSON::false, info => "check format fail $error" } if $error;
#    my $pmscheck = api::pmscheck( 'openc3_ci_control', $param->{groupid} ); return $pmscheck if $pmscheck;

    my $projectid = $param->{projectid};
    my $user = $api::sso->run( cookie => cookie( $api::cookiekey ), 
        map{ $_ => request->headers->{$_} }qw( appkey appname ));

    map{ $param->{$_}  = encode_base64( encode('UTF-8',  $param->{$_}) ) }qw( user_comment developer_comment );

    eval{ 
        $api::mysql->execute( sprintf ("replace into openc3_ci_googleplay_review ( %s ) values( %s )", join( ',', map{"`$_`"}@col), join( ',', map{ "'$param->{$_}'" }@col ) ));
    };

    return $@ ?  +{ stat => $JSON::false, info => $@ } : +{ stat => $JSON::true };
};

true;
