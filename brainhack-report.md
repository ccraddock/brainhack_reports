---
event: '2015 Brainhack Americas (MX)'

title:  'Optimized implementations of voxel-wise degree centrality and local functional connectivity density mapping in AFNI'

author:

- initials: RCC
  surname: Craddock
  firstname: R. Cameron
  email: ccraddock@nki.rfmh.org
  affiliation: aff1, aff2
  corref: aff1
- initials: DJC
  surname: Clark
  firstname: Daniel J.
  email: daniel.clark@childmind.org
  affiliation: aff2

affiliations: 

- id: aff1
  orgname: 'Computational Neuroimaging Lab, Center for Biomedical Imaging and Neuromodulation, Nathan Kline Institute for Psychiatric Research'
  street: 140 Old Orangeburg Rd
  postcode: 10962
  city: Orangeburg
  state: New York
  country: USA
- id: aff2
  orgname: 'Center for the Developing Brain, Child Mind Institute'
  street: 445 Park Ave
  postcode: 10022
  city: New York
  state: New York
  country: USA

url: http://github.com/ccraddock/afni

coi: None

acknow: The authors would like to thank the organizers and attendees of Brainhack MX and the developers of AFNI. This project was funded in part by a Educational Research Grant from Amazon Web Services.

contrib: RCC and DJC wrote the software, DJC performed tests, and DJC and RCC wrote the report.
  
bibliography: brainhack-report

gigascience-ref: REFXXX
...

#Introduction
Degree centrality (DC) \cite{Rubinov2010} and local functional connectivity density (lFCD) \cite{Tomasi2010} are statistics calculated from brain connectivity graphs that measure how important a brain region is to the graph. DC (a.k.a. global functional connectivity density \cite{Tomasi2010}) is calculated as the number of connections a region has with the rest of the brain (binary DC), or the sum of weights for those connections (weighted DC) \cite{Rubinov2010}. lFCD was developed to be a surrogate measure of DC that is faster to calculate by restricting its computation to regions that are spatially adjacent \cite{Tomasi2010}. Although both of these measures are popular for investigating inter-individual variation in brain connectivity, efficient neuroimaging tools for computing them are scarce. The goal of this Brainhack project was to contribute optimized implementations of these algorithms to the widely used, open source, AFNI software package \cite{Cox1996}.

#Approach
Tools for calculating DC (\texttt{3dDegreeCentrality}) and lFCD (\texttt{3dLFCD}) were implemented by modifying the C source code of AFNI's \texttt{3dAutoTcorrelate} tool. \texttt{3dAutoTcorrelate} calculates the voxel $\times$ voxel correlation matrix for a dataset and includes most of the functionality we require, including support for OpenMP \cite{Dagum1998} multithreading to improve calculation time, the ability to restrict the calculation using a user-supplied or auto-calculated mask, and support for both Pearson's and Spearman correlation.

##### \texttt{3dDegreeCentrality}:
Calculating DC is straight forward and is quick when a correlation threshold or is used. In this scenario, each of the $.5*N_{vox}*(N_{vox}-1)$ unique correlations are calculated, and if they exceed a user specified threshold (default threshold = 0.0) the binary and weighted DC value for each of the voxels involved in the calculation are incremented. The procedure is more tricky if sparsity thresholding is used, where the top $P\%$ of connections are included in the calculation. This requires that a large number of the connections be retained and ranked - consuming substantial memory and computation. We optimize this procedure with a histogram and adaptive thresholding. If a correlation exceeds threshold it is added to a 50-bin histogram (array of linked lists). If it is determined that the lowest bin of the histogram is not needed to meet the sparsity goal, the threshold is increased by the bin-width and the bin is discarded. Once all of the correlations have been calculated, the histogram is traversed from high to low, incorporating connections into binary and weighted DC until a bin is encountered that would push the number of retained connections over the desired sparsity. This bin's values are sorted into a 100-bin histogram that is likewise traversed until the sparsity threshold is met or exceeded. Sparsity is exceeded when the differences between correlation values are less than $1.0/(50*100)$.

