CraddockGigscience2014
========================

Craddock et. al., connectomes gigscience review paper.

To compile this paper you will need pdflatex and bibtex installed. This can 
easily be accomplished on a Mac by install mactex. If you have linux you will
want to install from a repository using a package manager such as 'apt-get' 
or 'yum'. If you have a PC, I am not sure how you install latex.

If you have make installed you can compile the paper using:
    
    make

Otherwise you will need to run the commands:
    
    pdflatex craddockGigascience2014.tex
    bibtex craddockGigascience2014
    pdflatex craddockGigascience2014.tex
    pdflatex craddockGigascience2014.tex

The multiple runs makes sure that all references are resolved. If you do not 
change the bib file you will not need to rerun the bibtex command.

Otherwise you can just download the PDF.

