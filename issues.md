# JALSG-PhALL219 — 既知の問題・制約

随時更新（2026-07-20 時点）

次アクションは [next-action.md](next-action.md) を参照。詳細根拠は [docs/state-survey.md](docs/state-survey.md)。

---

## SAP・データロック関連

1. **SAP未固定＋OPENコメント4件**：実体のGoogle Doc「JALSG-PhALL219 SAP」は最終更新2026-06-23のまま。2026-07-12付「SAP固定前・修正必須リスト」（`TMF/spec/sap_fix_before_lock_20260712.md`）が必須3件（§5.2.5治療/予防区分の矛盾、MR判定のオーツカ小数対応、早期死亡の3相別起算日）・PRT齟齬2件（RFS対象集団、移植後28日AE）・データ制約1件（死因内訳）を指摘済みだが、Google Doc更新日時が動いておらず未反映。
2. **ローカルSAPスナップショットが1ヶ月以上陳腐化**：`TMF/sap/JALSG-PhALL219 SAP 20260510.md` はGoogle Doc側の6月15日「第1版」以降の改訂（〜6/23）を反映していない。今後SAPを参照する際はGoogle Doc（ID `1T6UIqIU0Agspl7_mo7V1WU-HxIQQgBJa9VpRK28yfNQ`）を都度確認する必要がある。
3. **想定スケジュールからの遅延の可能性**：Google Doc「JALSG-PhALL219 ToDo」（2026-06-22更新）に記載の見込みでは、5月下旬頃にSAP固定・データ固定、統計解析責任者による最終解析開始（想定2ヶ月）を経て7-8月頃完了、というスケジュール感が示されている（テキスト抽出に文字化けがあり要目視確認）。現時点(07-20)でSAP未固定・データロック未実施であり、遅延の有無をPI/データセンターに確認する必要がある。
4. **Box側データは2026-05-05以降更新なし**：input/rawdata・input/ext・defineXMLとも2026-05-05〜05-06納品のまま。2.5ヶ月以上、新規データ・照会対応の反映が無い。

## プログラム関連

5. **`program/JALSG-PhALL219_CSVtoSASDS.sas` がGML219からの流用のまま**：ファイルヘッダのプログラム名が `JPLSG-GML219_sasds.sas`、出力データセット名が `gml219`/`gml219_sae`、出力先が `input\ads\gml219.xlsx` 等、PhALL219向けの改修が行われていない（2026-03-10に一括追加後、無変更）。
6. **読み込み対象ドメイン不足**：同プログラムの `%sasds` マクロが呼び出す20ドメイン中、EG.csv, PE.csv, RELREC.csv, SC.csv の4つが現行input/rawdata（Local・Box共通）に存在しない。このままではプログラムが入力エラーで停止する。PhALL219のSDTM構成にこれらのドメインが無いのか、取得漏れなのか要確認。

## データ保管・同期関連

7. **`input/ext/saihi.csv`（FAS/SAF/PPS解析対象集団フラグ）がBox未反映**：ローカルにのみ存在し、Box `input/ext/` には無い（facilities.csv・diseases.csv・ABL1変異解析2件のみ）。sap_fix_before_lock D-3指摘の通り、DS上のPROTOCOL DEVIATION4件・SCREEN FAILURE1件との整合を見た再導出が必要で、この作業結果はまだBoxへ保存されていない。
8. **`~/Downloads` に生データ・SAP元エクスポートの重複が残置**：`PhALL219_cdisc_260505_1617`（フォルダ・zip）、defineXML、SAP系.mdファイル一式。いずれもBox/リポジトリTMF内の既存コピーと日時・サイズが一致（新しいデータではない）が、生データがBox外に置かれた状態であり、整理（削除、または既にBoxに存在することの確認記録）が望ましい。
