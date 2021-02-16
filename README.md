# CheckSocket

![Build Status](https://github.com/jonathanstowe/CheckSocket/workflows/CI/badge.svg)

A very simple Raku function to test if a TCP socket is listening on a given address or
a UNIX domain socket on the specified path

## Description

This module provides a very simple mechanism to determine whether
something is listening on a TCP socket at the given port and address,
or UNIX domain socket at a specified path.  This is primarly for the
convenience of testing where there may be a dependency on an external
network service.  For example:

     use Test;
     use CheckSocket;

     if not check-socket(80, "localhost") {
	      skip-all "no web server";
         exit;
     }

	# or

	use Test;
	use CheckSocket;

	# Start some socket server concurrently
	if wait-socket(80, "localhost") {
		# do some tests
	}
	else {
		skip-all "server didn't start in time";
	}

## Installation

You can install directly with *zef*:

    # From the source directory
   
    zef install .

    # Remote installation

    zef install CheckSocket

## Support

Suggestions/patches are welcomed via github at

https://github.com/jonathanstowe/CheckSocket/issues

## Licence

Please see the LICENCE file in the distribution

© Jonathan Stowe 2015 - 2021
