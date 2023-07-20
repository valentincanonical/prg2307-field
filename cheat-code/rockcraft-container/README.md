> **_NOTE:_**  EXPERIMENTAL

Source code: <https://github.com/cjdcordeiro/rockcraft-container>

Dockerfile: <https://github.com/cjdcordeiro/rockcraft-container/blob/main/Dockerfile>

# rockcraft-container
Building a ROCK from within a container image.

**This is not recommended, but if you must :) ...**

Why shouldn't you use this image in production?

 - Snaps are not supported in Docker container environments
 - there's nested virtualization (with LXD running inside the container), so
there is room for things to go room, and this image hasn't been tested past the
most simple use cases
 - it needs to run in `--privileged` mode, which is not recommended

You've been warned, so continue reading at your own risk.

## Build

To build this image, simply run

```bash
$ docker build -t rockcraft-image:test .
```

## Usage

The container will, at each execution, install LXD and Rockcraft.

To run the container, do:

```bash
# This hasn't been tested with other container management tools
$ docker run --privileged -it ccordeiro/rockcraft:latest help
+ args=help
+ sed -i '0,/REPLACEME/ s/REPLACEME/help/' /usr/local/bin/entrypoint.sh
+ touch /tmp/log
+ exec /lib/systemd/systemd --system --system-unit entrypoint.service --show-status=true
+ tail -f /tmp/log
systemd 249.11-0ubuntu3.6 running in system mode (+PAM +AUDIT +SELINUX +APPARMOR +IMA +SMACK +SECCOMP +GCRYPT +GNUTLS +OPENSSL +ACL +BLKID +CURL +ELFUTILS +FIDO2 +IDN2 -IDN +IPTC +KMOD +LIBCRYPTSETUP +LIBFDISK +PCRE2 -PWQUALITY -P11KIT -QRENCODE +BZIP2 +LZ4 +XZ +ZLIB +ZSTD -XKBCOMMON +UTMP +SYSVINIT default-hierarchy=unified)
Detected virtualization docker.
Detected architecture x86-64.

Welcome to Ubuntu 22.04.1 LTS!

Queued start job for default target Multi-User System.
[  OK  ] Reached target Path Units.
(...)
[  OK  ] Reached target Multi-User System.
INFO: Setting up the environment for Rockcraft...
INFO: Installing the LXD snap from 5.9/stable
2023-02-10T15:08:41Z INFO Waiting for automatic snapd restart...
lxd (5.9/stable) 5.9-9879096 from Canonical✓ installed
WARNING: There is 1 new warning. See 'snap warnings'.
INFO: Installing Rockcraft from the 'edge' channel
rockcraft (edge) 0+git.70807c3 from Sergio Schvezov ⭐ (sergiusens) installed
WARNING: There is 1 new warning. See 'snap warnings'.
INFO: Initializing LXD...
INFO: Executing: 'rockcraft help'
Usage:
    rockcraft [help] <command>

Summary:    A tool to create OCI images

Global options:
       -h, --help:  Show this help message and exit
    -v, --verbose:  Show debug information and be more verbose
      -q, --quiet:  Only show warnings and errors, not progress
      --verbosity:  Set the verbosity level to 'quiet', 'brief',
                    'verbose', 'debug' or 'trace'
    -V, --version:  Show the application version and exit

Starter commands:

Commands can be classified as follows:
        Lifecycle:  build, clean, overlay, pack, prime, pull, stage
            Other:  init

For more information about a command, run 'rockcraft help <command>'.
For a summary of all commands, run 'rockcraft help --all'.
(...)
```

 - `-it`: it is important to run the container with a pseudo-TTY, as Rockcraft
is being executed as a `systemd` service, and forwarding all output to `tty`. So
if you don't set this option at runtime, all will go well but you won't see
Rockcraft's logs.

### Building a ROCK

To build a ROCK, you need to pass the `rockcraft.yaml` file.

```bash
# Assuming your Rockcraft project is located at $PWD
$ docker run --privileged -it -v $PWD:/workdir ccordeiro/rockcraft:latest
(...)
INFO: Setting up the environment for Rockcraft...
INFO: Installing the LXD snap from 5.9/stable
2023-02-10T15:14:14Z INFO Waiting for automatic snapd restart...
lxd (5.9/stable) 5.9-9879096 from Canonical✓ installed
WARNING: There is 1 new warning. See 'snap warnings'.
INFO: Installing Rockcraft from the 'edge' channel
rockcraft (edge) 0+git.70807c3 from Sergio Schvezov ⭐ (sergiusens) installed
WARNING: There is 1 new warning. See 'snap warnings'.
INFO: Initializing LXD...
INFO: Executing: 'rockcraft '
Launching instance...
Retrieving base ubuntu:22.04
Retrieved base ubuntu:22.04 for amd64
Extracting ubuntu:22.04
Extracted ubuntu:22.04
Initializing parts lifecycle
Executing parts lifecycle
Executing parts lifecycle: pull my-part
Executed: pull my-part
Executing parts lifecycle: pull pebble
Executed: pull pebble
Executing parts lifecycle: overlay my-part
Executed: overlay my-part
Executing parts lifecycle: overlay pebble
Executed: overlay pebble
Executing parts lifecycle: build my-part
Executed: build my-part
Executing parts lifecycle: build pebble
Executed: build pebble
Executing parts lifecycle: stage my-part
Executed: stage my-part
Executing parts lifecycle: stage pebble
Executed: stage pebble
Executing parts lifecycle: prime my-part
Executed: prime my-part
Executing parts lifecycle: prime pebble
Executed: prime pebble
Executed parts lifecycle
Creating new layer
Created new layer
Adding metadata
Configuring labels and annotations...
Labels and annotations set to ['org.opencontainers.image.version=0.1', 'org.opencontainers.image.title=my-rock-name', 'org.opencontainers.image.ref.name=my-rock-name', 'org.opencontainers.image.licenses=GPL-3.0', 'org.opencontainers.image.created=2023-02-10T15:18:51.382191+00:00', 'org.opencontainers.image.base.digest=9a0bdde4188b896a372804be2384015e90e3f84906b750c1a53539b585fbbe7f']
Setting the ROCK's Control Data
Control data written
Metadata added
Exporting to OCI archive
Exported to OCI archive 'my-rock-name_0.1_amd64.rock'
(...)
```

Once the build finishes, you'll find some new files in your `$PWD`, such as:

```
...
rockcraft-20230210-151320.348647.log
my-rock-name_0.1_amd64.rock    # Your ROCK!
...
```

To see how to use the ROCK file, please refer to the
[Rockcraft project](https://github.com/canonical/rockcraft).


# References

- <https://github.com/diddlesnaps/snapcraft-container>
