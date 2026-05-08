# 臨床試験SAS解析 - Claude Code 利用ナレッジ

作成日: 2026-05-05  
最終更新: 2026-05-08  
概要: JALSG-GML219 / JALSG-PhALL219 を通じて得た知見。AML・ALL・血液腫瘍系試験に流用可能なノウハウ。

**更新履歴**:
- 2026-05-05: 初版（GML219で得た §1〜§6）
- 2026-05-08: PhALL219 計画段階で得た知見を追加 (§5.5 / §5.6 / §7〜§11)、§5.2/§5.3 を疾患別に整理

**保管場所**: 本ファイルは PhALL219 プロジェクトでの更新版。GML219 オリジナル（`JALSG-GML219/docs/SAS_ClinicalTrial_ClaudeCode_共通ナレッジ.md`）への反映はユーザー判断でマージ。

---

## 1. 開発環境セットアップ

### 1.1 RTK（トークン節約ツール）のインストール（Windows）

RTK（Rust Token Killer）はコマンド出力をフィルタリングしトークン消費を 60〜90% 削減するプロキシ。

```powershell
# GitHub Releases から Windows バイナリを取得
$url  = "https://github.com/rtk-ai/rtk/releases/latest/download/rtk-x86_64-pc-windows-msvc.zip"
$dest = "$env:LOCALAPPDATA\rtk"
Invoke-WebRequest -Uri $url -OutFile "$env:TEMP\rtk.zip"
Expand-Archive "$env:TEMP\rtk.zip" -DestinationPath $dest -Force

# ユーザー PATH に追加
$p = [System.Environment]::GetEnvironmentVariable("PATH","User")
[System.Environment]::SetEnvironmentVariable("PATH","$p;$dest","User")

# Claude Code に初期化
rtk init      # プロジェクト CLAUDE.md に追記
rtk init -g   # グローバルフック登録（要 settings.json 手動追記）
```

`~/.claude/settings.json` に追加:
```json
"hooks": {
  "PreToolUse": [{"matcher": "Bash",
    "hooks": [{"type": "command", "command": "rtk hook claude"}]}]
}
```

### 1.2 SAS バッチ実行

```powershell
$sas = "C:\Program Files\SASHome\SASFoundation\9.4\sas.exe"
& $sas -sysin "path\to\program.sas" -log "path\to\program.log" -nosplash -nologo
```

### 1.3 PowerShellターミナルの文字コード（UTF-8化）

Windows PowerShell の既定はCP932（Shift-JIS）。Markdownや解析仕様書はUTF-8で保管するため、Claude Codeのセッション開始時に以下を実行：

```powershell
chcp 65001 | Out-Null
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
```

これを行わないと、Get-ContentやWrite-Output経由で日本語を表示すると文字化けする（例：「統計解析」→「邨ｱ險郁ｧ｣譫舌」）。**ただしSASファイルはCP932固定**（§2.1参照）。

---

## 2. ファイル管理・文字コード

### 2.1 SAS ファイルは Shift-JIS（CP932）で読み書き

Claude Code の `Edit` ツールは UTF-8 で書き出すため **SAS ファイルへの使用禁止**。  
PowerShell のみ使用すること。

```powershell
$enc = [System.Text.Encoding]::GetEncoding(932)

# 読み込み
$content = [System.IO.File]::ReadAllText($path, $enc)

# 書き出し
[System.IO.File]::WriteAllText($path, $content, $enc)
```

### 2.2 PowerShell here-string の注意点

**必ずシングルクォート `@'...'@` を使う。**  
ダブルクォート `@"..."@` は SAS フォーマット指定子（`$200.` 等）を PowerShell 変数として展開し空文字に置換する。

```powershell
# NG: $200. が消えて length c1 . になる
$body = @"
length c1 $200. c2-c5 $30.;
"@

# OK
$body = @'
length c1 $200. c2-c5 $30.;
'@
```

可変値を埋め込む場合は `-f` 演算子を使う:
```powershell
$body = ('proc tabulate data={0};' -f $dsname)
```

### 2.3 CRLF の統一

