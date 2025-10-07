# 🌟 stickers-uncle-pub

หน้าเว็บ **Portfolio + โปรโมท LINE Stickers** (Hugo หน้าเดียว) โฮสต์ด้วย **GitHub Pages**  
โฟลเดอร์นี้เก็บเฉพาะไฟล์เผยแพร่: รูปย่อ/ปก/เมตาดาตา/เทมเพลตเว็บ

[![Deploy](https://github.com/jukejeew/stickers-uncle-pub/actions/workflows/build.yml/badge.svg)](https://github.com/jukejeew/stickers-uncle-pub/actions/workflows/build.yml)  
**Live:** ลิงก์จะแสดงในหน้า Actions (Summary) และ Environments หลัง deploy สำเร็จ

---

## โครงสร้างโปรเจกต์

```
site/
  content/_index.md
  data/stickers/<set-id>.yml            # เมตาดาตา (อ่านได้ด้วยตาเปล่า)
  layouts/_default/baseof.html
  layouts/index.html                     # เทมเพลตหลัก (สแกนโฟลเดอร์รูปอัตโนมัติ)
  static/assets/stickers/<set-id>/       # รูปพร้อมโชว์ (.png)
  static/assets/css/main.css
.github/workflows/build.yml              # Build & Deploy Pages (Actions)
```

> **สำคัญ:** รูปทั้งหมดต้องอยู่ใต้ `site/static/...`  
> เทมเพลตจะ **สแกนไฟล์ `.png` ทั้งโฟลเดอร์** ตาม `images.base_dir` และ **ตัด `cover.png` ออก**

---

## ตั้งค่าครั้งแรก

1. แก้ `site/config.toml`
   ```toml
   baseURL = "https://jukejeew.github.io/stickers-uncle-pub/"
   ```
2. เปิด GitHub Pages: **Settings → Pages → Source = GitHub Actions**
3. Commit/Push → รอ workflow `Build & Deploy` เสร็จ  
   - ลิงก์หน้าเว็บจะแสดงใน **Actions Summary** และ **Environments: github-pages**

---

## เพิ่มชุดใหม่ (ทุกครั้งทำเหมือนกัน)

1. คัดลอกจาก `stickers-uncle-masters/publish/<set-id>/`
2. วางรูปทั้งหมดที่  
   `site/static/assets/stickers/<set-id>/`
3. วางเมตาดาตาที่  
   `site/data/stickers/<set-id>.yml`
4. Commit/Push → หน้าเว็บอัปเดตอัตโนมัติ

---

## สคีมาเมตาดาตา (สั้น ๆ พอใช้งาน)

```yaml
id: "<set-id>"
title_th: "ชื่อไทย"
title_en: "English (ถ้ามี)"
author: "JukeJeew Studio"
tags: ["tag1","tag2"]

status: "Pending"                 # Draft | Pending | Published | Hidden
line_store_url: ""                # ใส่หลัง LINE อนุมัติ

images:
  base_dir: "assets/stickers/<set-id>"   # โฟลเดอร์รูป
# ไม่มี files: หน้าเว็บจะสแกน .png ทั้งโฟลเดอร์ให้อัตโนมัติ

cover: "assets/stickers/<set-id>/cover.png"

description_th: "คำอธิบายสั้น ๆ"
```

**พฤติกรรมบนหน้าเว็บ**
- ถ้า `line_store_url` ว่าง → ปุ่มจะแสดงเป็น **“รออนุมัติ”**
- ถ้ามีลิงก์ → แสดงปุ่ม **“เปิดใน LINE Store”** กดได้ทันที
- `status: Hidden` → ไม่แสดงการ์ด

---

## เคล็ดลับการจัดไฟล์รูป
- ตั้งชื่อมีเลขนำหน้า เช่น `01_hello.png`, `02_thanks.png`, … เพื่อให้เรียงสวย
- ใส่ `cover.png` ในโฟลเดอร์เดียวกัน (เทมเพลตจะไม่นับรวมเป็นสติ๊กเกอร์)
- ถ้าจะทำลายน้ำ: ทำในเครื่อง (เช่น ImageMagick/Photoshop) แล้วค่อยวางไฟล์ที่ static

---

## แก้ปัญหายอดฮิต

- **Build ผ่าน แต่หน้าไม่ขึ้น** → เช็กว่ารูปอยู่ `site/static/...` ไม่ใช่ `site/assets/...`
- **ธีมไม่เจอ / module not found** → `baseof.html` ไม่ต้อง `define "base"`; ใช้บล็อก `{{ block "main" . }}{{ end }}`
- **รูป/ปกไม่ขึ้น** → เช็ก path ใน YAML ให้ตรงกับโฟลเดอร์จริง
- **ปุ่มไม่ขึ้น** → เติม `line_store_url:` และตั้ง `status: "Published"`

---

## คุณภาพโค้ด (ออปชันแต่อยากให้มี)
- ใช้ **VS Code** + extensions: YAML (Red Hat), EditorConfig, Prettier, GitHub Actions
- เปิด `format on save`, `render whitespace: all`, ปิด `detect indentation`
- เพิ่มไฟล์ `.editorconfig` ที่รากรีโป:
  ```ini
  root = true
  [*]
  end_of_line = lf
  insert_final_newline = true
  trim_trailing_whitespace = true
  indent_style = space
  indent_size = 2
  ```

---

## License & Credits
- สงวนลิขสิทธิ์ไฟล์ภาพทั้งหมด © ผู้สร้างสรรค์  
- โค้ดหน้าเว็บ (เทมเพลต/CSS/workflow) อนุญาตให้ปรับใช้ภายในโปรเจกต์นี้
