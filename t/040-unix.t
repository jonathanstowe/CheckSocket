use v6;

use Test;

plan 2;

use CheckSocket;

my $socket-path = $*TMPDIR.add($*PROGRAM.basename ~ $*PID).Str;

ok(!check-socket($socket-path), "check-socket - socket $socket-path server not started");

diag "start server on $socket-path";

my $p = Promise.new;


start {
    my $socket = IO::Socket::INET.new(localhost => $socket-path, localport => 0, listen => True, family => PF_UNIX);
    $p.keep;
    loop {
        my $client = $socket.accept;
    }
}

await $p;

ok(check-socket($socket-path), "check-socket on $socket-path");

$socket-path.IO.unlink;

# vim: expandtab shiftwidth=4 ft=raku
