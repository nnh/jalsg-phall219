/* Slice of JALSG-PhALL219_CSVtoSASDS.sas (lines 85-121): build the trimmed  */
/* demographics dataset (tmp1a), derive the facility lookup (tmp1b) by        */
/* renaming the imported var1/var2 columns, sort both BY siteid, and join     */
/* the site name onto each subject with MERGE / IN= keeping demographics rows */
/* only. The rename, sort and IN= subsetting are unchanged from upstream.     */
data tmp1a(keep=usubjid subjid rficdt brthdt sex race age rfstdt siteid);
  set DM;
  length
      rfstdt rficdt brthdt age 8.;
  rfstdt=input(rfstdtc,yymmdd10.);
  rficdt=input(rficdtc,yymmdd10.);
  brthdt=input(brthdtc,yymmdd10.);
  age   =int(yrdif(brthdt, rficdt, 'AGE'));
  format rfstdt rficdt brthdt yymmdd10.;
  label siteid="医療機関コード";
run;

data tmp1b(keep=siteid sitenm);
  set facilities;
  length siteid $11. sitenm $100.;
  siteid=var1;
  sitenm=var2;
  label sitenm="医療機関名";
run;

proc sort data=tmp1a;
  by siteid;
run;
proc sort data=tmp1b;
  by siteid;
run;
data tmp1c;
  merge tmp1a(in=a) tmp1b;
  by siteid;
  if a;
run;

proc print data=tmp1c label;
  var usubjid siteid sitenm sex age;
run;
