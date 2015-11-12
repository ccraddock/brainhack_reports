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

keywords: 

- kw: connectome
- kw: centrality
- kw: degree centrality
- kw: local functional connectivity density mapping
- kw: AFNI

coi: None

acknow: The authors would like to thank the organizers and attendees of Brainhack MX and the developers of AFNI.

contrib: RCC and DJC wrote the software, DJC performed tests, and DJC and RCC wrote the report.

abstract:
  Degree centrality and local functional connectivity density are statistics for summarizing the brain's regional connectivity. Although these methods are becoming popular for investigating inter-individual variation in brain connectivity, optimized tools for their calculation are not widely available. To address this problem, we implemented the \texttt{3dDegreeCentrality} and \texttt{3dLFCD} AFNI tools to calculate these measures. Validation on a test dataset found that the new tools produce identical results to the leading Python implementation with a 30$\times$ decrease in time and a 16$\times$ decrease in memory. The developed tools have been submitted for inclusion in AFNI.
  
bibliography: brainhack-report
...

#Introduction
Degree centrality (DC) \cite{Rubinov2010} and local functional connectivity density (lFCD) \cite{Tomasi2010} are statistics calculated from brain connectivity graphs that measure how important a brain region is to the graph. DC (a.k.a. global functional connectivity density \cite{Tomasi2010}) is calculated as the number of connections a region has with the rest of the brain (binary DC), or the sum of weights for those connections (weighted DC) \cite{Rubinov2010}. lFCD was developed to be a surrogate measure of DC that is faster to calculate by restricting its computation to regions that are spatially adjacent \cite{Tomasi2010}. Although both of these measures are popular for investigating inter-individual variation in brain connectivity, efficient neuroimaging tools for computing them are scarce. The goal of this Brainhack project was to contribute optimized implementations of these algorithms to the widely used, open source, AFNI software package \cite{Cox1996}.

#Approach
Tools for calculating DC (\texttt{3dDegreeCentrality}) and lFCD (\texttt{3dLFCD}) were implemented by modifying the C source code of AFNI's \texttt{3dAutoTcorrelate} tool. \texttt{3dAutoTcorrelate} calculates the voxel $\times$ voxel correlation matrix for a dataset and includes most of the functionality we require, including support for OpenMP \cite{Dagum1998} multithreading to improve calculation time, the ability to restrict the calculation using a user-supplied or auto-calculated mask, and support for both Pearson's and Spearman correlation.

##### \texttt{3dDegreeCentrality}:
Calculating DC is straight forward and is quick when a correlation threshold or is used. In this scenario, each of the $.5*N_{vox}*(N_{vox}-1)$ unique correlations are calculated, and if they exceed a user specified threshold (default threshold = 0.0) the binary and weighted DC value for each of the voxels involved in the calculation are incremented. The procedure is more tricky if sparsity thresholding is used, where the top $P\%$ of connections are included in the calculation. This requires that a large number of the connections be retained and ranked - consuming substantial memory and computation. We optimize this procedure with a histogram and adaptive thresholding. If a correlation exceeds threshold it is added to a 50-bin histogram (array of linked lists). If it is determined that the lowest bin of the histogram is not needed to meet the sparsity goal, the threshold is increased by the binwidth and the bin is discarded. Once all of the correlations have been calculated, the histogram is traversed from high to low, incorporating connections into binary and weighted DC until a bin is encountered that would push the number of retained connections over the desired sparsity. This bin's values are sorted into a 100-bin histogram that is likewise traversed until the sparsity threshold is met or exceeded. Sparsity is exceeded when the differences between correlation values are less than $1.0/(50*100)$.

##### \texttt{3dLFCD}:
lFCD was calculating using a region growing algorithm in which face-, side-, and corner-touching voxels are iteratively added to the cluster if their correlation with the target voxel exceeds a threshold (default threshold = 0.0). Although lFCD was originally defined as the number of voxels locally connected to the target, we also included a weighted version.

##### Validation:
Outputs from the newly developed tools were compared to Python implementations of these measures from the Configurable Pipeline for the Analysis of Connectomes (C-PAC) \cite{Craddock2013c} using a preprocessed version of the C-PAC benchmark dataset (\url{http://fcp-indi.github.io/docs/user/benchmark.html}) in terms of similarity, computation time, and memory used.

#Results and Discussion
AFNI tools were developed for calculating lFCD and DC from funcitonal nueroimaging data and have been submitted for inclusion into AFNI. LFCD and DC maps from the test dataset (illustrated in Fig. 1) are identical to those calculated using C-PAC but required substantially less time and memory (see Table 1).

# Conclusions
Optimized versions of lFCD and DC acheived 4$\times$ to 30$\times$ decreases in computation time compared to C-PAC's Python implementation and decreased the memory footprint to less than 1 gigabyte. These improvements will dramatically increase the size of Connectomes analyses that can be performed using conventional workstations. Making this implementation available through AFNI ensures that it will be available to a wide range of neuroimaging researchers who do not have the wherewithal to implement these algorithms themselves.
