Docker LaTeX for Japanase
====

This is a docker image source for [upLaTeX](https://texwiki.texjp.org/?upTeX%2CupLaTeX), dvipdfmx, [latexmk](https://texwiki.texjp.org/?Latexmk) using [Noto Fonts](https://www.google.com/get/noto/).

## Description
- Compiler: [upLaTeX](https://texwiki.texjp.org/?upTeX%2CupLaTeX), (pLaTex)
- PDF converter: dvipdfmx
- Automator: [latexmk](https://texwiki.texjp.org/?Latexmk)
- Available Font: [Noto Fonts](https://www.google.com/get/noto/)

## Install
```
$ docker pull ukitomato/latex
```

## Usage
1. if you want to compile 'latex.tex' automatically
```
$ cd your-workspace
$ docker run -v .:/working --name latex -w /working ukitomato/latex:latex latexmk -pvc latex.tex
```
2. if you want to compile 'latex.tex' manually
```
$ cd your-workspace
$ docker run -v .:/working --name latex -w /working ukitomato/latex:latex
root@0000000000:/working # uplatex latex.tex
root@0000000000:/working # dvipdfmx latex
```

## Example LaTeX file
latex.tex
```
\documentclass[uplatex,a4paper]{jsarticle}
\usepackage[noto-otc]{pxchfon}
\begin{document}
\section{English}
This is a sample file.
\section{日本語}
これは，サンプルファイルです．
\end{document}
```


## Default latexmkrc Setting
This setting is used automatically.
If you want to use your own settings, put the .latexmkrc file in the same folder as the .tex file.

```
#!/usr/bin/env perl
$latex                         = 'uplatex %O -synctex=1 -halt-on-error -interaction=batchmode %S';
$pdflatex                      = 'pdflatex %O -synctex=1 -interaction=nonstopmode %S';
$lualatex                      = 'lualatex %O -synctex=1 -interaction=nonstopmode %S';
$xelatex                       = 'xelatex %O -no-pdf -synctex=1 -shell-escape -interaction=nonstopmode %S';
$biber                         = 'biber %O --bblencoding=utf8 -u -U --output_safechars %B';
$bibtex                        = 'upbibtex %O %B';
$makeindex                     = 'upmendex %O -o %D %S';
$dvipdf                        = 'dvipdfmx %O -o %D %S';
$dvips                         = 'dvips %O -z -f %S | convbkmk -u > %D';
$ps2pdf                        = 'ps2pdf %O %S %D';
$pdf_mode                      = 3;

$pvc_view_file_via_temporary = 0;
```

## Example Docker Compose file
1. make docker-compose.yml
docker-compose.yml
```
$ vi docker-compose.yml
version: '3'
services:
  latexmk:
    image: ukitomato/latex:latest
    volumes:
      - .:/working
    working_dir: /working
    command: latexmk -pvc latex.tex
\end{document}
```
2. start latexmk
```
$ cd workspace
$ docker-compose up
```


## Licence

[MIT](https://github.com/ukitomato/docker-latex/blob/master/LICENSE)

## Author
Yuki Yamato [[ukitomato](https://github.com/ukitomato)]
