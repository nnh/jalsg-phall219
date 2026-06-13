/* Slice of JALSG-PhALL219_CSVtoSASDS.sas (lines 145-148, 172-190): the      */
/* PROC FREQ on baseline primary-diagnosis MHTERM, and the MH_converted      */
/* IF/ELSE block that maps WHO/ALL leukemia codes to display names. Both the */
/* mapping table and the FREQ are unchanged from the upstream program; the   */
/* data source is the bundled mock MH.                                       */
proc freq data=MH;
  tables mhterm;
  where MHCAT="PRIMARY DIAGNOSIS";
run;

data MH_converted;
  set MH;
  length mhterm_dname $120.;

   if MHTERM = '10010' then mhterm_dname= 'Chronic myeloid leukemia (CML), BCR-ABL1(+)';
   else if MHTERM = '10300' then mhterm_dname= 'AML with t(8;21)(q22;q22.1);RUNX1-RUNX1T1';
   else if MHTERM = '10310' then mhterm_dname= 'AML with inv(16)(p13.1q22) or t(16;16)(p13.1;q22);CBFB-MYH11';
   else if MHTERM = '10350' then mhterm_dname= 'AML with inv(3)(q21.3q26.2) or t(3;3)(q21.3;q26.2); GATA2, MECOM';
   else if MHTERM = '10370' then mhterm_dname= 'AML with mutated NPM1';
   else if MHTERM = '10390' then mhterm_dname= 'AML with myelodysplasia-related changes';
   else if MHTERM = '10400' then mhterm_dname= 'Therapy-related myeloid neoplasms';
   else if MHTERM = '10420' then mhterm_dname= 'AML with minimal differentiation';
   else if MHTERM = '10430' then mhterm_dname= 'AML without maturation';
   else if MHTERM = '10440' then mhterm_dname= 'AML with maturation';
   else if MHTERM = '10450' then mhterm_dname= 'Acute myelomonocytic leukemia';
   else if MHTERM = '10460' then mhterm_dname= 'Acute monoblastic/monocytic leukemia';
   else if MHTERM = '11670' then mhterm_dname= 'AML with BCR-ABL1';
   else  mhterm_dname = mhterm;
run;

proc freq data=MH_converted;
  tables mhterm_dname / nocum;
  where MHCAT="PRIMARY DIAGNOSIS";
run;
