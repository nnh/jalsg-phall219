# JALSG-PhALL219 — 既知の問題・制約

随時更新（2026-07-20 時点）

次アクションは [next-action.md](next-action.md) を参照。SAP論点の詳細は [docs/sap-open-issues.md](docs/sap-open-issues.md)・[docs/sap-edits-todo.md](docs/sap-edits-todo.md)。詳細根拠は [docs/state-survey.md](docs/state-survey.md)。

---

## SAP・データロック関連

1. ~~SAP未固定~~：2026-07-20、`docs/sap-edits-todo.md`の修正案をもとにSAP本体（Google Doc）を編集・**固定完了**。OPENコメント4件は全て解決操作済み。fix-list必須3件・PRT齟齬2件・データ制約1件はSAP本体への反映を確認済み（死因内訳の`xx(%)`表記は実データ未集計の想定通りのプレースホルダーで問題なし）。唯一の残課題は、RFS対象集団（#49を含める）の決定理由（CRi文献動向）がSAP本文に注記されていない点。アメンドメントするか本リポジトリの記録（[docs/sap-open-issues.md](docs/sap-open-issues.md)）を正式決定記録とするか要判断。
2. ~~ローカルSAPスナップショットが陳腐化~~：解消。Gdriveに直接接続してSAP/PRT最新版を都度取得できることを確認したため、`TMF/`配下のローカル`.md`スナップショット運用は不要（今後Gdrive直接参照に一本化）。
3. **想定スケジュールからの遅延の可能性**：Google Doc「JALSG-PhALL219 ToDo」に記載のCRBスケジュール（変更審査2026-09-17〈8/20締切〉、終了報告2026-10-15〈9/17締切〉）に向けて、SAP最終固定・データ固定が必要。現時点(07-20)でSAP未固定・データロック未実施であり、遅延の有無をPI/データセンターに確認する必要がある。
4. **Box側データは2026-05-05以降更新なし**：input/rawdata・input/ext・defineXMLとも2026-05-05〜05-06納品のまま。2.5ヶ月以上、新規データ・照会対応の反映が無い。

## プログラム関連

5. **`program/JALSG-PhALL219_CSVtoSASDS.sas` がGML219からの流用のまま**：ファイルヘッダのプログラム名が `JPLSG-GML219_sasds.sas`、出力データセット名が `gml219`/`gml219_sae`、出力先が `input\ads\gml219.xlsx` 等、PhALL219向けの改修が行われていない（2026-03-10に一括追加後、無変更）。
6. **読み込み対象ドメイン不足**：同プログラムの `%sasds` マクロが呼び出す20ドメイン中、EG.csv, PE.csv, RELREC.csv, SC.csv の4つが現行input/rawdata（Local・Box共通）に存在しない。このままではプログラムが入力エラーで停止する。PhALL219のSDTM構成にこれらのドメインが無いのか、取得漏れなのか要確認。

## データ保管・同期関連

7. **`input/ext/saihi.csv`（FAS/SAF/PPS解析対象集団フラグ）がBox未反映**：2026-07-20時点で再確認したところ、Box `input/ext/` には依然として無い（facilities.csv・diseases.csv・ABL1変異解析2件のみ）。DS上のPROTOCOL DEVIATION/SCREEN FAILUREとの整合を見た再導出が必要で、この作業結果はまだBoxへ保存されていない。
8. ~~`~/Downloads` に生データ・SAP元エクスポートの重複が残置~~：2026-07-20時点で確認したところ解消済み（PhALL219関連の重複ファイルはDownloadsに見当たらず、GML219/GML226関連の無関係ファイルのみ残存）。
