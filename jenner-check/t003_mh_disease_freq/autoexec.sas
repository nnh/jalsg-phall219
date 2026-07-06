options obs=100;

/* Mock SDTM MH with the PRIMARY DIAGNOSIS WHO/ALL disease codes the         */
/* upstream MHTERM->display-name mapping recognises (10010..11670), plus a   */
/* couple of unmapped codes so the ELSE branch is exercised.                 */
data MH;
  infile datalines dsd truncover;
  length usubjid $14 mhcat $30 mhoccur $1 mhspid $20 mhterm $20;
  input usubjid $ mhcat $ mhoccur $ mhspid $ mhterm $;
  datalines;
JALSG-001-0001,PRIMARY DIAGNOSIS,Y,baseline1,10300
JALSG-001-0002,PRIMARY DIAGNOSIS,Y,baseline1,10300
JALSG-002-0001,PRIMARY DIAGNOSIS,Y,baseline1,10370
JALSG-002-0002,PRIMARY DIAGNOSIS,Y,baseline1,10390
JALSG-002-0003,PRIMARY DIAGNOSIS,Y,baseline1,10440
JALSG-003-0001,PRIMARY DIAGNOSIS,Y,baseline1,10440
JALSG-003-0002,PRIMARY DIAGNOSIS,Y,baseline1,11670
JALSG-003-0003,PRIMARY DIAGNOSIS,Y,baseline1,99999
;
run;
