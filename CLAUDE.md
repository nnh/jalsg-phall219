# JALSG-PhALL219 — Claude Code 運用ルール

このフォルダは試験JALSG-PhALL219のSASプログラムと、この試験専用の作業記録（overview.md・issues.md・next-action.md）を管理する。

## 厳守事項

生データ・SAS実行ログ・出力ファイルは絶対にgitへコミットしない（.sas7bdat, .sas7bcat, .xpt, .csv, .xlsx, .sav, .dta, .zip等）。Boxに保存する。

## セッション開始時

next-action.md を読んで直近の作業を確認する（フォルダを開くと自動で表示される設定済み）。

## セッション終了時

「セッションを終わります」と言われたら、次を行う。

1. 今回の作業内容に合わせて overview.md・issues.md・next-action.md を更新する。
2. 変更をステージ・コミットし、push する。

## 関連

- 環境橋渡し・全体規約・方法論の正本：akiko-office（akikomsaito/akiko-office、private。旧 saito-la/stat-hub を2026-07-20に統合）
- GitHub/Boxの役割分担：コード・作業記録はGitHub、生データ・実行ログ・出力はBox（`Stat/Trials/` 配下）。詳細は akiko-office のドキュメントを参照。
