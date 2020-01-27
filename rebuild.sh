#!/bin/bash
set -e

wget http://www.cpan.org/src/5.0/perl-5.26.2.tar.gz
tar xzvf perl-5.26.2.tar.gz
cd perl-5.26.2

# Apply patch for fixing Time::Local tests entering year 2020  (CPAN RT#124787)
curl -fsSL https://rt.cpan.org/Public/Ticket/Attachment/1776857/956088/0001-Fix-Time-Local-tests.patch | patch -p1

./Configure -Dusesitecustomize -Dinc_version_list=none -Dprefix=/home/git/binary-com/perl -Dvendorprefix=/home/git/regentmarkets/cpan/local -Dvendorlib=/home/git/regentmarkets/cpan/local/lib/perl5 -Dvendorarch=/home/git/regentmarkets/cpan/local/lib/perl5/x86_64-linux -Duselargefiles -Dccflags="-DDEBIAN -D_FORTIFY_SOURCE=2 -g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security" -Dldflags=" -Wl,-z,relro" -Dlddlflags="-shared -Wl,-z,relro" -Dcccdlflags="-fPIC" -Duse64bitint -Dman1dir=none -Dman3dir=none -Dpager=/usr/bin/sensible-pager -Uafs -Ud_csh -Ud_ualarm -Uusesfio -Uusenm -Uuseithreads -Uusemultiplicity -Ui_libutil -DDEBUGGING=-g -Doptimize=-O2 -Duseshrplib -des
make && make test && make install

