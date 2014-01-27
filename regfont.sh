find . -name '*.tex' -exec perl -pi -e 's/begin{minted}{/begin{minted}[fontsize=\\footnotesize]{/g' {} \;
find . -name '*.tex' -exec perl -pi -e 's/inputminted{/inputminted[fontsize=\\footnotesize]{/g' {} \;
