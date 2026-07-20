# JALSG-PhALL219 — 状態インベントリ（Local / Box / Google Drive 突合）

調査日: 2026-07-20（読み取りのみ、メタ情報のみ。被験者データの中身は未開封）

---

## 1. リポジトリ（コード）

- `program/JALSG-PhALL219_CSVtoSASDS.sas`（2474行）: 2026-03-10に一括コミット（`8fe93d8 add pgm`）後、無変更。
  - ファイルヘッダのプログラム名が `JPLSG-GML219_sasds.sas` のまま（PhALL219向けにリネームされていない）。
  - 出力データセット名が `gml219` / `gml219_sae`、出力先が `&cwd.\input\ads\gml219.xlsx` 等、JALSG-GML219のプログラムをそのまま流用した状態。PhALL219向けの改修は未着手と判断される。
  - `%sasds` マクロで読み込む対象20ドメイン（rawdata: AE,CE,CM,CO,DD,DM,DS,EC,EG,FA,LB,MB,MH,PE,PR,QS,RELREC,RS,SC,VS）のうち、現行 `input/rawdata`（Local/Box共通）には16ドメインしか存在せず、**EG.csv, PE.csv, RELREC.csv, SC.csv が無い**。現状のままではこのプログラムは入力不足で最後まで実行できない。
- `overview.md` / `issues.md` / `next-action.md`: 最終更新 2026-07-04（`6713faf` bootstrap）。`issues.md` は「まだ記録なし」のまま。
- `autoexec.sas`: 2026-07-20新規追加（`a5f7171`）。box_root/repo_root自動解決。`&base` は `Box/Stat/Trials/JALSG/JALSG-PhALL219` を指す設定で、libname raw/sdtm/ads/ext を定義。program/output/log等はBox側パス。
- `.gitignore` により `/TMF`, `/input`, `/output`, `/log`, `/save`, `/compare`, `program/Archives` は全てgit管理外（意図的）。TMF配下のSAP/spec/protocolドキュメントもgit未追跡＝**このマシンのローカルにしか存在しない**（Box側にも同等物なし。詳細は§3参照）。

---

## 2. Local（このマシン、リポジトリ作業フォルダ以外）

### 2.1 リポジトリ内 `input/` `TMF/`（gitignore対象・ローカル実体）

- `input/rawdata/*.csv`（16ファイル）: 全てBoxの2026-05-05納品バッチと**ファイル名・サイズ・更新日時が完全一致**（例: `FA.csv` 2,073,386 bytes / 2026-05-05 16:19:14）。Local側に固有の新規データは無い。
- `input/ext/saihi.csv`（FAS/SAF/PPS解析対象集団フラグ、2185 bytes、2026-05-06 12:20:48）: **Boxには同名ファイルが存在しない**（§3.2参照）。ローカル限定の派生ファイル。
- `TMF/` 配下16ファイル（SAP・spec・protocol・aCRF）: 最新は `sap_fix_before_lock_20260712.md`（2026-07-13 0:06更新）。**Boxの `TMF/` フォルダは実質空**（§3.3参照）ため、これら分析計画文書一式はこのマシンにしか存在しない。

### 2.2 `~/Downloads`

- `PhALL219_cdisc_260505_1617/`（フォルダ）+ `PhALL219_cdisc_260505_1617.zip`、`define-2-0-0-PhALL219-20260505161357.xml`: Boxの2026-05-05バッチと同一物（日時・サイズ一致）。新しいデータではないが、生データがBox外（Downloads）に残置されている。
- `JALSG-PhALL219 SAP.md` / `SAP (1).md` / `SAP 20260506.md` / `SAP 20260510.md`、`jalsg-phall219-acrf.csv`: リポジトリ `TMF/` 内の同名ファイルと**サイズ・更新日時が完全一致**＝TMFへコピーする際の元ファイル。Downloads側にも2026-05-10より後の版は無い（Google Doc側の6月改訂はどこにも書き出されていない）。
- その他: `enrollments_status_PhALL219.csv`（2022年）、COI関連zip/xlsx（2021-2024年）等、統計解析と無関係な事務書類。

### 2.3 その他

- `Documents`: PhALL219関連ファイルなし。
- `Desktop`: `20260627desktop整理\...\2023　JALSG-PhALL219.pdf`（契約書アーカイブ、2024年、無関係）のみ。
- `Dropbox (個人)`: 2019〜2025年度のOSCR業務委託契約書・見積書・請求書のみ（統計解析とは無関係な事務・経理書類）。
- `NMC Dropbox`, `OneDrive`: PhALL219関連ファイルなし。

---

## 3. Box Drive（ローカルマウント `Stat\Trials\JALSG\JALSG-PhALL219`）

### 3.1 全体

- トップフォルダ全体で **2026-05-10より後に更新されたファイルは1件も無い**（`Get-ChildItem -Recurse` で確認）。2026-05-05のSDTM相当データ納品以降、新規データ・照会対応の反映は無い。

