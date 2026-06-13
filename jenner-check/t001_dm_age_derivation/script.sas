/* Slice of JALSG-PhALL219_CSVtoSASDS.sas (tmp1a, lines 85-101):           */
/* derive demographic dates and age-at-consent from SDTM DM. The INPUT()   */
/* date parsing, YRDIF(...,'AGE'), FORMAT and LABEL logic are unchanged     */
/* from the upstream program; only the data source is the bundled mock DM. */
data tmp1a(keep=usubjid subjid rficdt brthdt sex race age rfstdt siteid);
  set DM;
  length
      rfstdt rficdt brthdt age 8.;
  rfstdt=input(rfstdtc,yymmdd10.);
  rficdt=input(rficdtc,yymmdd10.);
  brthdt=input(brthdtc,yymmdd10.);
  age   =int(yrdif(brthdt, rficdt, 'AGE'));
  format rfstdt rficdt brthdt yymmdd10.;
  label rficdt="同意取得日"
        brthdt="生年月日"
        sex="性別"
        race="人種"
        rfstdt="症例登録日"
        age="同意取得時年齢"
        siteid="医療機関コード";
run;

proc print data=tmp1a label;
  var usubjid sex age rficdt brthdt rfstdt siteid;
run;
