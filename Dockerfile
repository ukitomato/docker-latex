FROM alpine:latest as builder

COPY texlive.profile .

ENV PATH /usr/local/texlive/2021/bin/x86_64-linuxmusl:$PATH

# Install base latex package via texlive
RUN apk add --no-cache curl wget xz tar build-base perl perl-dev perl-app-cpanminus fontconfig-dev freetype-dev && \
    mkdir /tmp/install-tl-unx && \
    curl -L https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz | \
    tar -xz -C /tmp/install-tl-unx --strip-components=1 && \
    /tmp/install-tl-unx/install-tl \
    --profile texlive.profile \
    --repository https://mirror.ctan.org/systems/texlive/tlnet/ && \
    rm -fr /tmp/install-tl-unx
# Install additional packages
RUN tlmgr install xkeyval xstring microtype etoolbox booktabs caption fancyvrb libertine totpages environ textcase hyperxmp ifmtarg luacode xcolor ncctools float preprint inconsolata newtx fontspec latexmk comment siunitx upquote here cmap setspace acmart todonotes pxpgfmark multirow

WORKDIR /working

# Run lualatex once for creating font database
COPY precompile/ /working
RUN cd /working && latexmk --lualatex sample-lualatex.tex && rm -rf *


FROM alpine:latest as default

RUN apk add --no-cache perl
COPY --from=builder /usr/local/texlive /usr/local/texlive

ENV PATH /usr/local/texlive/2021/bin/x86_64-linuxmusl:$PATH

CMD ["/bin/ash"]


FROM alpine:latest as vscode-builder

RUN apk add --no-cache wget build-base perl perl-dev perl-app-cpanminus
COPY --from=builder /usr/local/texlive /usr/local/texlive

ENV PATH /usr/local/texlive/2021/bin/x86_64-linuxmusl:$PATH

# Install necessary packages for VSCode
RUN tlmgr install latexindent synctex texcount chktex
## Install dependencies for latexindent
RUN cpanm YAML::Tiny File::HomeDir Unicode::GCString


FROM alpine:latest as vscode

RUN apk add --no-cache perl

COPY --from=vscode-builder /usr/local/lib/perl5 /usr/local/lib/perl5
COPY --from=vscode-builder /usr/local/share/perl5 /usr/local/share/perl5
COPY --from=vscode-builder /usr/local/texlive /usr/local/texlive

ENV PATH /usr/local/texlive/2021/bin/x86_64-linuxmusl:$PATH

CMD ["/bin/ash"]
