options obs=100;

/* Mock tmp11 carrying just the fields the DFS step reads: remission flag    */
/* (cr1yn), remission date (cr1yndt), relapse flag/date (RLyn, RLdt) and     */
/* overall-survival date (osdt). Dates are built as SAS date values from ISO */
/* strings. Subjects cover: relapsed CR (event), censored CR, and a non-CR   */
/* subject that the WHERE filter drops.                                      */
data tmp11;
  infile datalines dsd truncover;
  length usubjid $14 cr1yn $4 RLyn $1 cr1yndtc rldtc osdtc $10;
  input usubjid $ cr1yn $ RLyn $ cr1yndtc $ rldtc $ osdtc $;
  cr1yndt = input(cr1yndtc, yymmdd10.);
  RLdt    = input(rldtc,    yymmdd10.);
  osdt    = input(osdtc,    yymmdd10.);
  format cr1yndt RLdt osdt yymmdd10.;
  datalines;
JALSG-001-0001,CR,Y,2022-06-15,2023-01-20,2023-06-30
JALSG-001-0002,CR,N,2022-07-01,,2024-03-15
JALSG-002-0001,CR,Y,2022-08-10,2023-03-05,2023-08-12
JALSG-002-0002,NO,N,,,2022-12-01
JALSG-003-0001,CR,N,2022-09-20,,2024-05-01
;
run;
