Automatically build minimal image for running Go binaries, based on Debian stable.

# Intro

```dockerfile
FROM golang AS builder
RUN mkdir /src /app /app/data
WORKDIR /src
RUN --mount=type=bind,target=. go build -o /app/my-app

FROM ronmi/mingo
COPY --from=builder /app /app
WORKDIR /app
ENTRYPOINT ["/app/my-app"]
```

**YOU CAN NOT RUN ANY COMMAND** at final stage.

### Pros

- Really small (~2mb)
- No executables in it, increases security
- Debian based, one of the most stable distro on earth

### Cons

- Hard to extend (no apt/dpkg tools in it)
- Hard to debug (no debugger/less/vim/... in it)
- You can't even mkdir in it (lmao)

# What's in it

- libc6
- ca-certificates
- tzdata (use it with volumes like `-v /etc/timezone:/etc/timezone:ro -v /etc/localtime:/etc/localtime:ro`)

That's all.

# FAQ

### How to build testing/unstable image

Edit `build.sh`, change the line `V=stable`.

### What if I need package X?

For simple package that all dependencies are fulfilled, just add it to `build.sh`. There is a place for you to add packages.

There is also a tool `deps.sh` can query required packages using `apt-cache`. You should try `./deps.sh wget` once.

Some package will not work without properly configurated. You have to handle it by yourself, or just use distro image instead.