PowerShell here-string は LF のみ。既存ファイルが CRLF の場合は置換後に正規化する。

```powershell
$content = $content -replace "`r?`n", "`r`n"
```

### 2.4 .gitignore 推奨設定（SAS プロジェクト）

```
/input          # 生データ（機密）
/output         # 生成 RTF
/log            # SAS ログ
/TMF            # プロトコル・SAP・aCRF（機密含む）
*.sas7bdat
*.xlsx
*.csv
*.log
*.lst
```

---

## 3. SAS プログラム共通パターン

### 3.1 working_dir マクロ（自動パス解決）

`program/` フォルダ直下のプログラムでプロジェクトルートを自動取得するマクロ。

```sas
%macro working_dir;
    %local _fullpath _path;
    %let _fullpath = ;
    %if %length(%sysfunc(getoption(sysin))) = 0 %then
        %let _fullpath = %sysget(sas_execfilepath);
    %else
        %let _fullpath = %sysfunc(getoption(sysin));
    %let _path = %substr(&_fullpath., 1, %length(&_fullpath.)
                       - %length(%scan(&_fullpath.,-1,'\'))
                       - %length(%scan(&_fullpath.,-2,'\'))
                       - 2 );
    &_path.
%mend working_dir;

%let _wk_path = %working_dir;
```

**注意**: `%scan` の区切り文字は **シングルクォート `'\'`** で囲むこと。  
バッククォート `` `\` `` にするとパスが壊れる（SAS がエスケープ文字として解釈）。

### 3.2 CSVtoSASDS 設計パターン

SDTM ドメイン CSV から解析用データセットを構築するプログラムの推奨構成:

```
§1  ライブラリ・マクロ定義
§2  基本情報（DM: 性別・年齢・登録日）
§3  適格性フラグ（FAS/PPS/SAF）
§4  疾患情報（診断時LB/FA/MB）
§5  既往・合併症（MH）
§6  バイタル・身体計測（VS）
§7〜§9  治療（EC: コース別投与・IT・TKI）
§10 効果判定（RS: HEMARESP/MOLRESP）
§11 移植情報（PR + FA@GVHD/Engraftment）
§12 AE縦持ち→wide集約（AE + FA@PRE-SPECIFIED AE GRADE）
§13 検査値経時（LB）
§14 併用薬・補助療法（CM）
§15 時間-イベント解析（efs_plan_vX.Y準拠）
§16 後治療・最終転帰（DS@FOLLOW-UP, DD）
§17 dose intensity計算
§18 マージ・QC
§19 最終出力（ADaM群 + Wide master）  ← §9参照
```

### 3.3 AE テーブルマクロパターン

コース別 × グレード別 AE 頻度表の実装パターン:

```sas
%macro ae_row(num, name);
  data ae&num;
    length c1 $200. c2-c6 $30.;
    retain g1-g5 0;
    set tmp_pop end=eof;
    if _gae&num&_cycl_ = 1 then g1 + 1;
    if _gae&num&_cycl_ = 2 then g2 + 1;
    if _gae&num&_cycl_ = 3 then g3 + 1;
    if _gae&num&_cycl_ = 4 then g4 + 1;
    if _gae&num&_cycl_ = 5 then g5 + 1;
    if eof then do;
      any = g1 + g2 + g3 + g4 + g5;
      /* ... n(%) を c2〜c6 に格納 */
      keep c1-c6; output;
    end;
  run;
%mend;

