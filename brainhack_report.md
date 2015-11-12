---
event: 'Brainhack'

title:  'A Description of Brainhack Event Project Reports'

author:

- initials: RCC
  surname: Craddock
  firstname: R. Cameron
  email: ccraddock@nki.rfmh.org
  affiliation: aff1, aff2
  corref: aff1
- initials: PB
  surname: Bellec
  firstname: Pierre
  email: pierre.bellec@criugm.qc.ca
  affiliation: aff3, aff4
- initials: DSM
  surname: Margulies
  firstname: Daniel S.
  email: margulies@cbs.mpg.de
  affiliation: aff5

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
- id: aff3
  orgname: 'Functional Neuroimaging Unite, Centre de Recherche de L''Institute Universitaire de Gérieatrie de Montréal'
  city: Montréal
  state: Québec
  country: Canada
- id: aff4
  orgname: 'Department of Computer Science and Operations Research, University of Montréal'
  city: Montréal
  state: Québec
  country: Canada
- id: aff5
  orgname: 'Max Planck Research Group for Neuroanatomy and Connectivity, Max Planck Institute for Human Cognitive and Brain Sciences'
  city: Leipzig
  country: Germany

url: http://brainhack.org

keywords: 

- kw: brainhack
- kw: reproducibility
- kw: hackathon
- kw: open science
- kw: neuroscience
- kw: big data

coi: The authors do not have any competing interests.

acknow: The authors would like to thank all of the organizers and attendess of past and future Brainhack events. Your willingness for open collaboration has been and will continue to be a force for positive change in the neuroscience community.

contrib: RCC conceived the idea for Brainhack reports and PB and DSM helped flush out the procedures for making them work. RCC, PB, and DSM wrote the paper.

abstract: |
  This is the abstract.

  It consists of two sections.
  
  *Approach*
  *Results*
  
bibfile: bhreport
...

#Introduction

Brainhack is a unique conference that convenes researchers from across the globe and myriad disciplines to work together on innovative projects related to neuroscience. Year after year, global and regional Brainhack events bring researchers together to participate in open collaboration. Brainhack is unconventional – the event eschews a prearranged schedule of scientific sessions and instead structures activities onsite based on the interests of the community. This model encourages active participation and interaction between attendees.

For attendees there is no denying the benefits of participating in Brainhack events, 

the lack of formal publications describing the projects performed during the events and the progress made, make it difficult to convey these benefits to others.

To kick off the new model, Brainhack Eastern Daylight Time (EDT) will unite several regional Brainhack events during October 17-19, 2014. Local events will be connected by videoconference to expand collaborative opportunities and so that smaller sites can plug into the content and energy generated at larger sites. To maximize the potential for interaction between sites, Brainhack EDT will connect sites that are within two hours of EDT (UTC-4 hours).

Sites in New York City, Montréal, Boston, and Porto Alegre have already signed on, and we hope to partner with six additional sites throughout North and South America. Please contact Cameron Craddock (cameron *dot* craddock *at* childmind *dot* org) if you are interested in hosting a Brainhack in your area.

Every attempt will be made to minimize the cost of attendance at these events, most events will be FREE. 


#Approach

In 2005 Sporn and Hagmann \cite{Sporns2005,Hagmann2005} independently and in parallel coined the term \textit{the human connectome}, which embodies the notion that the set of all connections within the human brain can be represented and understood as graphs. In the context of iFC, graphs provide a mathematical representation of the functional interactions between brain areas -  nodes in the graph represent brain areas and edges indicate their functional connectivity. While general graphs can have multiple edges between two nodes, brain graphs tend to be simple graphs with a single undirected edge between pairs of nodes (i.e. the direction of influence between nodes is unknown). Additionally edges in graphs of brain function tend to be weighted - annotated with a value that indicates the similarity between nodes. Analyzing functional connectivity involves 1) preprocessing the data to remove confounding variation and to make it comparable across datasets, 2) specification of brain areas to be used as nodes, 3) identification of edges from the iFC between nodes, and 4) analysis of the graph (i.e. the structure and edges) to identify relationships with inter- or intra- individual variability. All of these steps have been well covered in the literature by other reviews \cite{Craddock2013,Kelly2012,Varoquaux2013} and repeating that information provides little value. Instead we will focus on exciting areas in the functional connectomics literature that we believe provide the greatest opportunities for data scientists in this quickly advancing field.

