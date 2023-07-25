export default class ClipboardCopyElement extends HTMLElement {
  value: string
}

declare global {
  interface Window {
    ClipboardCopyElement: typeof ClipboardCopyElement
  }
  interface HTMLElementTagNameMap {
    'clipboard-copy': ClipboardCopyElement
  }
}