/* macro parameter に = を含む場合は必ず %str() で囲む */
%ae_table(i1, %str(fasfl="Y"), 寛解導入1)
```

**重要**: `proc report` の `column` 文に全列を明示すること。  
`define c6` を書いても `column` 文に `c6` がなければ表示されない。

```sas
column c1 ("Grade" c2 c3 c4 c5 c6);   /* <-- 追加した列を忘れずに */
define c6 / style(header)=[width=2.2cm];
```

---

## 4. よくあるエラーと解決策

| エラー内容 | 原因 | 解決策 |
|---|---|---|
| `length c1 . c2-c5 .;` になっている | PowerShell `@"..."@` が `$200.` を展開 | `@'...'@` に変更 |
| `working_dir` が誤ったパスを返す | `%scan` 区切り文字がバッククォート | `'\'` にシングルクォートで変更 |
| `proc report` で列が表示されない | `column` 文に列名が抜けている | `column` 文に全列を追加 |
| `定位置パラメータはすべてキーワードパラメータより前` | `%macro(arg, cond="Y")` に `=` が含まれる | `%str(cond="Y")` でラップ |
| `c1 の幅が 1 と 120 の範囲にありません` | `ls=120` が短すぎる | `ls=200` に変更 |
| `ERROR: 値'%'は無効な SAS 名` | label 文に `%` が含まれる | label から `%` を除去または `%str(%)` でエスケープ |
| `Invalid numeric data 'Baseline'` | `length timepoint ord 8.` で文字変数が数値宣言 | `length timepoint $40. ord 8. wt1 8.` と明示的に型を分ける |
| 日本語が「邨ｱ險郁ｧ｣譫」のように化ける | PowerShell ターミナルが CP932 | `chcp 65001` + `[Console]::OutputEncoding = [Text.Encoding]::UTF8` |

---

## 5. エンドポイント計算パターン（CDISC 準拠）

### 5.1 DS ドメインの構造（血液腫瘍系試験）

DS ドメインには 1 症例につき通常 **2 レコード** が存在する:

| DSSPID | EPOCH | 内容 | DSSTDTC の意味 |
|---|---|---|---|
| `"discontinuation"` / `"discon"` | `"TREATMENT"` | 治療中止・完了 | 治療終了日 |
| `"withdrawal"` | `"FOLLOW-UP"` | 最終追跡・死亡 | **最終追跡日 / 死亡日** |
| `"tki_change1"`（PhALL219） | `"TREATMENT"` | TKI変更（DA→PN等） | TKI変更日 |

打ち切り日・死亡日は `withdrawal` レコードの `DSSTDTC` を使用する。  
`discontinuation` の日付は治療終了日であり打ち切り日ではない。

### 5.2 EFS/OS/RFS 計算ロジック（AML：JALSG-GML219）

GML219（AML）の EFS 治療不応のイベント日は **DS 中止日ではなく RS 評価日を使う**:

```sas
/* AML: RSTESTCD='OVRLRESP', RSORRES='CR' で寛解判定 */
if crfl ne "Y" then do;
  if rsdt_ev2 ne . then edt_fail = rsdt_ev2;     /* eval2 完了 → eval2 RSDTC */
  else if rsdt_ev1 ne . then edt_fail = rsdt_ev1; /* eval1 のみ → eval1 RSDTC */
end;

/* RFS 起算日: 登録日ではなく CR（または LFS）到達日 */
/* PRT に lfsdt が規定されている場合は lfsdt を使うこと */
rfs_d = rfsdt - lfsdt + 1;
```

### 5.3 CR 判定ルール（AML：JALSG-GML219）

```sas
/* AML の CR は寛解導入コース後の評価のみ対象 */
/* 地固め以降の評価は CR 判定に含めない */
where rstestcd = "OVRLRESP"
  and rsorres = "CR"
  and rsspid in ("evaluation1", "evaluation2");
```

`FAILURE TO MEET CONTINUATION CRITERIA`（FTMCC）は**行政的中止であり治療不応ではない**。  
EFS イベントには含めず、CR の有無を RS ドメインで確認すること。

### 5.4 LFS（Leukemia-free Survival）の扱い（AML 一般）

LFS = CR より緩い基準（骨髄芽球 < 5% かつ髄外病変なし）。  
RS ドメインに CRi/LFS の専用値がない場合は **CR ≈ LFS の保守的近似**を使用:

```sas
lfsfl = crfl;   /* TODO: LB+FA による厳密判定に将来変更 */
lfsdt = crdt;
```

RFS 起算日は PRT の規定に従い、`crdt` ではなく `lfsdt` を使うこと（PRT v2.4 §8.1.1 等）。

### 5.5 疾患別の効果判定差（PhALL219 で確認）

