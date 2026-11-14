(() => {
  "use strict";
  const STYLE_ID = "chat-custom-background";
  const HIDDEN = "data-chat-custom-hidden";
  let selectors = [], hints = [], queued = false;

  function applyBackground(s = {}) {
    let style = document.getElementById(STYLE_ID);
    if (!style) {
      style = document.createElement("style");
      style.id = STYLE_ID;
      (document.head || document.documentElement).appendChild(style);
    }
    const opacity = Math.max(0, Math.min(1, Number(s.opacity ?? 1)));
    const fit = ["cover", "contain", "auto"].includes(s.fit) ? s.fit : "cover";
    const pos = ["center", "top", "bottom", "left", "right"].includes(s.position) ? s.position : "center";
    const color = s.mode === "color" ? (s.color || "#171923") : "#171923";
    const image = s.mode === "image" && s.image ? 'url("' + String(s.image).replace(/["\\\n\r]/g, "") + '")' : "none";
    style.textContent = "html,body{background:transparent!important}body{position:relative}body::before{content:\"\";position:fixed;inset:0;z-index:-1;pointer-events:none;background-color:" + color + ";background-image:" + image + ";background-repeat:no-repeat;background-size:" + fit + ";background-position:" + pos + ";opacity:" + opacity + "}";
  }

  function hide(el) {
    if (!(el instanceof HTMLElement) || el.hasAttribute(HIDDEN)) return;
    el.setAttribute(HIDDEN, el.style.display || "");
    el.style.setProperty("display", "none", "important");
  }
  function scan(root = document) {
    selectors.forEach(selector => {
      try {
        if (root.matches && root.matches(selector)) hide(root);
        if (root.querySelectorAll) root.querySelectorAll(selector).forEach(hide);
      } catch (e) { console.warn("[Chat Custom] Invalid selector:", selector, e); }
    });
    if (hints.length && root.querySelectorAll) {
      root.querySelectorAll("aside,[role=complementary],[aria-label],[title]").forEach(el => {
        const txt = (el.innerText || "").trim().toLowerCase();
        const label = ((el.getAttribute("aria-label") || "") + " " + (el.title || "")).toLowerCase();
        if (txt.length < 180 && hints.some(h => label.includes(h) || txt === h)) hide(el);
      });
    }
  }
  function queueScan() {
    if (queued) return;
    queued = true;
    requestAnimationFrame(() => { queued = false; scan(); });
  }
  async function loadRules() {
    try {
      const response = await fetch(chrome.runtime.getURL("rules.json"));
      if (!response.ok) throw new Error("Could not load rules.json");
      const rules = await response.json();
      selectors = Array.isArray(rules.selectors) ? rules.selectors : [];
      hints = Array.isArray(rules.textHints) ? rules.textHints : [];
    } catch (e) { console.warn("[Chat Custom]", e); }
    scan();
    new MutationObserver(queueScan).observe(document.documentElement, {childList:true,subtree:true});
  }
  chrome.storage.local.get(["backgroundSettings"], r => applyBackground(r.backgroundSettings || {mode:"default"}));
  chrome.storage.onChanged.addListener((changes, area) => {
    if (area === "local" && changes.backgroundSettings) applyBackground(changes.backgroundSettings.newValue || {mode:"default"});
  });
  loadRules();
})();