FROM ubuntu:jammy AS builder

RUN mkdir /os-tmp /os-env 

COPY ./os-tmp/* /os-tmp
COPY ./os-env/* /os-env

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
		build-essential \
		bison\
		flex\
		libgmp3-dev\
		libmpc-dev\
		libmpfr-dev\
        libcapstone-dev\
        libvte-dev\
		texinfo\
        libgtk-3-dev\
        ninja-build\
        wget

WORKDIR /os-tmp

ENV PREFIX /os-env

RUN chmod +x *.sh
RUN ./build-env.sh


FROM ubuntu:jammy

RUN mkdir /os-dev /os-env

COPY --from=builder /os-env/ /os-env/
COPY ./os-dev/* /os-dev

ARG frwd_method
ENV FRWD_METHOD="${frwd_method}"
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/os-env/bin:${PATH}"

RUN apt-get update && \
    apt-get install -y \
        build-essential \
        libgtk-3-0\
        libcapstone4\
        libvte9\
        git\
        xorriso\
        grub2-common\
        xfce4-terminal

RUN chmod +x /os-env/setup.sh
RUN chmod +x /os-env/entry.sh
RUN /os-env/setup.sh

WORKDIR /os-dev

ENTRYPOINT [ "/os-env/entry.sh" ]