血液腫瘍系試験は疾患により効果判定の SDTM 表現が大きく異なる。**他試験のロジックをそのまま流用してはいけない**。

| 試験 | 疾患 | RSTESTCD | RSORRES の取りうる値 | EFS の「寛解」 |
|---|---|---|---|---|
| GML219 | AML（CML 由来） | `OVRLRESP` | `CR`, `PR`, `NR` 等 | CR |
| PhALL219 | Ph+ALL | `HEMARESP` | `CHR`, `CHRp`, `LFS`, `PR`, `NON-PR`, `TREATMENT FAILURE` | CHR/CHRp（CHRpを含める運用） |

**重要な階層関係（PhALL219）**:
- `CHR` ⊃ `CHRp` ⊃ `LFS` ⊃ `PR` ⊃ `NON-PR`（緩い順）
- VISITNUM=310 で CHR/CHRp 達成 → 410 で LFS でも CHR 達成例として扱う（プロトコル本試験規定）
- `LFS` 単独到達例は CHR 未達で、CE再発が記録されても EFS再発に該当しない

**実装上の指針**:
- CR/CHR の判定は試験ごとの `efs_plan_vX.Y.md` を確認する
- 「CR が CHR/CHRp/LFS のどれに対応するか」「単独達成と階層達成のどちらか」を最初に明文化する
- AML の `OVRLRESP` ロジックを ALL に流用するとイベントを取りこぼすか過大に計上する

### 5.6 試験別 EFS/RFS ロジックの管理方針（PhALL219 で確立）

EFS/OS/RFS の抽出ロジックは試験規定により細部が異なるため、**試験ごとに独立した仕様書**を作成する：

```
TMF/spec/
  └─ efs_plan_v0.X.md       本試験規定の EFS抽出ロジック（疑似コード + 図）
  └─ efs_logic_v0.X.md       SAS実装に落とすための擬似コード
  └─ efficacy_mapping_v0.X.md プロトコル定義 → SDTM変数 マッピング
  └─ efs_subject_check_v0.X.csv 全例の予測検算（QCの正解値）
  └─ efs_open_issues_v0.X.md  未解決事項
```

**版管理ルール**:
- 主要な定義変更（NR/REL/DTH の取り方、起算日、対象母集団）が起きた場合は v0.1 → v0.2 と上げる
- 共通ナレッジ（本ファイル）には**試験を跨いで共通な手順**のみ書き、本試験固有のロジックは仕様書側に置く

**典型的な分岐点**:
- NR_DT を「RS の評価日」から取るか「DS の中止日」から取るか
- 同日複数イベント発生時の優先順位（NR > REL > DTH 等）
- 「CR」が単一カテゴリか階層構造（PhALL219の CHR/CHRp）か
- RFS 起算日（プロトコルにより CR到達日 / LFS到達日 / 強化地固め完了日 等）

### 5.7 同日複数イベントの tie-break ルール（PhALL219 確立）

EFS でイベント日が同日に複数発生した場合（例：PhALL219-0006 で NR と REL が同じ 2020-05-25）：

```
event_typ tie-break: NR > REL > DTH
```

理由：「治療抵抗で再発前に判定された場合は NR、それを超えた死亡は DTH」というプロトコル意図に整合。SAP 固定時に明文化する。

---

## 6. プロジェクトフォルダ構成（推奨テンプレート）

```
PROJECT_NAME/
├── input/
│   ├── rawdata/       # SDTM ドメイン別 CSV
│   ├── ads/           # 解析用データセット（*.sas7bdat）
│   └── ext/           # 外部データ（施設一覧等）
├── program/
│   ├── macro/         # 共通マクロ（km_pt.sas 等）
│   └── vX_旧版/       # 旧バージョン（参照のみ・編集禁止）
├── output/            # RTF 出力
├── log/               # SAS ログ
├── docs/              # 記録類（本ファイル等）
├── TMF/               # PRT・SAP・aCRF・解析仕様書
│   ├── protocol/      # プロトコル
│   ├── sap/           # SAP 本体
│   ├── spec/          # 解析仕様書（efs_plan, sap_review, analysis_plan）
│   └── aCRF/          # アノテートCRF
└── CLAUDE.md
```

