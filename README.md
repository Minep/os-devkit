<p align="center">
  <img width="300" src="/imgs/osdk.png">
</p>

<p align="center">
  <a href="#">简体中文</a> | <a href="README_en.md">English</a>
</p>

# Lunaix OSDK

[![docker](https://img.shields.io/docker/pulls/lunaixsky/os-devkit?style=for-the-badge)](https://hub.docker.com/r/lunaixsky/os-devkit)

Lunaix操作系统开发套件（OSDK）包含了基本的交叉编译工具链配置，以及其他实用的小工具，能够满足基本的操作系统开发需求，如编译，打包，调式。

该开发套件是基于Ubuntu容器镜像（Ubuntu jammy），包含了如下的功能：

+ 裸机交叉编译器
+ 用于调试的模拟器和调试器
+ GUI转发，用于运行如同模拟器这些具有用户界面的应用。

## 快速开始

以开发一个针对x86_32架构的OS为例，OSDK的使用可以通过两种方式：

1. 基于VNC远程桌面的访问，该访问方式适合非Unix用户使用
2. 基于X11的GUI转发，非常推荐使用X11作为窗口管理器的用户使用，以获得无缝体验。

### 通过VNC访问


**Step 1:** 根据你的OS开发需求，拉取合适的OSDK镜像，不同的版本OSDK由tag来识别，在这里，针对x86_32平台工具链构建的OSDK为 `i386-gcc_vnc_v1.0`。

```
sudo docker pull lunaixsky/os-devkit:i386-gcc_vnc_v1.0
```

**Step 2:** 运行该镜像，同时开放VNC的5900端口

```
sudo docker run -td -p 5900:5900 lunaixsky/os-devkit:i386-gcc_vnc_v1.0
```

你也可以往镜像内传入额外的参数，比如可以设置远程桌面的分辨率（即frame buffer的大小）或者是针对VNC服务器的额外选项。举个例子，我们可以将远程连接的分辨率改为1920x1080：

```
sudo docker run -td -p 5900:5900 lunaixsky/os-devkit:i386-gcc_vnc_v1.0 --res=1920x1080
```

更多关于这类容器参数的用途会在下一节中进行完全介绍。

**Step 3:**

使用VNC客户端链接`127.0.0.1:5900`，OSDK包含最小安装的`xfce`桌面环境。

### 通过X11访问

**Step 1:** 拉取适用于x11的OSDK：`i386-gcc_x11_v1.0`

```
sudo docker pull lunaixsky/os-devkit:i386-gcc_x11_v1.0
```

**Step 2:** 下载 [run.sh](/run.sh)，然后使用其去运行镜像

```
./run.sh --x11 -td lunaixsky/os-devkit:i386-gcc_x11_v1.0
```

**注意：** 该脚将会负责配置主机的X11服务器，以便容器进行桥接。

`run.sh`也包含一切其他的功能，请参考下一节。

如果你懒得下载这个脚本，你也可以通过一下步骤手动对X11服务器进行配置，并且运行镜像：

```
export _XSOCK=/tmp/.X11-unix
export _XAUTH=/tmp/.docker.xauth
xauth nlist "$DISPLAY" | sed -e 's/^..../ffff/' | xauth -f "$XAUTH" nmerge -
sudo docker run -v "$_XSOCK:$_XSOCK" -v "$_XAUTH:$_XAUTH" \
    -e "XAUTHORITY=$_XAUTH" -e "DISPLAY=$DISPLAY" \
    -td lunaixsky/os-devkit:i386-gcc_x11_v1.0
```

**Step 3:**

这时，OSDK应该会在后台运行。您可以使用`docker exec`挂载一个shell回话到OSDK容器，或者使用vscode的devcontainer功能连接到OSDK以进行远程开发，关于devcontainer的具体用法请参考[这里](https://code.visualstudio.com/docs/devcontainers/attach-container#_attach-to-a-docker-container)。

## 一些基本用法

### `run.sh`用法

```
./run.sh [OPTIONS ...] [DOCKER RUN OPTIONS ...] IMAGE_NAME [ARGS]

OPTIONS:
    --x11       使用x11转发
    --export    导出docker run的配置选项

DOCKER RUN OPTIONS:
    ...     任何docker run选项

IMAGE_NAME:
    需要运行的镜像名称

ARGS:
    ...     传入容器的选项
```

### 容器选项

容器在启动时会运行入口点脚本进行初始化工作，您可以传入一些额外的选项来控制这一初始化过程。

```
[OPTION ...] [-- [COMMANDS ...]]

OPTION:
    --vnc-args=[...]    传入VNC服务器的额外指令（详见x11vnc的man界面）
    --res=WxH           设置frame buffer大小（渲染分辨率），宽度W和高度H，以像素为单位。 
                        默认为1280x720

COMMANDS:
    ...                 在初始化完成之后执行的任意命令
```

## 可供使用的OSDK们

不同的OSDK有着不同的用途和配置，由镜像的tag来区分，并遵循以下格式：

```
<架构>-<构建工具链>_<GUI转发方式>_<版本>
```

举个例子: `i386-gcc_x11_v1.0` 描述的是这样一个容器:

+ 针对x86_32处理器架构的交叉编译器
+ 使用GCC作为构建工具链
+ 使用X11进行GUI转发
+ 版本 1.0

目前可供选择的OSDK:

+ `i386-gcc_x11_v1.0`
+ `i386-gcc_vnc_v1.0`

## OSDK封装的软件

下面描述一个OSDK会封装的软件列表：

+ 交叉编译工具链
+ OS镜像打包工具链
  + xorriso
  + grub2
+ 模拟器:
  + Bochs (仅限x86平台)
  + QEMU
+ git
+ libgtk-3-dev
+ xfce4-terminal
+ x11vnc, xvfb, xfce4 (仅限vnc转发方式)

## Issue和建议

如有任何问题或建议，欢迎提issue。

贡献请发Pull Request