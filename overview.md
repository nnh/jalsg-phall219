# JALSG-PhALL219 — 概要

随時更新（2026-07-20 時点）

## 一文要約

初発BCR-ABL1陽性ALLを対象としたDA（ダサチニブ）+PN（ポナチニブ）併用化学療法+造血幹細胞移植の第II相試験（90例登録）。

## 現在の状況

SAP未確定。実体はGoogle Docs「JALSG-PhALL219 SAP」（OPENコメント4件）。2026-07-20時点でPI・齋藤先生間のメールやり取りとSAP/PRT最新版（Gdrive直接取得）を突合し、各論点の結論を整理した（[docs/sap-open-issues.md](docs/sap-open-issues.md)）。OPENコメントのうち2件（RFS起算日・対象集団、移植後TKI治療/予防区分）は結論が出ている。RFS対象集団（#49の扱い）は2026-07-20の症例検討会で最終決定し、現行SAP本文の広義解釈（#49を含める）を採用のうえ決定理由（CRi文献動向）を注記追加することとした（[docs/sap-edits-todo.md](docs/sap-edits-todo.md)）。fix-list必須3件のうち2件（MR判定オーツカ小数対応、早期死亡3相別起算日）とPRT齟齬1件（移植後28日AE）・データ制約1件（死因内訳）はメール上に明示合意記録がなくPI確認待ち。

データロックは未実施。Box側の生データは2026-05-05納品バッチ以降、更新なし（2.5ヶ月以上新規データ・照会対応の反映なし）。

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
