#!/bin/bash
set -e

if [ -z "$VERSION" ]; then
    echo "No VERSION environment variable set. Exiting..."
    exit 1
fi
echo "Building perl version $VERSION"
rm -rf bin lib man
wget http://www.cpan.org/src/5.0/perl-$VERSION.tar.gz
rm -rf perl-$VERSION
tar xzvf perl-$VERSION.tar.gz
cd perl-$VERSION

# Apply patch for fixing Time::Local tests entering year 2020  (CPAN RT#124787)
zcat ../patches/0001-Fix-Time-Local-tests.patch.gz | patch -p1 --verbose || exit 1

# Apply patch for fixing gcc 10 problem  https://github.com/openwrt/packages/pull/12178
patch -Np1 < ../patches/999-fix-build-failure-against-gcc-10.patch

#We defined `-Dusesitecustomize` and removed `-Dusethreads`. Most of other parameters are copied from `perl -V | grep config_args`
./Configure -Dusesitecustomize -Dinc_version_list=none -Dprefix=/home/git/binary-com/perl -Dsitelib=/home/git/regentmarkets/cpan-private/local/lib/perl5 -Dsitearch=/home/git/regentmarkets/cpan-private/local/lib/perl5/x86_64-linux  -Dvendorprefix=/home/git/regentmarkets/cpan/local -Dvendorlib=/home/git/regentmarkets/cpan/local/lib/perl5 -Dvendorarch=/home/git/regentmarkets/cpan/local/lib/perl5/x86_64-linux -Duselargefiles -Dccflags="-DDEBIAN -D_FORTIFY_SOURCE=2 -g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security" -Dldflags=" -Wl,-z,relro" -Dlddlflags="-shared -Wl,-z,relro" -Dcccdlflags="-fPIC" -Duse64bitint -Dman1dir=none -Dman3dir=none -Dpager=/usr/bin/sensible-pager -Uafs -Ud_csh -Ud_ualarm -Uusesfio -Uusenm -Uuseithreads -Uusemultiplicity -Ui_libutil -DDEBUGGING=-g -Doptimize=-O2 -Duseshrplib -des
make && make test && make install

# cpanm is App::cpanminus, not perl core, so `make install` does not provide
# it and every rebuild would otherwise drop it. The INSTALLSITE* overrides are
# required: Configure points sitelib/sitearch at cpan-private, so an unforced
# install lands outside the prefix and never reaches this repo.
PREFIX=/home/git/binary-com/perl
ARCH=$($PREFIX/bin/perl -MConfig -e 'print $Config{archname}')
export PERL_MM_OPT="INSTALLSITELIB=$PREFIX/lib/site_perl/$VERSION INSTALLSITEARCH=$PREFIX/lib/site_perl/$VERSION/$ARCH INSTALLSITEBIN=$PREFIX/bin INSTALLSITESCRIPT=$PREFIX/bin"
curl -L https://cpanmin.us | $PREFIX/bin/perl - App::cpanminus
unset PERL_MM_OPT

# cpanm writes its install metadata next to Config{sitearch}, i.e. under
# cpan-private, not under the prefix. Copy it back so the tree matches what
# a direct install would look like. Non-fatal: it is only metadata.
META=$($PREFIX/bin/perl -MConfig -e 'print $Config{sitearch}')/.meta
[ -d "$META" ] && cp -a "$META" "$PREFIX/lib/site_perl/$VERSION/$ARCH/" || true

test -x $PREFIX/bin/cpanm