---

## 7. SAP 事前レビューフロー（PhALL219 で確立）

データ固定前にSAPを最終レビューする際の標準手順。プロトコルとSDTM/aCRFを突合し、不整合・曖昧な箇所を「修正前/修正後」形式で具体提案する。

### 7.1 入力準備

| 入力 | 場所 | 確認ポイント |
|---|---|---|
| プロトコル | `TMF/protocol/protocol_vX.Y.md` | 8.1（効果判定）、8.1.11（生存解析）、9章（解析計画） |
| SAP（レビュー対象） | `TMF/sap/{試験ID} SAP YYYYMMDD.md` | 4章（解析方法）、5章（図表案） |
| aCRF一覧 | `TMF/aCRF/{試験ID}-acrf.csv` | フォーム名と URL の対応 |
| SDTMサンプル | `input/rawdata/*.csv` | DOMAIN/SPID/VISITNUM/RSORRES等の値域 |

### 7.2 レビュー観点

1. **EFS/OS/RFS の Event定義一致**：4章本文と5章図表案で文言が違わないか
2. **起算日**：プロトコル定義との整合（特にRFSは試験ごとに変わる）
3. **解析対象集団の操作的定義**：FAS/PPS/SAF が `saihi.csv` のどの列に対応するか、PN導入例・移植例等のサブグループはどのSDTMドメインのどの値で識別されるか
4. **時間軸の起算日**：First CMR等で「3 mos」「consolidation-1」等の混在があれば絶対日数に統一
5. **集計時点**：「PN導入時」「移植後30日」等の操作的定義
6. **観察期間**：「投与終了より28日」等の起点を明示
7. **目次の章番号整合**：本文と目次の番号ズレ
8. **タイポ・誤記**：英文（Survival、abnormalities、Mucositis等）、和文（許容用範囲→許容範囲等）

### 7.3 修正案の出し方

「修正前/修正後」形式で、SDTM変数とaCRFフォームを必ず参照する。

例：
```
### #N PN導入後AEの集計対象（5.4.11）

修正前: 「PN導入（変更）時の最悪Gradeを集計したい」（期間未定義）

修正後:
PN導入後の有害事象は以下の2ソースで集計：
① 維持療法中: FA.FASPID='ae12', FATESTCD='GRADE'（aCRF: 維持療法:ポナチニブ有害事象報告）
② 地固め療法中: EC.ECSPID='tki_change1' のDSSTDTC以降のFA.FASPID IN ('ae3'-'ae10')
```

**ポイント**：実装プログラマが1対1で対応できる SDTM変数 + 値 を書く。「最悪Grade」「治療開始」等の曖昧表現は必ず操作的定義に置き換える。

### 7.4 出力フォーマット

`TMF/spec/sap_review_vX.Y.md` に以下の構成で保管：

```
# SAP レビュー結果
## 重大な指摘事項（修正必須）
  ### #1 〜 #N（修正前/修正後/理由）
## タイポ・誤記の修正一覧（表）
## 構造上の改善提案（任意）
## データ格納構造（参考表）
## 確定事項（ユーザー確認済み）
## 参照資料
```

---

## 8. aCRF と SDTM のマッピング確認（PhALL219 で確立）

### 8.1 aCRF CSV の取り込み

aCRF一覧は通常 `フォーム名,URL` のCSVで提供される。これを `TMF/aCRF/{試験ID}-acrf.csv` に置く。

```csv
"症例登録票","https://acrf.s3.ap-northeast-1.amazonaws.com/{trial}/registration.html"
"寛解導入療法:有害事象報告","https://.../ae1.html"
...
```

### 8.2 SPID/VISITNUM ベースの対応表作成

aCRFフォームと SDTM ドメインのマッピングを早期に作成する。これにより「このCRFの値はSDTMのどこにあるか」が即解決できる。

例（PhALL219）：

