# cmb-phage-screening
MATLAB software tools for implementing combinatorial drug screens, with emphasis on phage therapy screening. Particularly useful in combination with the Formulatrix Mantis (TM) high-throughput liquid handler. 

Experiment outline + relevant scripts: 
   1.) Generate a plate map representing an exhaustive combinatorial screen
           -plateMap.m
   2.) Convert plate map to a liquid handler protocol (in this case, the
       Formulatrix Mantis (TM))
           -MantisProtocolGenerator.m 
           -inscribeSkeleton.m 
   3.) Re-format plate reader data into a convenient form for downstream
       analysis 
           -formatData.m
   4.) Plot data 
           -plotData.m
           -plotIndivData.m
   5.) Calculate interaction values + assemble iNets
           -interactionNetwork.m 
   6.) [IN PROGRESS] Infer higher-order cocktail efficacy + calculate
       optimal cocktails
          -topCandidates.m

 Copyright (c) 2017 Joseph Kreitz (joekreitz@gmail.com).
