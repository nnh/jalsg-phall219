/* autoexec.sas — JALSG-PhALL219 パス自動判定（akiko-office/setup/sas/autoexec-template.sas 由来） */
%global box_root repo_root;
%macro _set_box_root;
  %if %length(%sysget(AKIKO_BOX_ROOT)) %then %let box_root=%sysget(AKIKO_BOX_ROOT);
  %else %if &sysscp.=WIN %then %let box_root=%sysfunc(translate(%sysget(USERPROFILE),/,\))/Box;
  %else %let box_root=%sysget(HOME)/Library/CloudStorage/Box-Box;
%mend; %_set_box_root;
filename _cwd '.'; %let repo_root=%sysfunc(pathname(_cwd)); filename _cwd clear;

%let grp=JALSG; %let trial=JALSG-PhALL219;
%let base=&box_root/Stat/Trials/&grp/&trial;

libname raw  "&base/input/rawdata";
libname sdtm "&base/input/sdtm";
libname ads  "&base/input/ads";
libname ext  "&base/input/ext";
/* PhALL219 は Box に save/ 未作成。永続データセットを使う段階で Box に save/ を作り次行を有効化：
libname save "&base/save"; */

%let boxpgm=&base/program;
%let out=&base/output;

%put NOTE: [autoexec] box_root=&box_root repo_root=&repo_root;
%put NOTE: [autoexec] base=&base;