| aCRFフォーム | URL末尾 | SDTM | 識別子 |
|---|---|---|---|
| 寛解導入療法:有害事象報告 | ae1.html | FA | FASPID='ae1', FACAT='PRE-SPECIFIED AE' |
| 維持療法:ダサチニブ有害事象報告 | ae11.html | FA | FASPID='ae11' |
| 維持療法:ポナチニブ有害事象報告 | ae12.html | FA | FASPID='ae12' |
| 重篤な有害事象報告書 | sae_report.html | AE | AESER='Y', AESPID='sae_report{n}-{letter}' |
| 試験治療終了(中止・完了)報告 | discon.html | DS | EPOCH='TREATMENT', DSSPID='discon' |
| 最終転帰(観察終了)報告 | withdrawal.html | DS | EPOCH='FOLLOW-UP', DSSPID='withdrawal' |
| 寛解導入療法:効果判定 | evaluation1.html | RS | VISITNUM=310 |
| 強化地固め療法:効果判定 | evaluation2.html | RS | VISITNUM=410 |
| 血液学的再発報告 | relapse.html | CE | CETERM='Hematologic Relapse' |
| TKI変更報告 | tki_change.html | DS / EC | DSSPID='tki_change1' / ECSPID='tki_change1' |

### 8.3 マッピング作成手順

1. aCRF CSV を読み、各フォームのURLからフォーム種別を特定
2. SDTM サンプル（`input/rawdata/*.csv`）の SPID/CAT/VISITNUM 値を `Get-Unique` で抽出
3. 対応表を `TMF/spec/efficacy_mapping_vX.Y.md` または `aCRF_SDTM_mapping_vX.Y.md` に保管
4. EFS/CHR/CMR/AE等の解析項目ごとに、参照すべき aCRF→SDTM 経路を明記

**早期にマッピングする利点**：
- SAPレビューで「このSPIDは何？」を即答できる
- CSVtoSASDS実装時にWHERE句が即書ける
- 未取得・未マッピングの項目（例：FA@ECG異常 → adeg）が事前に特定できる

---

## 9. ADaM + Wide-format master 並存設計（PhALL219 で確立）

### 9.1 役割分担

過去のGML219では Wide-format master のみで集計駆動した。PhALL219 では **CDISC ADaM 群を最終出力として残し、Wide-format master と並存させる**。

| データセット種別 | 形式 | 主な用途 |
|---|---|---|
| **ADaM 群**（縦持ち） | CDISC準拠（PARAMCD駆動） | TTE/AE層別解析、Define-XML作成、規制対応 |
| **Wide-format master**（1行/被験者） | 集計駆動用 | SAPベースライン表、コース別投与表、最悪Grade表、サブグループ集計 |

### 9.2 推奨ADaM群

| データセット | キー | PARAMCD例 | 主な参照先（SAP節） |
|---|---|---|---|
| `adsl` | USUBJID | – | フローチャート、ベースライン |
| `adae` | USUBJID, AESEQ | – | AE集計、SAE |
| `adcm` | USUBJID, CMSEQ | – | 併用薬・補助療法 |
| `adec` | USUBJID, PARAMCD | COURSEDOSE, DOSEINT, TKICHANGE | コース別投与 |
| `adeg` | USUBJID, EGSEQ | – | （該当があれば）ECG異常 |
| `adlb` | USUBJID, LBSEQ, PARAMCD | HEMARECV, BCRABL | 経時推移、recovery |
| `admh` | USUBJID, MHSEQ | – | 既往・合併症 |
| `adrs` | USUBJID, PARAMCD, AVISIT | HEMARESP, MOLRESP | CHR/CMR割合 |
| `adtte` | USUBJID, PARAMCD | EFS, OS, RFS | KM法 |
| `advs` | USUBJID, VSSEQ, PARAMCD | HEIGHT, WEIGHT, BSA, PS | ベースライン |

### 9.3 整合性QC

ADaM と Wide-master を両立させる場合、両者の整合をQCする：

- `adsl.fasfl` と `master.fasfl` が完全一致
- `adtte['EFS'].AVAL` と `master.efs_d` が完全一致
- `adae` の最悪Grade集計と `master.ae_*_max` が一致

不整合が出た場合は **ADaM側を正**とし、Wide-master を再計算する（CDISC準拠を優先）。

