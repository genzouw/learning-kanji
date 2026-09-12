# learning-kanji

[kanji.genzouw.com](https://kanji.genzouw.com/) のコンテンツと配信設定。

もとはさくらの VPS 上の WordPress で配信していたが、VPS 停止にともない
静的サイト化して S3 + CloudFront へ移した。

## 構成

| パス | 内容 |
| --- | --- |
| `public/` | 配信する静的ファイル。**これが本番の実体** |
| `tools/build-static.sh` | WordPress から静的サイトを生成するスクリプト |
| `html/` | 移行前の WordPress 本体（参照用） |
| `docker-compose.yml` | 移行前の DB コンテナ定義（参照用） |
| `*.dump.gz` | 移行前の DB ダンプ（参照用） |

## デプロイ

`main` への push で `public/` が S3 へ同期され、CloudFront のキャッシュが消える。
AWS 認証は OIDC で、長期のアクセスキーは置いていない。

デプロイは GitHub Environment `production` 経由に限定しており、main 以外の
ブランチからはデプロイできない。

## public/ の再生成について

**さくらの VPS を停止した後は `tools/build-static.sh` を再実行できない。**
生成元の WordPress が無くなるため。`public/` はリポジトリで管理する資産として扱い、
内容を変えたい場合は直接編集する。

VPS が生きている間に再生成する場合:

```bash
./tools/build-static.sh
```

## URL について

WordPress 時代の permalink は `/archives/<post_id>` で、これを維持している。

| URL | 内容 |
| --- | --- |
| `/` | ようこそ！（固定ページ） |
| `/archives/90` | 公式ページを公開しました。 |
| `/archives/106` | 小学校1年生の問題を追加しました！ |
| `/archives/123` | ボタンが見切れる場合があるため修正しました。 |

配信側では CloudFront Function が `/archives/90` を `/kanji/archives/90/index.html`
へ解決している（`genzouw.com` リポジトリの `cloudfront-spa` モジュール、`mode = "static"`）。

なおゲーム本体は別サイトの [play-kanji.genzouw.com](https://play-kanji.genzouw.com) にある。
