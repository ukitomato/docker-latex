FROM alpine:latest

COPY texlive.profile .

ENV PATH /usr/local/texlive/2020/bin/x86_64-linuxmusl:$PATH

RUN apk add --no-cache curl perl fontconfig-dev freetype-dev && \
    apk add --no-cache --virtual .fetch-deps xz tar wget && \
    mkdir /tmp/install-tl-unx && \
    curl -L ftp://tug.org/historic/systems/texlive/2020/install-tl-unx.tar.gz | \
    tar -xz -C /tmp/install-tl-unx --strip-components=1 && \
    /tmp/install-tl-unx/install-tl \
    --profile texlive.profile \
    --repository http://ftp.jaist.ac.jp/pub/CTAN/systems/texlive/tlnet/ && \
    tlmgr install latexmk comment url siunitx && \
    rm -fr /tmp/install-tl-unx && \
    apk del .fetch-deps

WORKDIR /working

CMD ["/bin/ash"]





