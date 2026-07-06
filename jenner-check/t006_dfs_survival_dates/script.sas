/* Slice of JALSG-PhALL219_CSVtoSASDS.sas (lines 2318-2347): disease-free    */
/* survival derivation. Restricted to first-remission subjects (cr1yn='CR'); */
/* DFS time in days/months/years is computed from relapse vs. last-contact   */
/* dates, the event flag is set, and CALL MISSING blanks the row whenever a  */
/* non-positive interval results. The DFS algebra, WHERE filter and labels   */
/* are unchanged from the upstream program.                                  */
data tmp11_dfs (keep = usubjid dfs_d dfs_m dfs_y dfs_c);
    set tmp11;

    where cr1yn = 'CR';

    if RLyn= 'Y' then do;
        DFS_d = RLdt - cr1yndt + 1;
        DFS_c = 1;
        end;
    else do;
        dfs_d = osdt - cr1yndt + 1;
        dfs_c = 0;
    end;

    if dfs_d ne . then do;
       dfs_m = dfs_d / (365.25 / 12);
       dfs_y = dfs_d / 365.25;
    end;

    if dfs_d <= 0 then call missing(dfs_d, dfs_m, dfs_y, dfs_c);

    label dfs_d = "無病生存期間(日)"
           dfs_m = "無病生存期間(月)"
           dfs_y = "無病生存期間(年)"
           dfs_c = "DFSイベントフラグ(1:イベント, 0:打切り)";
run;

proc print data=tmp11_dfs label;
  format dfs_m dfs_y 8.2;
  var usubjid dfs_d dfs_m dfs_y dfs_c;
run;
