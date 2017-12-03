# cmb-phage-screening
Matlab software tools for implementing combinatorial drug screens, with emphasis on phage therapy screening. Particularly useful in combination with the Formulatrix Mantis (TM) high-throughput liquid handler.<br />

<br />

Refer to ExamplePhageCombinatorics.m for an example implementation of a phage screening procedure using this package. 

<br />

Experiment outline + relevant scripts:<br />
   1.) Generate a plate map representing an exhaustive combinatorial screen: plateMap.m<br />
   2.) Convert plate map to a liquid handler protocol (in this case, the
       Formulatrix Mantis (TM)): MantisProtocolGenerator.m, inscribeSkeleton.m<br />
   3.) Re-format plate reader data into a convenient form for downstream
       analysis: formatData.m<br />
   4.) Plot data: plotData.m, plotIndivData.m<br />
   5.) Calculate interaction values + assemble iNets: synergyMap.m<br />
   6.) [IN PROGRESS] Infer higher-order cocktail efficacy + calculate 
       optimal cocktails: minIntValSolver.m<br />
       
 <br />
 
 Package I am borrowing: Daniel Helmick's varycolor https://www.mathworks.com/matlabcentral/fileexchange/21050-varycolor

 Copyright (c) 2017 Joseph Kreitz (joekreitz@gmail.com).
