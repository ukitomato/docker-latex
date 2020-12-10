FROM alpine:latest

COPY texlive.profile .

RUN apk add --no-cache curl perl fontconfig-dev freetype-dev && \
    apk add --no-cache --virtual .fetch-deps xz tar wget && \
    mkdir /tmp/install-tl-unx && \
    curl -L ftp://tug.org/historic/systems/texlive/2020/install-tl-unx.tar.gz | \
    tar -xz -C /tmp/install-tl-unx --strip-components=1 && \
    /tmp/install-tl-unx/install-tl \
    --profile texlive.profile \
    --repository http://mirror.ctan.org/systems/texlive/tlnet/ && \
    tlmgr install \
    latexmk && \
    curl -O https://noto-website-2.storage.googleapis.com/pkgs/NotoSansCJKjp-hinted.zip && \
    mkdir -p /usr/share/fonts/NotoSansCJKjp && \
    unzip NotoSansCJKjp-hinted.zip -d /usr/share/fonts/NotoSansCJKjp/ && \
    fc-cache -fv && \
    rm NotoSansCJKjp-hinted.zip && \
    rm -fr /tmp/install-tl-unx && \
    apk del .fetch-deps

ENV PATH /usr/local/texlive/2020/bin/x86_64-linuxmusl:$PATH

WORKDIR /working

CMD ["/bin/ash"]





