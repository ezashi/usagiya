console.log('trix_customization.js loaded');

// Trixが読み込まれる前に設定を行う
document.addEventListener('trix-before-initialize', function() {
  console.log('trix-before-initialize event fired');

  if (typeof Trix === 'undefined') {
    console.error('Trix is not defined');
    return;
  }

  // 画像添付を完全に無効化
  Trix.config.attachments.preview.caption = false;

  // カスタムツールバー（太字、斜体、下線、見出し、文字揃えのみ）
  Trix.config.toolbar.getDefaultHTML = function() {
    return `
      <div class="trix-button-row">
        <span class="trix-button-group trix-button-group--text-tools">
          <button type="button" class="trix-button trix-button--icon trix-button--icon-bold" data-trix-attribute="bold" data-trix-key="b" title="太字" tabindex="-1">太字</button>
          <button type="button" class="trix-button trix-button--icon trix-button--icon-italic" data-trix-attribute="italic" data-trix-key="i" title="斜体" tabindex="-1">斜体</button>
          <button type="button" class="trix-button trix-button--icon trix-button--icon-strike" data-trix-attribute="strike" title="下線" tabindex="-1">下線</button>
        </span>
        <span class="trix-button-group trix-button-group--block-tools">
          <button type="button" class="trix-button trix-button--icon trix-button--icon-heading-1" data-trix-attribute="heading1" title="見出し（大）" tabindex="-1">大</button>
          <button type="button" class="trix-button" data-trix-attribute="heading2" title="見出し（中）" tabindex="-1">中</button>
          <button type="button" class="trix-button" data-trix-attribute="heading3" title="見出し（小）" tabindex="-1">小</button>
        </span>
        <span class="trix-button-group trix-button-group--block-tools">
          <button type="button" class="trix-button" data-trix-attribute="alignLeft" title="左揃え" tabindex="-1">← 左</button>
          <button type="button" class="trix-button" data-trix-attribute="alignCenter" title="中央揃え" tabindex="-1">↔ 中央</button>
          <button type="button" class="trix-button" data-trix-attribute="alignRight" title="右揃え" tabindex="-1">右 →</button>
        </span>
        <span class="trix-button-group-spacer"></span>
        <span class="trix-button-group trix-button-group--history-tools">
          <button type="button" class="trix-button trix-button--icon trix-button--icon-undo" data-trix-action="undo" data-trix-key="z" title="元に戻す" tabindex="-1">戻す</button>
          <button type="button" class="trix-button trix-button--icon trix-button--icon-redo" data-trix-action="redo" data-trix-key="shift+z" title="やり直し" tabindex="-1">進む</button>
        </span>
      </div>
    `;
  };

  // 見出しサイズの定義
  Trix.config.blockAttributes.heading2 = {
    tagName: "h2",
    terminal: true,
    breakOnReturn: true,
    group: false
  };

  Trix.config.blockAttributes.heading3 = {
    tagName: "h3",
    terminal: true,
    breakOnReturn: true,
    group: false
  };

  // 文字揃えの定義
  Trix.config.blockAttributes.alignLeft = {
    tagName: "div",
    parse: false,
    nestable: false,
    terminal: false,
    breakOnReturn: false,
    group: false,
    style: { textAlign: "left" }
  };

  Trix.config.blockAttributes.alignCenter = {
    tagName: "div",
    parse: false,
    nestable: false,
    terminal: false,
    breakOnReturn: false,
    group: false,
    style: { textAlign: "center" }
  };

  Trix.config.blockAttributes.alignRight = {
    tagName: "div",
    parse: false,
    nestable: false,
    terminal: false,
    breakOnReturn: false,
    group: false,
    style: { textAlign: "right" }
  };

  console.log('Trix toolbar customized successfully');
});

// DOMContentLoadedイベント
document.addEventListener('DOMContentLoaded', disableImageAttachment);

// Turbo Driveによるページ遷移時
document.addEventListener('turbo:load', disableImageAttachment);

// 画像添付機能を無効化
function disableImageAttachment() {
  console.log('Disabling image attachment');

  // Trixエディタのファイル添付ボタンを非表示にする
  document.querySelectorAll('trix-toolbar').forEach(toolbar => {
    const attachButton = toolbar.querySelector('[data-trix-action="attachFiles"]');
    if (attachButton) {
      attachButton.style.display = 'none';
    }
  });

  // ファイル添付イベントをキャンセル
  document.addEventListener('trix-file-accept', function(event) {
    event.preventDefault();
    alert('画像の添付は無効化されています。');
  });

  // 既存の画像添付ボタンを削除
  setTimeout(() => {
    document.querySelectorAll('[data-trix-action="attachFiles"]').forEach(btn => {
      btn.remove();
    });
  }, 100);
}

// カスタムスタイルを追加
const style = document.createElement('style');
style.textContent = `
  /* ツールバーのボタンスタイル */
  trix-toolbar .trix-button-group {
    margin-right: 8px;
  }

  trix-toolbar .trix-button {
    font-size: 0.85rem !important;
    padding: 0.4rem 0.6rem !important;
    font-weight: 500 !important;
    white-space: nowrap !important;
  }

  trix-toolbar .trix-button:hover {
    background-color: rgba(59, 130, 246, 0.1) !important;
  }

  trix-toolbar .trix-button.trix-active {
    background-color: rgba(59, 130, 246, 0.2) !important;
    color: #3b82f6 !important;
  }

  /* エディタのスタイル */
  trix-editor {
    word-wrap: break-word !important;
    overflow-wrap: break-word !important;
    white-space: pre-wrap !important;
    overflow-x: hidden !important;
  }

  trix-editor * {
    max-width: 100%;
  }

  /* 見出しのスタイル */
  trix-editor h1 {
    font-size: 2em;
    font-weight: bold;
    margin: 0.5em 0;
  }

  trix-editor h2 {
    font-size: 1.5em;
    font-weight: bold;
    margin: 0.5em 0;
  }

  trix-editor h3 {
    font-size: 1.17em;
    font-weight: bold;
    margin: 0.5em 0;
  }

  /* 文字揃えのスタイル */
  trix-editor [style*="text-align: left"] {
    text-align: left !important;
  }

  trix-editor [style*="text-align: center"] {
    text-align: center !important;
  }

  trix-editor [style*="text-align: right"] {
    text-align: right !important;
  }

  /* 画像添付ボタンを非表示 */
  [data-trix-action="attachFiles"] {
    display: none !important;
  }

  /* 上下の余白を削除 */
  trix-editor > div:first-child,
  trix-editor > h1:first-child,
  trix-editor > h2:first-child,
  trix-editor > h3:first-child,
  trix-editor > p:first-child {
    margin-top: 0 !important;
    padding-top: 0 !important;
  }

  trix-editor > div:last-child,
  trix-editor > h1:last-child,
  trix-editor > h2:last-child,
  trix-editor > h3:last-child,
  trix-editor > p:last-child {
    margin-bottom: 0 !important;
    padding-bottom: 0 !important;
  }
`;
document.head.appendChild(style);

console.log('Trix customization completed');