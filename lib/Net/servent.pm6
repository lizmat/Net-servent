use v6.*;

our $s_name    is export(:FIELDS);
our @s_aliases is export(:FIELDS);
our $s_port    is export(:FIELDS);
our $s_proto   is export(:FIELDS);

class Net::servent:ver<0.0.2>:auth<cpan:ELIZABETH> {
    has Str $.name;
    has     @.aliases;
    has Int $.port;
    has Str $.proto;
}

sub populate(@fields) {
    if @fields {
        Net::servent.new(
          name    => ($s_name    = @fields[0]),
          aliases => (@s_aliases = @fields[1]),
          port    => ($s_port    = @fields[2]),
          proto   => ($s_proto   = @fields[3]),
        )
    }
    else {
          $s_name    = Str;
          @s_aliases = ();
          $s_port    = Int;
          $s_proto   = Int;
          Nil
    }
}

my sub getservbyname(Str() $name, Str() $proto) is export(:DEFAULT:FIELDS) {
    use P5getservbyname:ver<0.0.6>:auth<cpan:ELIZABETH>;
    populate(getservbyname($name,$proto))
}

my sub getservbyport(Int:D $port, Str() $proto) is export(:DEFAULT:FIELDS) {
    use P5getservbyname:ver<0.0.6>:auth<cpan:ELIZABETH>;
    populate(getservbyport($port,$proto))
}

my sub getservent() is export(:DEFAULT:FIELDS) {
    use P5getservbyname:ver<0.0.6>:auth<cpan:ELIZABETH>;
    populate(getservent)
}

my proto sub getserv(|) is export(:DEFAULT:FIELDS) {*}
my multi sub getserv(Int:D $addr) is export(:DEFAULT:FIELDS) {
    getservbyport($addr)
}
my multi sub getserv(Str:D $nam) is export(:DEFAULT:FIELDS) {
    getservbyname($nam)
}

my constant &setservent is export(:DEFAULT:FIELDS) = do {
    use P5getservbyname:ver<0.0.6>:auth<cpan:ELIZABETH>;
    &setservent
}
my constant &endservent is export(:DEFAULT:FIELDS) = do {
    use P5getservbyname:ver<0.0.6>:auth<cpan:ELIZABETH>;
    &endservent
}

=begin pod

=head1 NAME

Raku port of Perl's Net::servent module

=head1 SYNOPSIS

    use Net::servent;
    $s = getservbyname('ftp') || die "no service";
    printf "port for %s is %s, aliases are %s\n",
       $s.name, $s.port, "@_aliases[]";
     
    use Net::servent qw(:FIELDS);
    getservbyname('ftp') || die "no service";
    print "port for $s_name is $s_port, aliases are @s_aliases[]\n";

=head1 DESCRIPTION

This module tries to mimic the behaviour of Perl's C<Net::servent> module
as closely as possible in the Raku Programming Language.

This module's exports C<getservbyname>, C<getservbyportd>, and C<getservent>
functions that return C<Net::servent> objects. This object has methods that
return the similarly named structure field name from the C's servent structure
from servdb.h, stripped of their leading "s_" parts, namely name, aliases,
port and proto.

You may also import all the structure fields directly into your namespace as
regular variables using the :FIELDS import tag.  Access these fields as
variables named with a preceding s_ in front their method names. Thus,
$serv_obj.name corresponds to $s_name if you import the fields.

The C<getserv> function is a simple front-end that forwards a numeric argument
to C<getservbyport> and the rest to C<getservbyname>.

=head1 PORTING CAVEATS

This module depends on the availability of POSIX semantics.  This is
generally not available on Windows, so this module will probably not work
on Windows.

=head1 AUTHOR

Elizabeth Mattijsen <liz@wenzperl.nl>

Source can be located at: https://github.com/lizmat/serv-servent . Comments and
Pull Requests are welcome.

=head1 COPYRIGHT AND LICENSE

Copyright 2018,2020 Elizabeth Mattijsen

Re-imagined from Perl as part of the CPAN Butterfly Plan.

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

# vim: expandtab shiftwidth=4
