Automatically build minimal Debian GNU/Linux image for running Go binaries.

# What's in it

- libc6
- ca-certificates

# FAQ

### How to build testing/unstable image

Edit `build.sh`.

### What if I need package X?

`build.sh` provides a helper function to download and extract packages (using `wget` and `dpkg-deb -x`)

```sh
# inst arch pkgname
inst amd64 wget
```

And a helper to recursively extract package dependencies with `apt-cache`

```sh
# only required packages are shown
./deps.sh wget curl
```

Some packages will not work properly without valid config, which was mostly in post-install script. Now you have to handle it yourself.
