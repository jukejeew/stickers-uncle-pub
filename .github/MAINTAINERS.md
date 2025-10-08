# 👩‍🔧 MAINTAINERS — stickers-uncle-pub

เอกสารนี้สำหรับผู้ดูแล: โครงสร้างจริง, เวิร์กโฟลว์, เช็กลิสต์, และคำแนะนำเชิงปฏิบัติ

---

## โครงสร้างจริง (tree + คำอธิบาย)

```
site/                                 — โฟลเดอร์รากของ Hugo site
├─ content
│  └─ _index.md                       — ข้อความหน้าแรก (สั้น กระชับ)
├─ data
│  └─ stickers
│     └─ <set-id>.yml                 — เมตาดาตา (อ่านง่าย, ใช้กำกับการเรนเดอร์)
├─ layouts
│  ├─ _default
│  │  └─ baseof.html                  — โครง HTML หลัก (ใช้ {{ block "main" . }})
│  └─ index.html                      — หน้าแรก (วนอ่าน YAML + สแกนรูปอัตโนมัติ)
├─ static
│  └─ assets
│     ├─ css
│     │  └─ main.css                  — สไตล์หน้าเว็บ/การ์ด
│     └─ stickers
│        └─ <set-id>/                 — รูปโชว์จริง (.png)
│           ├─ 01.png … NN.png        — รายการสติ๊กเกอร์
│           ├─ cover.png              — ภาพปกการ์ด (ไม่นับรวมในรายการ)
│           ├─ main.png               — (ออปชัน)
│           └─ tab.png                — (ออปชัน)
.github
└─ workflows
   └─ build.yml                       — Build & Deploy ไป GitHub Pages
```

> **พาธภาพ:** อ้างจากราก `site/static/` เช่น `assets/stickers/<set-id>/01.png`

---

## เวิร์กโฟลว์จากต้นน้ำ (สรุป)
- ต้นน้ำจะส่งมาที่โครง `publish/<set-id>/site/` (จัดโฟลเดอร์ให้ตรงนี้อยู่แล้ว)
- ฝั่ง public ให้วางตรง ๆ ตาม tree ข้างบน แล้ว commit/push ได้เลย

---

## สคีมา YAML (กระชับแต่ครบใช้)

```yaml
id: "<set-id>"
title_th: "ชื่อไทย"
title_en: "English (ถ้ามี)"
author: "JukeJeew Studio"
tags: ["tag1", "tag2"]

status: "Pending"                   # Draft | Pending | Published | Hidden
line_store_url: ""                  # ใส่หลัง LINE อนุมัติ

images:
  base_dir: "assets/stickers/<set-id>"   # โฟลเดอร์รูป (ใต้ site/static/)
# ไม่มี 'files': เทมเพลตจะสแกน .png ทั้งโฟลเดอร์ให้อัตโนมัติ

cover: "assets/stickers/<set-id>/cover.png"

description_th: "คำอธิบายสั้น ๆ"
```

**พฤติกรรมหน้าเว็บ**
- `line_store_url` ว่าง → ปุ่ม: **“รออนุมัติ”**
- มีลิงก์ → ปุ่ม: **“เปิดใน LINE Store”**
- `status: Hidden` → ซ่อนการ์ด
- พบ `cover.png` → ใช้เป็นภาพปกการ์ด (ไม่รวมในรายการสติ๊กเกอร์)

---

## เคล็ดลับคุณภาพรูป
- ตั้งชื่อมีเลขนำหน้า `01_hello.png`, `02_thanks.png`, … เพื่อให้เรียงสวย
- ทำลายน้ำ/ปรับคมชัดในเครื่อง แล้วค่อยวางที่ `static/`
- ใช้พื้นหลังโปร่งใสเพื่อความคมบนพื้นเข้ม

---

## Troubleshooting (ยอดฮิต)
- **Build ผ่าน แต่หน้าไม่ขึ้น** → รูปต้องอยู่ `site/static/...` (ไม่ใช่ `site/assets/...`)
- **ธีมไม่เจอ / module not found** → `baseof.html` ใช้ `{{ block "main" . }}{{ end }}` ไม่ต้อง `define "base"`
- **รูป/ปกไม่ขึ้น** → ตรวจ path ใน YAML ให้ตรงกับโฟลเดอร์จริง
- **ปุ่มไม่ขึ้น** → เติม `line_store_url` และตั้ง `status: "Published"`

---

## เช็กลิสต์ก่อน commit
- [ ] `site/static/assets/stickers/<set-id>/` มีรูปครบ (และมี `cover.png` ถ้าต้องการ)
- [ ] `site/data/stickers/<set-id>.yml` ครบฟิลด์จำเป็น
- [ ] `baseURL` ใน `site/config.toml` ถูกต้อง
- [ ] ดูผลใน **Actions → Build & Deploy** หลัง push

---

## Dev Experience (แนะนำ)
- ใช้ VS Code + extensions: YAML (Red Hat), EditorConfig, Prettier, GitHub Actions
- เปิด `format on save`, `render whitespace: all`, ปิด `detect indentation`
- `.editorconfig` ที่รากรีโป:

```ini
root = true
[*]
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true
indent_style = space
indent_size = 2
```
