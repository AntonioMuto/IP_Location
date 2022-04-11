use LWP::Simple;
$number_args = $#ARGV + 1;
%info;
if($number_args > 1){
    die "INSERIRE SOLAMENTE UN IP"
}
$ip = $ARGV[0];
$ua = LWP::UserAgent->new();
$content = $ua->get("https://iplogger.org/ip-lookup/?d=$ip");
$found = $content->content;
open($fh, ">", "Ip.txt");
    print $fh $found;
close $fh;
$ERROR = 0;
open($fh, "<", "Ip.txt");
    while(<$fh>){
        if($_ =~ /is\s+not\s+a\s+valid\s+IP\s+address/){
            $ERROR = 1;
        }
        if($_ =~ /map\((\d+.\d+),\s+(\d+.\d+),\s+{'country':\s'(\w+)',/){
            $info{"Country: $3 "} = "$1 $2\n" if not exists $info{"Country: $3"};
        }
        if($_ =~ /&nbsp;<img src='\/i\/city.png' title='City' alt='City'>\s+(\w+)/){
            $info{"City: "} = "$1\n" if not exists $info{"City"};
        }
        if($_ =~ /&nbsp;<img src='\/i\/region.png' title='Region' alt='Region'>\s+((\w+)-(\w+)|(\w+))/){
            $info{"Region: "} = "$1\n" if not exists $info{"Region"};
        }
        if($_ =~ /&nbsp;<img src='\/i\/datetime.png' title='Provider' alt='Provider'>\s(\d+\.\d+\.\d+\s+\d+\:\d+\:\d+)/){
            $info{"DateTime: "} = "$1\n" if not exists $info{"DateTime"};
        }
    }
close $fh;
if($ERROR == 1){
    print "IP LOCATION: \n";
    print "\n";
    print "ERRORE: $ip NON E' UN IP VALIDO\n"
}
else{
    print "IP LOCATION: \n";
    print "\n";
    print %info;
}