\begin{table*}[t!]
\caption{\label{stattable}Comparison of the time and memory required by the C-PAC and AFNI implementations to calculate DC (sparsity and correlation threshold) and lFCD on the first resting state scan of the first scanning session for all 36 participants' data in the IBATRT dataset. Values are averaged across the 36 datasets and presented along with standard deviations in parenthesis.}
\begin{tabular}{l l l l l l l l l l l}
 \hline\noalign{\smallskip}
          &            & \multicolumn{3}{c}{DC $\rho \geq 0.6$} & \multicolumn{3}{c}{DC $0.1\%$ Sparsity} & \multicolumn{3}{c}{lFCD $\rho \geq 0.6$} \\
    \noalign{\smallskip}
  Impl  & Thr & Mem (GB) & $T_D$ (s) &  $T_T$ (s) & Mem (GB) & $T_D$ (s) &  $T_T$ (s) & Mem (GB) & $T_D$ (s) &  $T_T$ (s) \\
    \hline\noalign{\smallskip}
  C-PAC   & 1          & 0.84 (0.003) & 62.6 (9.23) & 793.1  & 0.85 (0.002) & 86.3 (13.8) & 420.0 & 0.86 (0.003) & 8.8 (1.3)  & 50.7 \\
  AFNI    & 1          & 0.84 (0.003) & 62.6 (9.23) & 793.1  & 0.85 (0.002) & 86.3 (13.83) & 420.0 & 0.86 (0.003) & 8.8 (1.27)  & 50.7 \\
  AFNI    & 2          & 0.86 (0.002) & 39.0 (4.62) & 752.3  & 0.86 (0.003) & 38.2 (0.55) & 353.7 & 0.86 (0.003) & 5.1 (0.25) & 56.4 \\
  AFNI    & 4          & 0.86 (0.003) & 18.2 (1.93) & 784.1  & 0.87 (0.003) & 19.0 (0.45) & 359.1 & 0.87 (0.003) & 4.3 (0.23) & 95.0 \\
  AFNI    & 8          & 0.87 (0.002) & 11.2 (0.25) & 887.3  & 0.87 (0.000) & 11.3 (0.31) & 439.0 & 0.87 (0.000) & 4.1 (0.15) & 178.2 \\
  \noalign{\smallskip}\hline
\end{tabular}
\end{table*}

##### \texttt{3dLFCD}:
lFCD was calculating using a region growing algorithm in which face-, side-, and corner-touching voxels are iteratively added to the cluster if their correlation with the target voxel exceeds a threshold (default threshold = 0.0). Although lFCD was originally defined as the number of voxels locally connected to the target, we also included a weighted version.

##### Validation:
Outputs from the newly developed tools were benchmarked to Python implementations of these measures from the Configurable Pipeline for the Analysis of Connectomes (C-PAC) \cite{Craddock2013c} using in the publically shared \href{http://fcon_1000.projects.nitrc.org/indi/CoRR/html/ibatrt.html}{Intrinsic Brain Activity Test-Retest (IBATRT) dataset} from the Consortium for Reliability and Reproduciblity\cite{Zuo2014}.

#Results
AFNI tools were developed for calculating lFCD and DC from functional neuroimaging data and have been submitted for inclusion into AFNI. LFCD and DC maps from the test dataset (illustrated in Fig. \ref{centfig}) are identical to those calculated using C-PAC but required substantially less time and memory (see Table \ref{stattable}).

\begin{figure}[h!]
  \includegraphics[width=.47\textwidth]{centrality_plot}
  \caption{\label{centfig}
  Whole brain maps of binarized and weighted degree centrality calculated with a correlation threshold of $\rho\geq0.6$ (a-b) 
  and sparsity threshold of 0.1\% (c-d) and binarized and weighted lFCD calculated with a correlation threshold of $\rho\geq0.6$ (e-f) 
  averaged across maps calculated the first resting state scan of the first scanning session for all 36 participants' data from the IBATRT data. }
\end{figure}

# Conclusions
Optimized versions of lFCD and DC achieved 4$\times$ to 30$\times$ decreases in computation time compared to C-PAC's Python implementation and decreased the memory footprint to less than 1 gigabyte. These improvements will dramatically increase the size of Connectomes analyses that can be performed using conventional workstations. Making this implementation available through AFNI ensures that it will be available to a wide range of neuroimaging researchers who do not have the wherewithal to implement these algorithms themselves.
