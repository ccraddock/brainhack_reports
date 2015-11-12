all: brainhack_report.tex brainhack_report.bib brainhack_report_maintext.tex
	pdflatex brainhack_report.tex
	bibtex brainhack_report
	pdflatex brainhack_report.tex
	pdflatex brainhack_report.tex
#
# marked: brainhack_report_v2_marked.tex brainhack_report.bib brainhack_report_maintext.tex
# 	pdflatex brainhack_report_v2_marked.tex
# 	bibtex brainhack_report_v2_marked
# 	pdflatex brainhack_report_v2_marked.tex
# 	pdflatex brainhack_report_v2_marked.tex

pandoc: brainhack_report_template.tex brainhack_report.bib brainhack_report.md
	pandoc -s -N --template brainhack_report_template.tex brainhack_report.md -o brainhack_report_formatted.tex
	
formatted: pandoc
	pdflatex brainhack_report_formatted.tex
	bibtex brainhack_report_formatted
	pdflatex brainhack_report_formatted.tex
	pdflatex brainhack_report_formatted.tex