### 3.2 input

- `input/rawdata/*.csv`（16ファイル、2026-05-05 16:19:14）＋ `defineXML/`（2026-05-06）＋ `PhALL219_cdisc_260505_1617/`（同日、別形式の同一エクスポート）＋ `20260401 test data/`（64ファイル、EDC生データ形式、2026-04-01納品のテストデータ）。
- `input/ext/`: `facilities.csv`(2026-04-01), `diseases.csv`(2025-12-05), `ABL1変異解析_PN変更.csv`/`ABL1変異解析_再発.csv`(2026-05-05)の4ファイルのみ。**`saihi.csv` は無い**（Local限定、§2.1）。
- `input/sdtm/`, `input/ads/`（`QC/`含む）: フォルダのみ存在、中身のSASデータセットは0件（2026-03-13の雛形作成以降変化なし）。

### 3.3 TMF / program / output / log

- `TMF/aCRF/`: フォルダは2026-05-06更新表示だが、中身のファイルは0件（空）。`TMF/sap`, `TMF/spec`, `TMF/protocol` に相当するサブフォルダ自体が無い。→ SAP・spec・protocolドキュメントはBoxに一切バックアップされていない。
- `program/`, `program/macro/`, `program/QC/`, `output/`, `output/QC/`, `log/`, `log/QC/`: いずれもフォルダのみ（2026-03-13作成の雛形のまま）、中身のプログラム・出力・ログは0件。

---

## 4. Google Drive（gdrive MCP経由で確認、接続可）

`fullText contains 'PhALL219'` / `title contains 'PhALL219'` で検索した関連ファイル（更新日順）:

| ドキュメント | 種別 | 最終更新 | 備考 |
|---|---|---|---|
| **JALSG-PhALL219 SAP**（`1T6UIqIU0Agspl7_mo7V1WU-HxIQQgBJa9VpRK28yfNQ`） | Google Doc | **2026-06-23** | 統計解析計画書の実体。第1版作成2026-06-15。**OPENコメント4件が未解決**（`sap_fix_before_lock_20260712.md` 記載）。Local `TMF/sap/*20260510.md` はこの版を反映していない（1ヶ月以上前のスナップショットで停止）。 |
| JALSG-PhALL219 ToDo（`1SedqSBdgp4hnqzETvyUQOnindpoLhL7z49I9jGHtFGA`） | Google Doc | 2026-06-22 | DC運用のTo Doリスト（regulatory/CRB/COI中心）。§1.4に最終解析スケジュール見込み記載（テキスト抽出に取消線由来と見られる文字化けあり、目視要確認）: 概ね「2026年5月下旬までにSAP固定・データ固定」「統計解析責任者による最終解析開始（2ヶ月間）」「完了後PIが総括報告書作成、9-11月頃に終了報告審査」という想定。**現時点(07-20)でSAP未固定・データロック未実施であり、この想定スケジュールから遅延している可能性が高い**。 |
| JALSG-PhALL219 PRT（`16o-gZAnxSDWjH9MEArtcG387gOaaLK_7T-Tge_qOaBo`） | Google Doc | 2026-05-06 | プロトコル本体。Local `TMF/protocol/protocol_v1.9.md`（2026-05-06）と一致。 |
| JALSG PhALL219 SAR preparation（`1A9_MXJ6cH528Gz2yiCNxFT4fO6TSYk3GBvmQB2M98yg`） | Google Doc | 2026-05-12 | 本日(2026-07-20)閲覧履歴あり＝直近で参照された形跡。内容は未確認（範囲外のため深追いせず）。 |
| PhALL219 症例報告書入力の手引/FAQ（`1Zsy8rj9rFhWLb-RZwCo0n88D8aM_rDq0mkDdRQqPMDM`） | Google Doc | 2026-04-13 | CRF入力手引き。参考資料。 |
| フォルダ「PhALL219」（`1udtZEgT8i_l0oIdnpOkht2qMuu5ajIwo`） | フォルダ | 2018年 | 旧トライアル登録時の遺物、現行の解析作業とは無関係。 |

---

## 5. 総括（到達点）

| 項目 | 状態 |
|---|---|
| SAP確定 | **未確定**。Google Doc最終更新2026-06-23、OPENコメント4件。2026-07-12付修正必須リストの指摘が未反映。 |
| データロック | **未実施**。Box側データは2026-05-05納品バッチのまま更新なし。 |
| マスタDS作成プログラム | 作成中（2474行）だが**GML219からの流用のまま**でPhALL219向け改修未着手。参照CSVの一部（EG/PE/RELREC/SC）が現行データに存在せず、このままでは実行不可。 |
| SDTM/ADS | Box側は雛形フォルダのみ、SASデータセット0件。 |
| 図表プログラム・QC | 未着手（Box program/output/log/QCは全て空フォルダ）。 |
| データ保管の一元化 | `input/ext/saihi.csv` がBox未反映、Downloadsに2026-05-05データの重複が残置。 |
