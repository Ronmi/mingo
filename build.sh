#!/bin/bash

rm -fr img || true
mkdir img

S=http://deb.debian.org/debian
A=amd64
V=stable

if [[ $REPO != "" ]]
then
    S="$REPO"
fi
if [[ $ARCH != "" ]]
then
    A="$ARCH"
fi

echo "using repository $S"
echo "use verion $V and architecture $A"

pkgs="$(wget -q -O - "${S}/dists/${V}/main/binary-${A}/Packages.gz" | zcat)"

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

inst all ca-certificates  # use "all" to install arch independent package
inst "$A" libc6           # use "$A" for arch dependent package
inst all tzdata

# add custom packge here
# example:
# inst "$A" libssl1.1

# move certificates
for i in `find img/usr/share/ca-certificates -name '*.crt'`
do
    fn=$(basename "$i" | sed 's/\.crt/.pem/')
    mv "$i" "img/etc/ssl/certs/$fn"
done

# remove unneeded files
# take extra care if you have installed some other packages
rm -fr img/usr/{lib,libexec,bin,sbin,games,include,src,share/doc,share/man}
