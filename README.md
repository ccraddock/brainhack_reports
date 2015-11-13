Brainhack Report
========================

Craddock and Clark: 3dLFCD and 3dDegreeCentrality

To compile this paper you will need a to have a distribution of LaTex that includes bibtex and pdflatex tools as well as Pandoc installed on your local computer. If you have a PC, I am not sure how you install latex.

On Mac:
The installation of LaTex can be easily achieved on a Mac using the [mactex package](https://tug.org/mactex/). 

For Ubuntu:
    
	sudo apt-get install texlive

For Redhat/CentOS/Fedora (I believe that this will work):
	
	sudo yum install texlive

The Brainhack Report is written in Markdown and then converted into LaTex using a Brainhack report template. To perform this step you will need to have Pandoc installed. This can be accomplished on a variety of operating systems using instructions from the [Installing Pandoc web page](http://pandoc.org/installing.html).

If you have make installed you can compile the paper using:
    
    make

Otherwise you will need to run the commands:
    
	pandoc -s -S -N --template brainhack-report-template.tex brainhack-report.md -o brainhack-report-formatted.tex
	pdflatex brainhack-report-formatted.tex
	bibtex brainhack-report-formatted
	pdflatex brainhack-report-formatted.tex
	pdflatex brainhack-report-formatted.tex

The multiple runs makes sure that all references are resolved. If you do not 
change the bib file you will not need to rerun the bibtex command.

Fairly accurate word counts, ignoring latex commands, can be calculated using:

    	texcount brainhack-report-formatted.tex

If you want to use this template to write your own Brainhack Report (after all, that is why I made it) you can follow this procedure:

   1. Fork this repository to make your own copy, name it whatever you wish. This can be accomplished by clicking on the "Fork" button on the top right of this page.
   2. Update the header of the brainhack-report.md file. You can use any name you like for the bibliography file, but if it contains and underscore (\_) the file will not work correctly. I couldn't make this not happen, so I changed everything to minus signs (-).
   3. Please remember to state any conflicts of interest you have and to acknowledge any funding that allowed you to attend Brainhack or perform the project. If you used the cloud computing credits provided by AWS please include a line stating: This project was funded in part by a Educational Research Grant from Amazon Web Services.
   4. Fill out the text of the document. The format is: Introduction, Approach, Results, and Conclusion. Please include citations using the \cite{bibkey} tag, where bibkey corresponds to the article's key in your bibtex bibliography file. The body of the document should be no more than 650 words.
   5. Create a bibtex bibliography file. Again, do not include underscores in the name of this file. If you are not familiar with creating a bibtex file you have several options. Bibliography software such as EndNote and Mendeley will allow you to export references as bibtex. The homepage for journal articles almost always allow you to export a reference in bibtex. For papers that are in PubMED you can use [TeXMed](http://www.bioinformatics.org/texmed/) to export to bibtex. Copy all of your references to the same file. The key will be used in the body of the document to cite the article, I usually change this key to something that is easy to guess (i.e. Craddock2013) so that I don't have to refer to the bib file constantly. 
   6. Add a figure and up to two tables. Make 'em look good.
   7. Compile the image using the instructions above and see how beautiful it is!
   8. When you are done, push all of you changes to the GitHub repository and submit your abstract for inclusion in the proceedings [here](http://brainhack.org/proceedings-submission-form/).