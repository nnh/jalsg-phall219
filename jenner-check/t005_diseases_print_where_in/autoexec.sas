options obs=100;

/* Mock external "diseases" lookup (upstream loads input/ext/diseases.csv):  */
/* numeric leukemia/ALL classification codes with English names. Includes    */
/* codes inside and outside the upstream WHERE IN() set so the subset filter */
/* is exercised.                                                             */
data diseases;
  infile datalines dsd truncover;
  length code 8 name_en $200;
  input code name_en $;
  datalines;
10010,"Chronic myeloid leukemia (CML), BCR-ABL1(+)"
10300,"AML with t(8;21)(q22;q22.1);RUNX1-RUNX1T1"
10310,"AML with inv(16) or t(16;16);CBFB-MYH11"
10350,"AML with inv(3) or t(3;3); GATA2, MECOM"
10370,"AML with mutated NPM1"
10390,"AML with myelodysplasia-related changes"
10400,"Therapy-related myeloid neoplasms"
10420,"AML with minimal differentiation"
10430,"AML without maturation"
10440,"AML with maturation"
10450,"Acute myelomonocytic leukemia"
10460,"Acute monoblastic/monocytic leukemia"
11670,"AML with BCR-ABL1"
20000,"Other - not in study scope"
;
run;
