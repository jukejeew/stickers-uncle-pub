# 🌟 stickers-uncle-pub

หน้าเว็บ **Portfolio + โปรโมท LINE Stickers** (Hugo หน้าเดียว) โฮสต์ด้วย **GitHub Pages**  
เก็บเฉพาะไฟล์เผยแพร่: รูป/ปก/เมตาดาตา/เทมเพลตเว็บ

[![Deploy](https://github.com/jukejeew/stickers-uncle-pub/actions/workflows/build.yml/badge.svg)](https://github.com/jukejeew/stickers-uncle-pub/actions/workflows/build.yml)  
**Live:** ดูลิงก์ล่าสุดในหน้า Actions (Summary) หรือ Environments หลัง deploy สำเร็จ

---

## โครงสร้างโปรเจกต์ (คร่าว ๆ)

```
site/                               — โฟลเดอร์รากของ Hugo site
├─ content/_index.md                — เนื้อหาหน้าแรก
├─ data/stickers/<set-id>.yml       — เมตาดาตาอ่านง่าย
├─ layouts/_default/baseof.html     — โครง HTML หลัก
├─ layouts/index.html               — หน้าแรก (เรนเดอร์การ์ดสติ๊กเกอร์)
├─ static/assets/stickers/<set-id>/ — ไฟล์รูปจริง .png สำหรับโชว์
└─ static/assets/css/main.css       — สไตล์หน้าเว็บ
.github/workflows/build.yml         — Build & Deploy ด้วย GitHub Actions
```

> 💡 **สำคัญ:** รูปทั้งหมดอยู่ใต้ `site/static/...`  
> หน้าเว็บจะ **สแกนไฟล์ `.png` ทั้งโฟลเดอร์** ตามพาธใน YAML และ **ไม่นับ `cover.png`** ในรายการ

---

## วิธีเพิ่มชุดใหม่ (ฉบับย่อ)

1. วางรูปทั้งหมดไว้ที่ `site/static/assets/stickers/<set-id>/`
2. สร้างเมตาดาตา `site/data/stickers/<set-id>.yml`
3. Commit/Push → ระบบ build & deploy อัตโนมัติ ✨

> ต้องการรายละเอียดเชิงลึก (สคีมา, เคล็ดลับ, ท่อส่งจากต้นน้ำ)? ดู **MAINTAINERS.md**

---

## License & Credits

- สงวนลิขสิทธิ์ไฟล์ภาพทั้งหมด © ผู้สร้างสรรค์  
- ส่วนโค้ด (เทมเพลต/CSS/workflow) เปิดให้ใช้งานภายในโปรเจกต์นี้
