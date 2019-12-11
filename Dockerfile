FROM ubuntu:bionic

ENV DEBIAN_FRONTEND noninteractive
ENV LANG ja_JP.UTF-8

RUN apt update && \
    apt install -y  \
        language-pack-ja-base \
        language-pack-ja \
        texlive-lang-cjk \
        texlive-fonts-recommended \
        texlive-science \
        latexmk \
        fonts-noto-cjk \
        fonts-noto-cjk-extra &&\
    apt autoremove && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

COPY . /root/

CMD ["/bin/bash"]

