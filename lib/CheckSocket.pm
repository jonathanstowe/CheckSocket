use v6;

module CheckSocket {
    sub check-socket(Int $port, Str $host = "localhost") returns Bool is export {
        my Bool $rc = True;
        try {
            my $msock = IO::Socket::INET.new(host => $host, port => $port);
            CATCH {
                default {
                    $rc = False;
                }
            }
        }
        $rc;
    }
}
# vim: expandtab shiftwidth=4 ft=perl6
