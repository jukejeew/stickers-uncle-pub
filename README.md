# Public Stickers Site — How to Publish

## โครงสร้าง (GitHub Pages แบบ docs/)
```
docs/
  stickers/
    <set-id>/
      index.html
      01.png..NN.png
      (main.png / tab.png ถ้าต้องการแสดง)
```

## ขั้นตอนเพิ่มชุดใหม่
1) จาก repo masters: รัน `.\scripts\Run-All.bat "<set-id>"`  
   จะได้ `publish\<set-id>\` ใน masters
2) ใน public repo: คัดลอกทั้งหมดจาก `masters/publish/<set-id>/` ไปไว้ที่ `docs/stickers/<set-id>/`
3) Commit + Push — GitHub Pages deploy อัตโนมัติ
4) URL: `https://<user>.github.io/<repo>/stickers/<set-id>/`

_Last updated: 2025-10-08 13:07:08_
