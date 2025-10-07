
---

## ✅ README ใหม่ — `stickers-uncle-pub` (Public)

```md
# stickers-uncle-pub

หน้าเว็บพอร์ตโฟลิโอสติ๊กเกอร์ (Hugo หน้าเดียว) สำหรับ GitHub Pages

## โครงสร้างสำคัญ
site/
content/_index.md
data/stickers/uncle-set01.yml # เมตาดาตาชุดตัวอย่าง
layouts/_default/baseof.html
layouts/index.html # มีบล็อกสแกนโฟลเดอร์รูปให้อัตโนมัติ
static/assets/stickers/uncle-set01/ # รูปเผยแพร่ (01.., cover.png)
static/assets/css/main.css
.github/workflows/build.yml # Deploy Pages


## วิธีใช้งานครั้งแรก
1) แก้ `site/config.toml`:

baseURL = "https://jukejeew.github.io/stickers-uncle-pub/

2) เปิด GitHub Pages ที่ **Settings → Pages → Source = GitHub Actions**
3) Commit/Push → รอ workflow `Build & Deploy` เสร็จ → เข้า URL ที่สรุปใน Actions (และใน Environments)

## เพิ่มชุดใหม่
1) คัดลอกจาก `stickers-uncle-masters/publish/<set-id>/`
2) วางรูปที่ `site/static/assets/stickers/<set-id>/`
3) วางเมตาดาตาเป็น `site/data/stickers/<set-id>.yml`
4) commit/push → หน้าเว็บอัปเดตอัตโนมัติ

> หมายเหตุ: ใน `site/layouts/index.html` มีบล็อกให้ “สแกนโฟลเดอร์รูป .png ทั้งโฟลเดอร์” และ **ตัด cover.png ออก** แล้ว จึงไม่ต้องกรอกรายการไฟล์ใน YAML
