options obs=100;

/* Mock SDTM LB restricted to LBTESTCD="MYBLALE" (bone-marrow blast %)        */
/* across the induction / consolidation / relapse evaluation visits the      */
/* upstream step keys on (LBSPID x LBLNKGRP). Two subjects with differing     */
/* visit coverage so the per-subject RETAIN/LAST. collapse is exercised.      */
data LB;
  infile datalines dsd truncover;
  length usubjid $14 lbtestcd $8 lbspid $20 lblnkgrp $10 lbstat $20 lborres $8 lbdtc $10;
  input usubjid $ lbtestcd $ lbspid $ lblnkgrp $ lbstat $ lborres $ lbdtc $;
  datalines;
JALSG-001-0001,MYBLALE,evaluation1,INDUC1E,,4.5,2022-05-01
JALSG-001-0001,MYBLALE,evaluation2,INDUC2E,,1.2,2022-06-10
JALSG-001-0001,MYBLALE,evaluation3,CONS1E,,0.5,2022-07-20
JALSG-001-0001,MYBLALE,relapse,RELAPSE,,38.0,2023-02-15
JALSG-002-0001,MYBLALE,evaluation1,INDUC1E,NOT DONE,,2022-05-05
JALSG-002-0001,MYBLALE,evaluation4,CONS2E,,2.0,2022-09-01
JALSG-002-0001,MYBLALE,evaluation5,CONS3E,,1.0,2022-10-12
;
run;
