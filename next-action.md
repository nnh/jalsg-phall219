# JALSG-PhALL219 Action Items

> このファイルはフォルダを開くと自動で表示されます。完了したら `[x]` に変更し、不要になったら削除してください。

最終更新: 2026-07-20

---

## 初回セットアップ

- [x] CLAUDE.md・overview.md・issues.md・next-action.md を作成する
- [ ] 齋藤（`tosh13`）を読み取り権限のコラボレーターとして追加する

## 直近（着手可能な順）

- [ ] SAP（Google Doc `1T6UIqIU0Agspl7_mo7V1WU-HxIQQgBJa9VpRK28yfNQ`）のOPENコメント4件・`TMF/spec/sap_fix_before_lock_20260712.md` の必須指摘3件（§5.2.5治療/予防区分、MR判定、早期死亡起算日）をPIと確認しSAP本体に反映する
- [ ] 同リストのPRT齟齬2件（RFS対象集団、移植後28日AE）の方針をPIと確定する
- [ ] SAP固定・データロックの想定スケジュール（Google Doc「ToDo」記載）からの遅延有無をPI/データセンターに確認する
- [ ] SAP確定後、データロックを実施する（Box側は2026-05-05納品バッチ以降更新なし。新規データの有無を確認）
- [ ] `input/ext/saihi.csv`（FAS/SAF/PPSフラグ）をDS上のPROTOCOL DEVIATION/SCREEN FAILUREとの整合を見て再導出し、Boxにも保存する
- [ ] `JALSG-PhALL219_CSVtoSASDS.sas` をPhALL219向けに改修する（GML219由来のファイル名・出力データセット名gml219・出力パスの置換、EG/PE/RELREC/SCドメイン読み込みの要否確認）
- [ ] SDTM/ADS作成・STAT図表プログラム・QCプログラムに着手する（Box側は雛形フォルダのみで中身0件）
- [ ] `~/Downloads` に残る2026-05-05データ・SAP元エクスポートの重複を整理する（Box/リポジトリ内の既存コピーと一致確認済み）
