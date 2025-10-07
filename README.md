
# stickers-uncle-pub (ตัวอย่าง)

หน้าเว็บพอร์ตโฟลิโอสติ๊กเกอร์ (Hugo หน้าเดียว) สำหรับ GitHub Pages

## โครงสร้างสำคัญ
```
data/stickers/uncle-v1.yml     # เมตาดาตาชุดตัวอย่าง
assets/stickers/uncle-v1/      # รูปเผยแพร่ (01.., cover.png)
site/                          # Hugo site (หน้าเดียว)
```

## วิธีใช้งานครั้งแรก
1) แก้ `site/config.toml` →
   baseURL = "https://jukejeew.github.io/stickers-uncle-pub/"
2) เปิด GitHub Pages ที่ Settings → Pages → Source = "GitHub Actions"
3) Push → รอ workflow deploy เสร็จ → เข้า URL

## เพิ่มชุดใหม่
1) คัดลอกจาก `stickers-uncle-masters/publish/<set-id>/`
2) รูป → `assets/stickers/<set-id>/`
3) เมตา → `data/stickers/<set-id>.yml`
4) commit/push → หน้าเว็บอัปเดตอัตโนมัติ
