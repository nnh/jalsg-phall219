# JALSG-PhALL219 Action Items

> このファイルはフォルダを開くと自動で表示されます。完了したら `[x]` に変更し、不要になったら削除してください。

最終更新: 2026-07-21

---

## 初回セットアップ

- [x] CLAUDE.md・overview.md・issues.md・next-action.md を作成する
- [ ] 齋藤（`tosh13`）を読み取り権限のコラボレーターとして追加する：**要確認**。2026-07-21時点でtosh13（Toshiki Saito）からmasterへの直接コミット（`docs/analysis-pipeline-plan.md`・`docs/cdisc-ars.md`追加）を確認しており、既に読み取り以上の権限を持っている可能性がある。

## Toshikiさんとの打合せ事項（次回）

- [ ] 2026-07-21にtosh13さんが追加した`docs/analysis-pipeline-plan.md`・`docs/cdisc-ars.md`（汎用の解析パイプライン計画・CDISC ARS調査メモ）について、内容がPhALL219固有でなく汎用的に見えるため、このリポジトリに置く意図か確認する（CLAUDE.mdは本リポジトリを「試験JALSG-PhALL219専用」と位置づけている）。

## SAP OPENコメント・修正必須リストの論点整理

- [x] Copilotによるメール整理結果（土橋先生・齋藤先生間、2026年5〜7月）とSAP/PRT最新版（Gdrive直接取得）を突合し、各論点の結論・根拠を整理（[docs/sap-open-issues.md](docs/sap-open-issues.md)参照）
- [x] ②RFS起算日：LFS到達日で確定（解決）
- [x] ③RFS対象集団：#49を含める（広義解釈、現行SAP文言通り）で最終決定。SAP本文の既存記載で説明として十分なため、追加の決定理由注記は不要と最終判断（解決）
- [x] ④移植後TKI治療/予防区分：直近MR評価（移植前後問わず）に基づき区分、ND/DTなら治療投与で結論（解決）
- [x] fix-list必須3件のうち残り2件（MR判定オーツカ小数対応、早期死亡3相別起算日）：SAP本体に反映済みを確認
- [x] PRT齟齬2件のうち残り1件（移植後28日AE集計）：SAP本体に反映済みを確認
- [x] データ制約1件（死因内訳）：明子さん確認済み。`xx(%)`は実データ未集計の想定通りのプレースホルダーで対応不要（[docs/sap-open-issues.md](docs/sap-open-issues.md)参照）

## SAP固定（2026-07-21 完了・確定版）

- [x] `docs/sap-edits-todo.md` の修正案をもとにSAP本体（Google Doc `1T6UIqIU0Agspl7_mo7V1WU-HxIQQgBJa9VpRK28yfNQ`、第1〜5章）を編集・**固定**。OPENコメント4件→0件（解決操作済み）。
- [x] 明子さんが§4.4.11（BCR-ABLサブタイプ別サブグループ解析、探索的）の文言を微修正（post-IC→「強化地固め療法後」、neutrophil→「末梢血好中球」等の明確化。解析内容自体の変更なし）したうえで**SAP最終固定**。再取得して他の反映済み項目に変更が無いことも確認済み。**SAP関連の対応は完了。**

## 直近（着手可能な順）

- [ ] **データロック**：明子さんが翌日（次回作業日）実施予定。実施後、Box側の新規データ反映有無を確認する
- [ ] `input/ext/saihi.csv`（FAS/SAF/PPSフラグ）のBox退避：**本セッションで確認したところ未完了**（Box `input/ext/`は`facilities.csv`・`diseases.csv`・ABL1変異解析2件のみで`saihi.csv`は無い）。DS上のPROTOCOL DEVIATION/SCREEN FAILUREとの整合を見て再導出のうえBoxに保存する
- [ ] **`JALSG-PhALL219_CSVtoSASDS.sas` をPhALL219向けに改修する**（GML219由来のファイル名・出力データセット名gml219・出力パスの置換、EG/PE/RELREC/SCドメイン読み込みの要否確認）
- [ ] SDTM/ADS作成・STAT図表プログラム・QCプログラムに着手する（Box側は雛形フォルダのみで中身0件）
- [ ] `~/Downloads` に残るデータ重複の整理（本セッションで確認したところ、以前のSAP/PhALL219関連の重複ファイルは既に整理済みとみられる。生データzip等の残置有無は次回改めて確認）

## 運用上の注意（今回判明した点）

- SAP/PRTは今後Gdriveに直接接続して最新版を都度確認する（`TMF/`配下のローカル`.md`スナップショットはGdrive直接接続が確立する前の代替手段であり、廃止して問題ない）。