Defining the nodes to use for a connectivity graph is a well described problem that has become an increasingly active area of research \cite{Thirion2014}. From a neuroscientific perspective there is meaningful spatial variation in brain function that exists at resolutions much finer than what can be measured using modern non-invasive neuroimaging techniques. But, connectivity graphs generated at the spatial resolution of these techniques are too large to be wieldy and there is insufficient fine-grained information about brain function to interpret connectivity results at that level. For that reason, the number of nodes in the connectome are commonly reduced by combining voxels into larger brain areas for analysis. This is accomplished using either boundaries derived from anatomical landmarks \cite{Desikan2006,AAL2002}, regions containing homogeneous cyto-architecture as determined by post-mortem studies \cite{Eickhoff2008}, or from clusters determined by applying unsupervised learning methods to functional data \cite{Bellec2006,Craddock2012}. The latter approach tends to be preferred since it is not clear that brain function respects anatomical subdivisions, and similar cells may support very different brain functions \cite{Craddock2012}. Quite a few clustering approaches have been applied to the problem of parcellating brain data into functionally homogenous brain areas, each varying in terms of the constraints that they impose on the clustering solution  \cite{Craddock2012,Blumensath2013,Bellec2006,Thirion2006,Zalesky2010,Flandin2002,Thirion2014}. There is some evidence in the literature that hierarchical clustering based methods perform best \cite{Blumensath2013,Thirion2014}, but no single clustering level has emerged as optimal. Instead, it appears as though there is a range of suitable clustering solutions from which to choose  \cite{Craddock2012,Thirion2014}.  


#Results and Discussion

The ultimate goals of connectomics is to map the brain's functional architecture and to annotate it with the cognitive or behavioral functions that they subtend. This latter pursuit is achieved by a group level analysis in which variations in the connectome are mapped to inter-individual differences in phenotype  \cite{Kelly2012}, clinical diagnosis \cite{Castellanos2013}, or intra-individual responses to experimental perturbations \cite{Shirer2012}. Several different analyses have been proposed for accomplishing these goals, and they all require some mechanism for comparing brain graphs \cite{Varoquaux2013}. 
 
Approaches to comparing brain graphs can be differentiated based on how they treat the statistical relationships between edges. One such approach, referred to as \emph{bag of edges}, is to treat each edge in the brain graph as a sample from some random variable. Thus, a set of $N$ brain graphs each with $M$ edges will have $N$ observations for each of the $M$ random variables. In this case, the adjacency (or similarity) matrix that describes the brain graphs can be flattened into a vector representation and any of the well explored similarity or dissimilarity metrics can be applied to the data \cite{Craddock2013}. One of the benefits of this representation is the ability to treat each edge as independent of all other edges and to compare graphs using mass univariate analysis, in which, a separate univariate statistical test (e.g. t-test, anova, or ancova) is performed at each edge. This will result in a very large number of comparisons and an appropriate correction for multiple comparisons, such as Network Based Statistic \cite{Zalesky2012}, Spatial Pairwise Clustering \cite{Zalesky2012}, Statistical Parametric Networks \cite{Ginestat2011}, or group-wise false discovery rate  \cite{Benjamini2001}, must be employed to control the number of false positives. Alternatively the interdependencies between edges can be modeled at the node level using multivariate distance matrix regression (MDMR) \cite{Shehzad2014}, or across all edges using machine learning methods \cite{Craddock2009, Dosenbach2010, Richiardi2011}.

# Conclusions

Functional connectomics is a ``big data'' science. As highlighted in this review, the challenge of learning statistical relationships between very high dimensional feature spaces and noisy or underspecified labels is rapidly emerging as rate-limiting steps for this burgeoning field and its promises to transform clinical knowledge. Accelerating the pace of discovery in functional connectivity research will require attracting data science researchers to develop new tools and techniques to address these challenges. It is our hope that recent augmentation of open science data-sharing initiatives with preprocessing efforts will catalyze the involvement of these researchers by reducing the common barriers of entry. 
