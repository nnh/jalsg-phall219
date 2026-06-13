options obs=100;

/* Mock SDTM DM (subset) and the external "facilities" lookup the upstream   */
/* loads from input/ext/facilities.csv. PROC IMPORT names the unheadered     */
/* columns var1/var2; the bundle reproduces that shape so the rename and     */
/* the site-name merge behave as in the program.                            */
data DM;
  infile datalines dsd truncover;
  length usubjid $14 subjid $8 rfstdtc rficdtc brthdtc $10 sex $1 race $20 siteid $11;
  input usubjid $ subjid $ rfstdtc $ rficdtc $ brthdtc $ sex $ race $ siteid $;
  datalines;
JALSG-001-0001,0001,2022-04-01,2022-03-15,1958-07-20,M,ASIAN,001
JALSG-002-0001,0001,2022-06-02,2022-05-20,1963-02-14,M,ASIAN,002
JALSG-002-0002,0002,2022-07-18,2022-07-01,1955-09-30,F,ASIAN,002
JALSG-003-0001,0001,2022-09-15,2022-09-01,1942-05-22,F,ASIAN,003
;
run;

data facilities;
  infile datalines dsd truncover;
  length var1 $11 var2 $100;
  input var1 $ var2 $;
  datalines;
001,Nagoya Medical Center
002,Central Hospital
003,East Medical Center
004,Unenrolled Site
;
run;
