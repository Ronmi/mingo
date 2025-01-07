#!/bin/bash

rm -fr img/usr img/etc img/lib img/lib64

S=http://deb.debian.org/debian
A=amd64

if [[ $REPO != "" ]]
then
    S="$REPO"
fi
if [[ $ARCH != "" ]]
then
    A="$ARCH"
fi

echo "using repository $S"
echo "commit as $T"

pkgs="$(wget -q -O - "${S}/dists/stable/main/binary-${A}/Packages.gz" | zcat)"

function inst {
    rm -f dest.deb
    DEB="${S}/$(echo "$pkgs" | grep -F "/${2}_" | grep -F Filename | cut -d ' ' -f 2)"

    echo "Downloading $DEB"
    wget -q -O dest.deb "$DEB"
    if [[ $? != 0 ]]
    then
	rm dest.deb
	exit 1
    fi

    echo "extracting"
    dpkg-deb -x dest.deb img/
    rm dest.deb
}

inst all ca-certificates
inst "$A" libc6
inst all tzdata

# move certificates
for i in `find img/usr/share/ca-certificates -name '*.crt'`
do
    fn=$(basename "$i" | sed 's/\.crt/.pem/')
    mv "$i" "img/etc/ssl/certs/$fn"
done
rm -fr img/usr/{lib,libexec,bin,sbin,games,include,src}

