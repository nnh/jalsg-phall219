options obs=100;

/* Mock SDTM DM domain — column shape matches the variables the upstream    */
/* tmp1a step reads (usubjid subjid rfstdtc rficdtc brthdtc sex race siteid).*/
/* 8 subjects across 3 sites; ISO8601 character dates as in SDTM.            */
data DM;
  infile datalines dsd truncover;
  length usubjid $14 subjid $8 rfstdtc rficdtc brthdtc $10 sex $1 race $20 siteid $11;
  input usubjid $ subjid $ rfstdtc $ rficdtc $ brthdtc $ sex $ race $ siteid $;
  datalines;
JALSG-001-0001,0001,2022-04-01,2022-03-15,1958-07-20,M,ASIAN,001
JALSG-001-0002,0002,2022-05-10,2022-04-28,1949-11-03,F,ASIAN,001
JALSG-002-0001,0001,2022-06-02,2022-05-20,1963-02-14,M,ASIAN,002
JALSG-002-0002,0002,2022-07-18,2022-07-01,1955-09-30,F,ASIAN,002
JALSG-002-0003,0003,2022-08-09,2022-07-25,1970-12-01,M,ASIAN,002
JALSG-003-0001,0001,2022-09-15,2022-09-01,1942-05-22,F,ASIAN,003
JALSG-003-0002,0002,2022-10-21,2022-10-05,1968-03-11,M,ASIAN,003
JALSG-003-0003,0003,2022-11-30,2022-11-12,1951-08-08,F,ASIAN,003
;
run;
