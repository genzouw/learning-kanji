# learning-kanji

[kanji.genzouw.com](https://kanji.genzouw.com/) のコンテンツと配信設定。

もとはさくらの VPS 上の WordPress で配信していたが、VPS 停止にともない
静的サイト化して S3 + CloudFront へ移した。

## 構成

| パス      | 内容                                                                                               |
| --------- | -------------------------------------------------------------------------------------------------- |
| `public/` | 配信する静的ファイル。**これが本番の実体**                                                         |
| `game/`   | ゲーム本体のソース（旧 play-kanji.genzouw.com）。`game/kanji-git.bundle` に元の git 履歴と依存定義 |

## デプロイ

`main` への push で `public/` が S3 へ同期され、CloudFront のキャッシュが消える。
AWS 認証は OIDC で、長期のアクセスキーは置いていない。

デプロイは GitHub Environment `production` 経由に限定しており、main 以外の
ブランチからはデプロイできない。

## コンテンツの管理

WordPress を静的化した生成物 `public/` を資産として直接管理している。
内容を変更したい場合は `public/` 内のファイルを直接編集する。

## URL について

WordPress 時代の permalink は `/archives/<post_id>` で、これを維持している。

| URL             | 内容                                         |
| --------------- | -------------------------------------------- |
| `/`             | ようこそ！（固定ページ）                     |
| `/archives/90`  | 公式ページを公開しました。                   |
| `/archives/106` | 小学校1年生の問題を追加しました！            |
| `/archives/123` | ボタンが見切れる場合があるため修正しました。 |

配信側では CloudFront Function が `/archives/90` を `/kanji/archives/90/index.html`
へ解決している（`genzouw.com` リポジトリの `cloudfront-spa` モジュール、`mode = "static"`）。

## ゲームの統合について

ゲームはもともと `play-kanji.genzouw.com` で配信していたが、2026-09-13 に
`kanji.genzouw.com/play/` へ統合した。旧ドメインは 301 でリダイレクトされる。

ソースは `game/` にある。**GitHub 上の元リポジトリ `genzouw/kanji` は削除済みで、
さくらの VPS 上にしか残っていなかった**ものを取り込んだ。git 履歴は
`game/kanji-git.bundle` に保全してある（`git clone kanji-git.bundle` で復元できる）。

### 依存定義を追跡していない理由

`game/package.json` と `game/yarn.lock` はこのリポジトリでは追跡していない。
webpack 3 / Vue 2 / axios 0.19 / firebase 6 という 2019 年当時の依存ツリーで、
CI でも本番でも一切インストールされないにもかかわらず、Dependabot alerts を
252 件生み続けていたため。両ファイルとも `game/kanji-git.bundle` に保全されており、
ビルドするときだけ取り出す。

`game/kanji-git.bundle` 側の依存定義は取り出した時点のスナップショットであり、
追跡を止めた後にこのリポジトリへ個別適用した脆弱性修正（例:
becf053f7 の brace-expansion 修正）は自動では反映されない。bundle にも同じ修正を
コミットしておかないと、次に取り出したときに同じ脆弱性を踏み直すことになる。

### ゲームのビルド

webpack 3 / Vue 2 の構成で、現行の Node では動かない。依存定義を bundle から
取り出したうえで、Docker で当時相当の Node を使う。

```bash
cd game
git clone ./kanji-git.bundle /tmp/kanji-src
cp /tmp/kanji-src/package.json /tmp/kanji-src/yarn.lock .
docker run --rm -v "$PWD:/app" -w /app node:10-buster sh -c 'yarn install && npm run build'
cp -r dist/* ../public/play/
rm package.json yarn.lock  # 追跡対象に戻さない
```

`/play/` 配下で配信するため、以下を設定済み。**ルート直下に戻す場合は両方を戻すこと。**

- `config/index.js` の `assetsPublicPath: '/play/'`
- `src/router/index.js` の `base: '/play/'`

配信側では CloudFront Function が `/play/` 配下の未知パスを `/play/index.html` に
返す（`genzouw.com` リポジトリの `cloudfront-spa` モジュール、`spa_paths`）。
Vue Router が history mode のため、これが無いとリロードで 404 になる。
