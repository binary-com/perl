#!/bin/bash
set -e

wget http://www.cpan.org/src/5.0/perl-5.24.1.tar.gz
tar xzvf perl-5.24.1.tar.gz
cd perl-5.24.1

./Configure -Dusesitecustomize -Dinc_version_list=none -Dprefix=/home/git/binary-com/perl -Dotherlibdirs=/home/git/regentmarkets/cpan/local/lib/perl5/ -Duselargefiles -Dccflags="-DDEBIAN -D_FORTIFY_SOURCE=2 -g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security" -Dldflags=" -Wl,-z,relro" -Dlddlflags="-shared -Wl,-z,relro" -Dcccdlflags="-fPIC" -Duse64bitint -Dman1dir=none -Dman3dir=none -Dpager=/usr/bin/sensible-pager -Uafs -Ud_csh -Ud_ualarm -Uusesfio -Uusenm -Ui_libutil -DDEBUGGING=-g -Doptimize=-O2 -Duseshrplib -des
make && make test && make install

