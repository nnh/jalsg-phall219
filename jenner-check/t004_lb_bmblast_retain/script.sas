/* Slice of JALSG-PhALL219_CSVtoSASDS.sas (lines 443-514): collapse the      */
/* repeated-measures LB bone-marrow blast records (LBTESTCD="MYBLALE") into  */
/* one wide row per subject. RETAIN holds the per-visit values, FIRST. resets*/
/* them via CALL MISSING, the LBSPID x LBLNKGRP IF/ELSE routes each visit to */
/* its own variables, INPUT(lbdtc,yymmdd10.) parses the dates, and LAST.     */
/* emits one row per subject. Logic and labels are unchanged from upstream.  */
proc sort data=lb;
    by usubjid;
run;

data tmp1e_bm(keep=usubjid i1_bblast i1_bblastyn i1_bblastdt i2_bblast i2_bblastyn i2_bblastdt c1_bblast c1_bblastyn c1_bblastdt
                       c2_bblast c2_bblastyn c2_bblastdt c3_bblast c3_bblastyn c3_bblastdt rl_bblast rl_bblastyn rl_bblastdt);
length  i1_bblastyn i2_bblastyn c1_bblastyn c2_bblastyn c3_bblastyn rl_bblastyn  $20.;
set lb;
    by usubjid;

    retain i1_bblast i1_bblastyn i1_bblastdt i2_bblast i2_bblastyn i2_bblastdt c1_bblast c1_bblastyn c1_bblastdt
                       c2_bblast c2_bblastyn c2_bblastdt c3_bblast c3_bblastyn c3_bblastdt rl_bblast rl_bblastyn rl_bblastdt;

    if first.usubjid then call missing(of i1_bblast i1_bblastyn i1_bblastdt i2_bblast i2_bblastyn i2_bblastdt c1_bblast c1_bblastyn c1_bblastdt
                       c2_bblast c2_bblastyn c2_bblastdt c3_bblast c3_bblastyn c3_bblastdt rl_bblast rl_bblastyn rl_bblastdt);

    where LBTESTCD = "MYBLALE";
    if LBSPID = "evaluation1" and LBLNKGRP="INDUC1E" then do;
        i1_bblastyn=lbstat;
        i1_bblast=lborres;
        i1_bblastdt=input(lbdtc,yymmdd10.);
    end;
    else if LBSPID = "evaluation2" and LBLNKGRP="INDUC2E" then do;
        i2_bblastyn=lbstat;
        i2_bblast=lborres;
        i2_bblastdt=input(lbdtc,yymmdd10.);
    end;
    else if LBSPID = "evaluation3" and LBLNKGRP="CONS1E" then do;
        c1_bblastyn=lbstat;
        c1_bblast=lborres;
        c1_bblastdt=input(lbdtc,yymmdd10.);
    end;
    else if LBSPID = "evaluation4" and LBLNKGRP="CONS2E" then do;
        c2_bblastyn=lbstat;
        c2_bblast=lborres;
        c2_bblastdt=input(lbdtc,yymmdd10.);
    end;
    else if LBSPID = "evaluation5" and LBLNKGRP="CONS3E" then do;
        c3_bblastyn=lbstat;
        c3_bblast=lborres;
        c3_bblastdt=input(lbdtc,yymmdd10.);
    end;
    else if LBSPID = "relapse" and LBLNKGRP="RELAPSE" then do;
        rl_bblastyn=lbstat;
        rl_bblast=lborres;
        rl_bblastdt=input(lbdtc,yymmdd10.);
    end;

    if last.usubjid;

    format i1_bblastdt i2_bblastdt c1_bblastdt c2_bblastdt c3_bblastdt rl_bblastdt yymmdd10.;

    label i1_bblast="寛解導入1回 骨髄芽球%"
          i2_bblast="寛解導入2回 骨髄芽球%"
          c1_bblast="地固め1回 骨髄芽球%"
          c2_bblast="地固め2回 骨髄芽球%"
          c3_bblast="地固め3回 骨髄芽球%"
          rl_bblast="再発時 骨髄芽球%";
run;

proc print data=tmp1e_bm label;
  var usubjid i1_bblast i2_bblast c1_bblast c2_bblast c3_bblast rl_bblast rl_bblastdt;
run;
