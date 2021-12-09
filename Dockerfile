FROM alpine:latest

COPY texlive.profile .

ENV PATH /usr/local/texlive/2021/bin/x86_64-linuxmusl:$PATH

RUN apk add --no-cache perl fontconfig-dev freetype-dev && \
    apk add --no-cache --virtual .fetch-deps curl wget xz tar build-base perl-dev perl-app-cpanminus && \
    cpanm YAML::Tiny File::HomeDir Unicode::GCString && \
    mkdir /tmp/install-tl-unx && \
    curl -L https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz | \
    tar -xz -C /tmp/install-tl-unx --strip-components=1 && \
    /tmp/install-tl-unx/install-tl \
    --profile texlive.profile \
    --repository https://mirror.ctan.org/systems/texlive/tlnet/ && \
    tlmgr install xkeyval xstring microtype etoolbox booktabs caption fancyvrb libertine totpages environ textcase hyperxmp ifmtarg luacode xcolor ncctools float preprint inconsolata newtx fontspec txfonts latexmk comment siunitx upquote here cmap setspace acmart todonotes latexindent synctex texcount chktex pxpgfmark && \
    rm -fr /tmp/install-tl-unx && \
    apk del --purge .fetch-deps

WORKDIR /working

COPY precompile/ /working

RUN cd /working && latexmk --lualatex sample-lualatex.tex && rm -rf *

CMD ["/bin/ash"]





