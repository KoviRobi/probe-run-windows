This is just a simple cross-compiling of
[probe-run](https://github.com/knurling-rs/probe-run) and
[probe-rs-cli](https://probe.rs/) to Windows, for use with WSL2 (using Windows
interop).

The basic idea is you write your code on Linux using WSL2, but use the Windows
executable from this repo as the Cargo runner. If you have WSL2 with interop
enabled, you can execute Windows binaries in WSL2 and have the `stdout` go back
to the WSL2 Linux.

> Note, sometimes especially when using tmux/screen the variable `$WSL_INTEROP`
> might point to the wrong socket, you can do e.g.
> `export WSL_INTEROP=/run/WSL/7_interop` to fix it (point it at an existing
> socket).

To use, just change the `runner` in `.cargo/config` to point to the
`probe-run.exe`, e.g.

    [target.'cfg(all(target_arch = "arm", target_os = "none"))']
    runner = 'path/to/probe-run.exe --chip nRF52840_xxAA'

Because Rust will execute the `probe-run.exe` in the current directory and
provide the executable to flash relative to that, it should just work. But if
for some reason you need to provide paths in WSL that Windows can access you
can use `wslpath -w`.

You shouldn't need to build (because I have the build in the releases) but if
you want to verify you can build, you'll need to use [nix](https://nixos.org),
a package manager that you can install on most Linux systems, e.g. your WSL2
system. Then you can run

    nix build .
    # (or possibly, if it complains about flakes)
    nix --extra-experimental-features 'nix-command flakes' build

in this directory.