### 9.4 ADaM作成のタイミング

CSVtoSASDSの§19（最終出力）で、中間データセット `_resp` `_ae_long` `_cm` `_lb` 等から ADaM群を組み立てる。Wide-master は ADaM群を merge して作る。

```
中間DS → ADaM群（保存）→ Wide-master（保存）
```

---

## 10. 検算用予測ファイルでのQC（PhALL219 で確立）

### 10.1 仕様書段階での全例予測

EFS等の主要エンドポイントは、データ固定前に**全例の予測値を仕様書として作成する**。

- ファイル: `TMF/spec/efs_subject_check_v0.X.csv`
- 内容: USUBJID × `nr_dt / rel_dt / dth_dt / event_dt / event_typ / efs_dt / efs_d / efs_fl`
- 90例（PhALL219）の場合、エッジケースを含めて全例を手計算で埋める

### 10.2 エッジケースの明示

予測ファイルには**特殊ケース**をコメント列で明示する：

| Subject | 状況 | 期待値 |
|---|---|---|
| PhALL219-0006 | NR=REL同日 | event_dt=2020-05-25, event_typ=NR |
| PhALL219-0029 | NON-PR→DS中止 | event_dt=2021-06-10, event_typ=NR |
| PhALL219-0049 | LFSのみで CR未達 | 打ち切り |
| PhALL219-0062/0063 | 310 CHR + 410 LFS | CHR達成扱い |
| PhALL219-0046/0068 | RS なし + PROTOCOL DEVIATION | FAS除外候補 |

### 10.3 CSVtoSASDS実装後のQC手順

1. CSVtoSASDS実装 → `adtte` 出力
2. `adtte` を CSVエクスポートし、予測ファイルと merge
3. 全レコードで予測値=実装値を確認
4. 不一致があればロジックを修正、または予測ファイルを修正（プロトコル解釈の見直し含む）

このサイクルにより、データ固定前の段階でロジックの妥当性が確認できる。

---

## 11. AE と SAE の格納分離（PhALL219 で確認）

### 11.1 ドメイン別の収集設計

血液腫瘍系試験では、有害事象の収集が**事前規定AE（pre-specified AE）と重篤AE（SAE）で別ドメインに分離される**ケースが多い。

| データ種別 | SDTM格納先 | 識別子 | 内容 |
|---|---|---|---|
| **事前規定AEのGrade**（治療相別） | **FA**.csv | FATESTCD='GRADE', FACAT='PRE-SPECIFIED AE', FASPID='ae{N}' | aCRFで定義されたAE項目の最悪Grade |
| **SAE（重篤な有害事象）** | **AE**.csv | AESER='Y', AESPID='sae_report{n}-{letter}' | 個別のSAE報告 |
| **その他のFA変数** | **FA**.csv | FATESTCD='DURATION', 'OCCUR' 等 | 骨髄抑制期間、生着、GVHD等 |

### 11.2 集計時の使い分け

- **治療相別AE頻度表**（5.4.7.1〜5.4.7.5 等）: **FAドメイン**（FATESTCD='GRADE'）から
- **SAE一覧・頻度**（5.4.8 等）: **AEドメイン**（AESER='Y'）から
- **ドメイン混同に注意**：「AE.csv」を全AE と思ってクエリすると、PhALL219の場合 SAE のみしか取れない

### 11.3 実装パターン

```sas
/* 治療相別 最悪Grade */
proc sql;
  create table ae_grade as
  select usubjid, faspid as phase, faobj as ae_term,
         max(input(faorres, 8.)) as max_grade
  from rawdata.fa
  where fatestcd='GRADE' and facat='PRE-SPECIFIED AE'
  group by usubjid, faspid, faobj;
quit;

/* SAE 一覧 */
proc sql;
  create table sae_list as
  select usubjid, aespid, aedecod, aetoxgr, aestdtc
  from rawdata.ae
  where aeser='Y';
quit;
```

**最初に確認すべきこと**：`AE.csv` の `AESER` 値分布。全件 `Y` ならその試験は SAE のみ AE に格納している。
