#!/usr/bin/env bash
# =============================================================================
# kanji.genzouw.com を静的サイトとして取り込む
# =============================================================================
# WordPress (さくらの VPS 上) を wget でミラーし、S3 + CloudFront で配信できる
# 形に整える。VPS 停止後はこのスクリプトを再実行できないため、生成物
# (public/) をリポジトリで管理する。
#
# 使い方: ./tools/build-static.sh [出力先]
# =============================================================================
set -euo pipefail

SRC_HOST="kanji.genzouw.com"
DEST="${1:-$(cd "$(dirname "$0")/.." && pwd)/public}"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

echo "==> ミラー取得"
cd "$WORK"
# -E は text/html に .html を付ける。S3 で Content-Type を正しく返すために必要。
# -k (リンクの相対化) は使わない。canonical を "../index.html%3Fp=90.html" のような
# 壊れた相対パスに書き換えてしまうため。配信ドメインは kanji.genzouw.com のまま
# 変わらないので、絶対 URL のままで問題なく動く。
# wp-admin などの管理系と、静的化しても意味のない動的エンドポイントは除外する。
wget --mirror -p -E -np --no-verbose \
  --reject-regex '(wp-admin|wp-login|xmlrpc|/feed|\?replytocom|wp-json|\?p=|\?page_id=)' \
  --domains "$SRC_HOST" \
  --wait=0.3 --random-wait \
  "https://${SRC_HOST}/" 2>&1 | tail -3

echo "==> S3 向けに整形"
python3 - "$WORK/$SRC_HOST" "$DEST" <<'PYEOF'
import re
import shutil
import sys
from pathlib import Path
from urllib.parse import unquote

src, dest = Path(sys.argv[1]), Path(sys.argv[2])
if dest.exists():
    shutil.rmtree(dest)
dest.mkdir(parents=True)

# 1) クエリ文字列付きのファイル名を正規化する。
#    wget は "luxech.js?v=123" のような名前で保存するが、S3 のキーに ? は使えない。
#    同じ実体が版だけ違って複数あるので、クエリを落とした 1 つに寄せる。
#    対象は css/js の版違いだけに限る。"index.html?p=90" のように中身が別物の
#    ファイルまで名前を潰すと、トップページを記事の内容で上書きしてしまう。
renames = {}
skip = []
for f in sorted(src.rglob("*")):
    if not f.is_file():
        continue
    name = f.name
    if "?" not in name:
        continue
    base = name.split("?", 1)[0]
    # 拡張子はクエリを外してから見る。"luxech.js?v=123" を name 側で判定すると
    # 拡張子が "js?v=123" になり css/js と認識できない。
    tail = base.rsplit(".", 1)[-1] if "." in base else ""
    if tail not in ("css", "js"):
        # 版違いではなく別コンテンツ。静的サイトには不要なので取り込まない。
        skip.append(str(f.relative_to(src)))
        continue
    # wget が付けた拡張子 (style.css?v=1.css) を引き継ぐ
    if not base.endswith("." + tail):
        base = base + "." + tail
    renames[str(f.relative_to(src))] = str((f.parent / base).relative_to(src))

if skip:
    print("  取り込まない (クエリ付きの重複 URL): {} 件".format(len(skip)))
    for x in skip[:5]:
        print("    " + x)

# 2) ファイルを配置する。/archives/90.html は /archives/90/index.html へ移す。
#    現行 URL が /archives/90 (拡張子なし) のため、そのパスで配信できる形にする。
url_moves = {}
for f in sorted(src.rglob("*")):
    if not f.is_file():
        continue
    rel = str(f.relative_to(src))
    if rel in skip:
        continue
    rel = renames.get(rel, rel)

    if rel.endswith(".html") and rel != "index.html":
        stem = rel[: -len(".html")]
        if not stem.endswith("/index"):
            new_rel = stem + "/index.html"
            url_moves["/" + rel] = "/" + stem
            rel = new_rel

    out = dest / rel
    out.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(f, out)

# 3) HTML 内の参照を書き換える。
#    - 絶対 URL をルート相対にする (配信ドメインが変わっても壊れないように)
#    - wget が付けた .html を外し、現行と同じ拡張子なし URL に戻す
#    - クエリ付きのファイル名参照を正規化後の名前に合わせる
for html in dest.rglob("*.html"):
    t = html.read_text(encoding="utf-8", errors="replace")

    # 絶対 URL はそのまま残す。配信ドメインは kanji.genzouw.com のまま変わらず、
    # 置換すると canonical / og:url / SNS シェアの url パラメータまで
    # ルート相対になって壊れるため。

    for old, new in renames.items():
        t = t.replace(unquote(old), unquote(new)).replace(old, new)
        t = t.replace("/" + old, "/" + new)

    # 残ったクエリ付き参照を落とす
    t = re.sub(r'(\.(?:css|js))\?v=\d+', r'\1', t)

    html.write_text(t, encoding="utf-8")

files = [f for f in dest.rglob("*") if f.is_file()]
print("  出力: {} ファイル".format(len(files)))
print("  HTML: {} ファイル".format(len([f for f in files if f.suffix == '.html'])))
PYEOF

echo "==> 完了: $DEST"
