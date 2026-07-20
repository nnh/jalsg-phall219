# JALSG-PhALL219 Action Items

> このファイルはフォルダを開くと自動で表示されます。完了したら `[x]` に変更し、不要になったら削除してください。

最終更新: 2026-07-20

---

## 初回セットアップ

- [x] CLAUDE.md・overview.md・issues.md・next-action.md を作成する
- [ ] 齋藤（`tosh13`）を読み取り権限のコラボレーターとして追加する

## SAP OPENコメント・修正必須リストの論点整理

- [x] Copilotによるメール整理結果（土橋先生・齋藤先生間、2026年5〜7月）とSAP/PRT最新版（Gdrive直接取得）を突合し、各論点の結論・根拠を整理（[docs/sap-open-issues.md](docs/sap-open-issues.md)参照）
- [x] ②RFS起算日：LFS到達日で確定（解決）
- [x] ③RFS対象集団：CHR/CHRp到達例のみ・#49除外で結論（解決。ただし**現行SAP文言が逆の内容になっているため要修正**、[docs/sap-edits-todo.md](docs/sap-edits-todo.md) §1参照）
- [x] ④移植後TKI治療/予防区分：直近MR評価（移植前後問わず）に基づき区分、ND/DTなら治療投与で結論（解決）
- [ ] fix-list必須3件のうち残り2件（MR判定オーツカ小数対応、早期死亡3相別起算日）：メール上の明示合意記録なし。PI確認要（[docs/sap-edits-todo.md](docs/sap-edits-todo.md) §3, §4に提案文あり）
- [ ] PRT齟齬2件のうち残り1件（移植後28日AE集計）：SAPに規定が欠落。PI確認要（同 §5）
- [ ] データ制約1件（死因内訳）：分類粒度が未確定。データセンター確認要（同 §6）

## 直近（着手可能な順）

- [ ] `docs/sap-edits-todo.md` の修正案をもとにSAP本体（Google Doc `1T6UIqIU0Agspl7_mo7V1WU-HxIQQgBJa9VpRK28yfNQ`）に反映する（③の現行文との矛盾はPI最終確認後に修正）
- [ ] SAP編集後、対応するOPENコメント4件（`AAAB5_mRGOo`, `AAAB6CTrRy0`, `AAAB6CTrRyo`, `AAAB6CHNjfE`）をGoogle Doc上で解決（Resolve）する
- [ ] 未解決3件（オーツカ小数対応・早期死亡3相別起算日・移植後28日AE・死因内訳）をPI/データセンターと確認し、SAPに反映後 `docs/sap-open-issues.md` を更新する
- [ ] **SAP固定**（上記すべて反映後）
- [ ] **データロック**を実施する（Box側は2026-05-05納品バッチ以降更新なし。固定前に新規データの有無を再確認）
- [ ] `input/ext/saihi.csv`（FAS/SAF/PPSフラグ）のBox退避：**本セッションで確認したところ未完了**（Box `input/ext/`は`facilities.csv`・`diseases.csv`・ABL1変異解析2件のみで`saihi.csv`は無い）。DS上のPROTOCOL DEVIATION/SCREEN FAILUREとの整合を見て再導出のうえBoxに保存する
- [ ] **`JALSG-PhALL219_CSVtoSASDS.sas` をPhALL219向けに改修する**（GML219由来のファイル名・出力データセット名gml219・出力パスの置換、EG/PE/RELREC/SCドメイン読み込みの要否確認）
- [ ] SDTM/ADS作成・STAT図表プログラム・QCプログラムに着手する（Box側は雛形フォルダのみで中身0件）
- [ ] `~/Downloads` に残るデータ重複の整理（本セッションで確認したところ、以前のSAP/PhALL219関連の重複ファイルは既に整理済みとみられる。生データzip等の残置有無は次回改めて確認）

## 運用上の注意（今回判明した点）

- SAP/PRTは今後Gdriveに直接接続して最新版を都度確認する（`TMF/`配下のローカル`.md`スナップショットはGdrive直接接続が確立する前の代替手段であり、廃止して問題ない）。
