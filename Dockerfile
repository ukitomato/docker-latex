FROM perl:5.34 as builder

COPY texlive.profile .

ENV PATH /usr/local/texlive/2021/bin/x86_64-linux:$PATH

# Install base latex package via texlive
RUN mkdir /tmp/install-tl-unx && \
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


FROM perl:5.34-slim as default

COPY --from=builder /usr/local/texlive /usr/local/texlive

ENV PATH /usr/local/texlive/2021/bin/x86_64-linux:$PATH

CMD ["/bin/bash"]


FROM perl:5.34 as vscode-builder
COPY --from=builder /usr/local/texlive /usr/local/texlive
ENV PATH /usr/local/texlive/2021/bin/x86_64-linux:$PATH

# Install necessary packages for VSCode
RUN tlmgr install latexindent synctex texcount chktex
## Install dependencies for latexindent
RUN cpanm YAML::Tiny File::HomeDir Unicode::GCString


FROM perl:5.34-slim as vscode
COPY --from=vscode-builder /usr/local/lib/perl5 /usr/local/lib/perl5
COPY --from=vscode-builder /usr/local/texlive /usr/local/texlive

ENV PATH /usr/local/texlive/2021/bin/x86_64-linux:$PATH

CMD ["/bin/bash"]
