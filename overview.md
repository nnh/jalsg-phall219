# JALSG-PhALL219 — 概要

随時更新（2026-07-21 時点）

## 一文要約

初発BCR-ABL1陽性ALLを対象としたDA（ダサチニブ）+PN（ポナチニブ）併用化学療法+造血幹細胞移植の第II相試験（90例登録）。

## 現在の状況

**SAP最終固定完了（2026-07-21、第1〜5章）**。実体はGoogle Docs「JALSG-PhALL219 SAP」。PI・齋藤先生間のメールやり取りとSAP/PRT最新版（Gdrive直接取得）を突合して各論点を整理し（[docs/sap-open-issues.md](docs/sap-open-issues.md)）、`docs/sap-edits-todo.md`の修正案をもとにSAP本体を編集。最後に§4.4.11（BCR-ABLサブタイプ別サブグループ解析）の文言を微修正して固定。OPENコメント4件は全て解決、fix-list必須3件・PRT齟齬2件・データ制約1件も全て反映または対応不要と確認済み。SAP関連の対応は完了。

**データロックは翌日（次回作業日）実施予定**。Box側の生データは2026-05-05納品バッチ以降、更新なし（実施時に新規データの有無を再確認）。

`program/JALSG-PhALL219_CSVtoSASDS.sas`（マスタデータセット作成プログラム、2474行）は2026-03-10に一括追加後、無変更。中身はJALSG-GML219用プログラムをほぼそのまま流用しており（ファイルヘッダ名・出力データセット名gml219・出力先パスがGML219のまま）、PhALL219向けの改修が未着手。読み込み対象20ドメイン中4つ（EG, PE, RELREC, SC）は現行input/rawdataに存在せず、このままでは最後まで実行できない。

SDTM/ADS/図表・QCプログラムは未着手（Box側は雛形フォルダのみ、SASデータセット0件）。

詳細な状態インベントリ（Local/Box/Google Drive突合）は [docs/state-survey.md](docs/state-survey.md) を参照。

## GitHub / Box

- GitHubリポジトリ：https://github.com/nnh/jalsg-phall219
- Boxフォルダ：https://nmccrc.app.box.com/folder/370878808437

対応関係の一覧はstat-hubリポジトリの [overview.md](https://github.com/saito-la/stat-hub/blob/main/overview.md) の「対象試験一覧」にも記録する。

## 関連

- 既知の問題：[issues.md](issues.md)
- 次アクション：[next-action.md](next-action.md)
- 試験横断の汎用解析メソッド（SAS/R二重コーディング＋CDISC ARS）は [akiko-office](https://github.com/akikomsaito/akiko-office/tree/main/docs/methods) を参照
