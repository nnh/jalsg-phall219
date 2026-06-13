/* Slice of JALSG-PhALL219_CSVtoSASDS.sas (lines 150-170): widen the         */
/* external diseases lookup's name_en field, then PROC PRINT the in-scope    */
/* classification codes using the multi-line WHERE code IN(...) list. The    */
/* code set, the LENGTH widening and the PRINT are unchanged from upstream;  */
/* the data source is the bundled mock diseases lookup.                      */
data diseases_fixed;
  set diseases;
  length name_en $200.;
run;

proc print data=diseases_fixed;
  var code name_en;
  where code in (10010
10300
10310
10350
10370
10390
10400
10420
10430
10440
10450
10460
11670);
run;
