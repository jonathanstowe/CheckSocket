use v6;

=begin pod

=head1 NAME

CheckSocket - test if a socket is listening

=head1 SYNOPSIS

=begin code

     use Test;
     use CheckSocket;

     if not check-socket(80, "localhost") {
        skip-all "no web server";
        exit;
     }

     ...

=end code

=head1 DESCRIPTION

This exports a single function that returns a C<Bool> to indicate whether
something is listening on the specified TCP port or UNIX domain socket:

=head2 check-socket

    multi sub check-socket(Int $port, Str $host = "localhost" --> Bool )
    multi sub check-socket(Str $socket-path --> Bool )

This attempts to connect to the socket specified by $port and $host ( or $socket-path,) and
if succesfull will return C<True> otherwise it will catch any exception
caused by the attempt and return C<False>.   It makes no attempt to
report any reason for the failure so means it is probably not useful
for network diagnosis, it's primary intent is for tests to be able to
determine whether a particular network service is present to test against.

=head2 wait-socket

    multi sub wait-socket( Int $port, Str $host = "localhost", Int $wait = 1, Int $tries = 3 --> Bool )
    multi sub wait-socket( Str $socket-path, Int $wait = 1, Int $tries = 3 --> Bool )

This attempts to connects to the socket specified by $port and $host
(or $socket-path for UNIX domain sockets,) retrying a maximum of $tries
times every $wait second and then returning a Bool to indicate whether
the server is available as C<check-socket>.  This may be useful when you
want to start a server asynchronously in some test code and wait for it
to be ready to use.

=end pod

module CheckSocket:ver<0.0.8>:auth<github:jonathanstowe>:api<1.0> {
    proto sub check-socket(|c) is export { * }
    multi sub check-socket(Int $port, Str $host = "localhost" --> Bool ) is export {
        my Bool $rc = True;
        try {
            my $msock = IO::Socket::INET.new(:$host, :$port);
            CATCH {
                default {
                    $rc = False;
                }
            }
        }
        $rc;
    }

    multi sub check-socket(Str $socket-path --> Bool ) is export {
        my Bool $rc = True;
        try {
            my $msock = IO::Socket::INET.new(host => $socket-path, port => 0, family => PF_UNIX);
            CATCH {
                default {
                    $rc = False;
                }
            }
        }
        $rc;
    }

    proto sub wait-socket(|c) is export { * }
    multi sub wait-socket( Int $port, Str $host = "localhost", Int $wait = 1, Int $tries = 3 --> Bool ) is export {
        my Int $count = $tries;

        while !check-socket($port, $host ) && $count-- {
            sleep $wait
        }
        check-socket($port, $host);
    }
    multi sub wait-socket( Str $socket-path, Int $wait = 1, Int $tries = 3 --> Bool ) is export {
        my Int $count = $tries;

        while !check-socket($socket-path ) && $count-- {
            sleep $wait
        }
        check-socket($socket-path);
    }
}
# vim: expandtab shiftwidth=4 ft=raku
