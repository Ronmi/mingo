Simple script to build minimal GNU/Linux image for running Go binaries.

```bash
env REPO=http://deb.debian.org/debian TAG=your_org/your_img ./build.sh
```

Default values:

- REPO=http://deb.debian.org/debian
- TAG=ronmi/mingo

You should always set `TAG` since you don't have my docker login credentials :P
