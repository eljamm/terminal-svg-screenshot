# terminal-svg-screenshot

きれいなSVGスクリーンショットを作成するためのツールです。ターミナルの出力をSVG形式で保存することで、高品質かつ編集可能なスクリーンショットを簡単に作成できます。ドキュメントやブログ記事の作成に最適です。

## 必要なもの

- nix（flakeが使える環境）
- ターミナルアプリ（Ghostty、Hyper推奨）
  - `brew install --cask ghostty`
  - `brew install --cask hyper`

## 使い方

### 1. リポジトリのセットアップ

以下のコマンドでリポジトリをクローンします：

```zsh
git clone https://github.com/suin/terminal-svg-screenshot.git
cd terminal-svg-screenshot
```

### 2. スクリーンショットの作成

2つのターミナルを使用します：

1. モデルターミナル：撮影したいコマンドを実行するターミナル
2. カメラマンターミナル：SVGファイルを出力するターミナル

#### モデルターミナルの準備

1. ターミナルアプリを開きます（iTerm2ではなく、ウインドウサイズが調整できるアプリを使用してください）
2. 以下のコマンドを実行します：
   ```zsh
   nix develop .#start
   ```
3. 撮影したいコマンドを実行します
4. ターミナルウィンドウにちょうど収まるようにウインドウサイズと文字サイズを調整します
5. 画面構成が決まったら、そのままの状態にしておきます

#### スクリーンショットの撮影

カメラマンターミナルで以下の手順を実行します：

1. 新しいターミナルを開き、以下のコマンドを実行します：
   ```zsh
   nix develop
   ```

2. SVGファイルを生成します：
   ```zsh
   tmux capture-pane -pet 0 | freeze -c ./freeze.json -o output.svg
   ```

プロンプト行の調整が必要な場合は、以下のコマンドを使用します：

- 最後の行のプロンプトを除外：
  ```zsh
  tmux capture-pane -pet 0 | head -n -1 | freeze -c ./freeze.json -o output.svg
  ```

- 末尾行数の微調整（出力を確認しながら行数を調整）：
  ```zsh
  tmux capture-pane -pet 0 | head -n -10
  ```

#### SVGの後処理

環境によってフォントの問題が発生することを防ぐため、テキストをアウトライン化することをお勧めします：

```zsh
inkscape --export-text-to-path output.svg -o output-outlined.svg
```

必要に応じて、FigmaやIllustratorで追加の編集を行うことができます。

## カスタマイズ

### テーマの設定

`freeze.json`でターミナルの見た目を設定できます：

- 背景色
- 文字色
- 文字サイズ
- その他の設定

詳細は[freezeのドキュメント](https://github.com/charmbracelet/freeze)を参照してください。
利用可能なテーマは[こちら](https://xyproto.github.io/splash/docs/all.html)で確認できます。

### フォントの変更

デフォルトではJetBrainsMono Nerd Font Monoを使用しています。フォントを変更する場合は：

1. `freeze.json`の`font`設定を変更します
2. `flake.nix`に使用したいフォントを追加します：

```nix
tools = with pkgs; [
  tmux
  charm-freeze
  fish
  inkscape
  fontconfig
  nerd-fonts.jetbrains-mono
  # ここに新しいフォントを追加
];
```

## ギャラリー

以下のスクリーンショットは、このリポジトリのサンプルコマンドを使用して作成されました：

![](gallery/npx-create-next-app.svg)

![](gallery/tree.svg)

![](gallery/nvim.svg)

![](gallery/npm-install.svg)

![](gallery/npm-run-dev.svg)
