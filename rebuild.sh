#!/bin/bash
set -e

VERSION=5.36.0

wget http://www.cpan.org/src/5.0/perl-$VERSION.tar.gz
rm -rf perl-$VERSION
tar xzvf perl-$VERSION.tar.gz
cd perl-$VERSION

./Configure -DSILENT_NO_TAINT_SUPPORT -Dusesitecustomize -Dinc_version_list=none -Dprefix=/home/git/binary-com/perl -Dsitelib=/home/git/regentmarkets/cpan-private/local/lib/perl5 -Dsitearch=/home/git/regentmarkets/cpan-private/local/lib/perl5/x86_64-linux  -Dvendorprefix=/home/git/regentmarkets/cpan/local -Dvendorlib=/home/git/regentmarkets/cpan/local/lib/perl5 -Dvendorarch=/home/git/regentmarkets/cpan/local/lib/perl5/x86_64-linux -Duselargefiles -Dccflags="-DDEBIAN -D_FORTIFY_SOURCE=2 -g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security" -Dldflags=" -Wl,-z,relro" -Dlddlflags="-shared -Wl,-z,relro" -Dcccdlflags="-fPIC" -Duse64bitint -Dman1dir=none -Dman3dir=none -Dpager=/usr/bin/sensible-pager -Uafs -Ud_csh -Ud_ualarm -Uusesfio -Uusenm -Uuseithreads -Uusemultiplicity -Ui_libutil -DDEBUGGING=-g -Doptimize=-O2 -Duseshrplib -des
make && make test && make install

