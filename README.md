# Lunaix OSDK

Ready-to-use Operating System Development Kit (OSDK), provides basic setup of essential tool-chain and peripheral supports for common OS development cycles. I created this because I keep receiving PMs or emails regarding environment setup since the day I started [my OS dev online course](https://github.com/Minep/lunaix-os). I wish this will mitigate and hopefully releasing me from such burdens.

The kit is based on Ubuntu container imaged and is aimed to provide following out-of-box setups:

+ Toochains for cross compiling the OS to bare-metal target.
+ Emulators and debugger for debugging.
+ GUI forwarding for accessing GUI applications (e.g., emulators) from outside of container.

## Basic Usage

**Step 1:** Pull off the image with a tag (see below) of your choice:

```
docker pull lunaixsky/os-devkit:<tag>
```

**Step 2:** Download or simply copy the content of [run.sh](/run.sh) to your local computer, and bootstrap it by invoking:

```
./run.sh --x11 -it lunaixsky/os-devkit:<tag> -- <cmd>
```

Where `<cmd>` is arbitrary command that you wish to execute after the container started. For example, you can plug `bash` in here if you want a tour. Other possibility such as vscode devcontainer integration is also achievable.

**Note:** the `run.sh` is essential, which in this case handles all X11 tricks and warts that ensure GUI forwarding works as expected.

Basic usage of `run.sh`:

```
./run.sh [OPTIONS ...] [DOCKER RUN OPTIONS ...] IMAGE_NAME [-- [COMMANDS ...]]

OPTIONS:
    --x11   use x11 forwarding (works with image configured to use x11)

DOCKER RUN OPTIONS:
    ...     Any valid docker run options

IMAGE_NAME:
    The image that you wish to run

COMMANDS:
    ...     Command executed when start up
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

+ i386-gcc_x11_v1.0
+ (TBC)

## Issues

Open an issue if your encounter any setup related problem.
