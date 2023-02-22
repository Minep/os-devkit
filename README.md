# Lunaix OSDK

[![docker](https://img.shields.io/docker/pulls/lunaixsky/os-devkit?style=for-the-badge)](https://hub.docker.com/r/lunaixsky/os-devkit)

Ready-to-use Operating System Development Kit (OSDK), provides basic setup of essential tool-chain and peripheral supports for common OS development cycles. I created this because I keep receiving PMs or emails regarding environment setup since the day I started [my OS dev online course](https://github.com/Minep/lunaix-os). I wish this will mitigate and hopefully releasing me from such burdens.

The kit is based on Ubuntu container image and is aimed to provide following out-of-box setups:

+ Toochains for cross compiling the OS to bare-metal target.
+ Emulators and debugger for debugging.
+ GUI forwarding for accessing GUI applications (e.g., emulators) from outside of container.

## Quick Start

Suppose you are about to develop an OS targeting x86_32. There are two method to access the kit that allow GUI applications (such as emulators) to work as expected.

### OSDK via VNC


**Step 1:** Pull the OSDK built for VNC connection, this build is specified by tag `i386-gcc_vnc_v1.0`. Other build also available.

```
sudo docker pull lunaixsky/os-devkit:i386-gcc_vnc_v1.0
```

**Step 2:** Invoking

```
sudo docker run -td -p 5900:5900 lunaixsky/os-devkit:i386-gcc_vnc_v1.0
```

You can also pass additional arguments into container, such as setting the resolution of your remote desktop (size of frame buffer) or additional parameters to vnc server. For example, change the resolution to `1920x1080`:

```
sudo docker run -td -p 5900:5900 lunaixsky/os-devkit:i386-gcc_vnc_v1.0 --res=1920x1080
```

More detailed usage on container options can be found in next section.

**Step 3:**

Start your favourite VNC client and connect to `127.0.0.1:5900` to use the kit. The desktop environment is the minimum installation of `xfce`.

### OSDK via X11

**Step 1:** Pull the OSDK built for VNC connection, this build is specified by tag `i386-gcc_x11_v1.0`. Other build also available.

```
sudo docker pull lunaixsky/os-devkit:i386-gcc_x11_v1.0
```

**Step 2:** Download or simply copy the content of [run.sh](/run.sh) to your local computer, and bootstrap it by invoking:

```
./run.sh --x11 -td lunaixsky/os-devkit:i386-gcc_x11_v1.0
```

**Note:** the `run.sh` is essential, which in this case handles all X11 tricks and warts that ensure GUI forwarding works as expected.

The detailed usage of `run.sh` can be found in next section

**Step 3:**

Now, the OSDK container will be running in background. You can simple attach a shell session to it using `docker exec`, or use it as devcontainer by attaching to it in vscode, see [here](https://code.visualstudio.com/docs/devcontainers/attach-container#_attach-to-a-docker-container) for more detailed instruction on how to do it.

## Basic Usage

### Basic usage of `run.sh`

```
./run.sh [OPTIONS ...] [DOCKER RUN OPTIONS ...] IMAGE_NAME [ARGS]

OPTIONS:
    --x11       use x11 forwarding (works with image configured to use x11)
    --export    print docker un arguments (useful to export x11 config)

DOCKER RUN OPTIONS:
    ...     Any valid docker run options

IMAGE_NAME:
    The image that you wish to run

ARGS:
    ...     Arguments to entrypoint script (see below)
```

### Additional options to container

The entrypoint scripts is executed immediately after container startup, which will performs essential initialization and configuration of environment. Arguments can be passed to customize this step:

```
[OPTION ...] [-- [COMMANDS ...]]

OPTION:
    --vnc-args=[...]    additional arguments to vnc server (see man page for x11vnc)
    --res=WxH           set the frame buffer with size width (W) and height (H), in pixels. 
                        Default to 1280x720

COMMANDS:
    ...                 command to execute in post stage.
```

## Tags of the Day

All tags follow the same pattern:

```
<arch>-<toolchain>_<forwarding method>_<version>
```

For example: `i386-gcc_x11_v1.0` stands for:

+ Targeted to i386 architecture (x86_32)
+ GCC as cross compiling toolchain
+ GUI is forwarded to host via vanilla X11
+ version 1.0

A list of all currently supported tags given below:

+ `i386-gcc_x11_v1.0`
+ `i386-gcc_vnc_v1.0`

## Built-in Software

Each container will contains the following packages/software for OS development assistance:

+ Cross-compiling toolchain
+ Packaging toolchain
  + xorriso
  + grub2
+ Emulators:
  + Bochs (for x86 build)
  + QEMU (all platform build)
+ git
+ libgtk-3-dev
+ xfce4-terminal
+ x11vnc, xvfb, xfce4 (for vnc remote desktop)

## Issues

Open an issue if your encounter any setup related problem.
