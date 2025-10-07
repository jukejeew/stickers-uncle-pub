param(
  [Parameter(Mandatory = $true)][string]$OldId,
  [Parameter(Mandatory = $true)][string]$NewId,
  [string]$RepoRoot = ".",
  [switch]$NoPrompt
)

function Info($msg){ Write-Host "[i] $msg" -ForegroundColor Cyan }
function Ok($msg){ Write-Host "[ok] $msg" -ForegroundColor Green }
function Warn($msg){ Write-Host "[! ] $msg" -ForegroundColor Yellow }
function Err($msg){ Write-Host "[xx] $msg" -ForegroundColor Red }

# --- Paths ---
$repo = Resolve-Path $RepoRoot
$dataDir   = Join-Path $repo "site\data\stickers"
$staticDir = Join-Path $repo "site\static\assets\stickers"

if (-not (Test-Path $dataDir)) { Err "ไม่พบโฟลเดอร์ $dataDir"; exit 1 }
if (-not (Test-Path $staticDir)) { Err "ไม่พบโฟลเดอร์ $staticDir"; exit 1 }

# --- Preview changes ---
Info "เตรียมแก้จาก `"$OldId`" เป็น `"$NewId`""
$oldYml = Join-Path $dataDir "$OldId.yml"
$newYml = Join-Path $dataDir "$NewId.yml"
$oldDir = Join-Path $staticDir $OldId
$newDir = Join-Path $staticDir $NewId

if (Test-Path $oldYml) { Info "จะเปลี่ยนชื่อไฟล์: $oldYml -> $newYml" }
elseif (Test-Path $newYml) { Info "พบไฟล์ข้อมูลใหม่อยู่แล้ว: $newYml" }
else { Warn "ไม่พบไฟล์ .yml ของ $OldId ใน $dataDir (จะพยายามแก้ในทุกไฟล์ที่มีข้อความตรงกันแทน)" }

if (Test-Path $oldDir) { Info "จะเปลี่ยนชื่อโฟลเดอร์รูป: $oldDir -> $newDir" }
elseif (Test-Path $newDir) { Info "พบโฟลเดอร์รูปใหม่อยู่แล้ว: $newDir" }
else { Warn "ไม่พบโฟลเดอร์รูปของ $OldId ใน $staticDir" }

# ค้นหาข้อความคงค้าง
$hits = Get-ChildItem -Path (Join-Path $repo "site") -Recurse -File -Include *.yml,*.yaml,*.html,*.md,*.toml |
        Select-String -SimpleMatch $OldId
if ($hits) {
  Info "พบบรรทัดที่ยังมีคำว่า `"$OldId`":"
  $hits | ForEach-Object { "  $($_.Path):$($_.LineNumber): $($_.Line.Trim())" } | Select-Object -First 8
  if ($hits.Count -gt 8) { Info "... (รวมทั้งหมด $($hits.Count) ตำแหน่ง)" }
} else {
  Info "ไม่พบข้อความ $OldId ในไฟล์ที่สแกน"
}

if (-not $NoPrompt) {
  $ans = Read-Host "ดำเนินการต่อหรือไม่? (Y/N)"
  if ($ans -notin @('y','Y')) { Info "ยกเลิก"; exit 0 }
}

# --- 1) Rename YAML file (ถ้ามีไฟล์เก่า) ---
if (Test-Path $oldYml) {
  if (Test-Path $newYml) {
    Warn "มีไฟล์ $newYml อยู่แล้ว จะข้ามการ rename"
  } else {
    Rename-Item -Path $oldYml -NewName (Split-Path -Leaf $newYml)
    Ok "เปลี่ยนชื่อไฟล์ข้อมูล: $OldId.yml -> $NewId.yml"
  }
}

# --- 2) แก้ความสอดคล้องใน YAML (id / base_dir / cover) ---
$ymls = Get-ChildItem -Path $dataDir -Filter *.yml -File
foreach ($f in $ymls) {
  $content = Get-Content $f.FullName -Raw -Encoding UTF8
  $orig = $content

  # id: "old" → id: "new"
  $content = $content -replace "(?m)^(\s*)id:\s*[""']$([Regex]::Escape($OldId))[""']\s*$", "`${1}id: `"$NewId`""

  # base_dir: "assets/stickers/old" → .../new
  $content = $content -replace "(?m)^(\s*)base_dir:\s*[""']assets/stickers/$([Regex]::Escape($OldId))[""']\s*$", "`${1}base_dir: `"assets/stickers/$NewId`""

  # cover: "assets/stickers/old/cover.png" → .../new/cover.png
  $content = $content -replace "(?m)^(\s*)cover:\s*[""']assets/stickers/$([Regex]::Escape($OldId))/cover\.png[""']\s*$", "`${1}cover: `"assets/stickers/$NewId/cover.png`""

  if ($content -ne $orig) {
    Set-Content -Path $f.FullName -Value $content -Encoding UTF8
    Ok "อัปเดตคีย์ใน: $($f.Name)"
  }
}

# --- 3) Rename asset folder (ถ้ามี) ---
if (Test-Path $oldDir) {
  if (Test-Path $newDir) {
    Warn "พบ $newDir อยู่แล้ว จะข้ามการย้าย"
  } else {
    Rename-Item -Path $oldDir -NewName (Split-Path -Leaf $newDir)
    Ok "ย้ายโฟลเดอร์รูป: $OldId -> $NewId"
  }
}

# --- 4) รายงานคงค้างหลังแก้ ---
$left = Get-ChildItem -Path (Join-Path $repo "site") -Recurse -File -Include *.yml,*.yaml,*.html,*.md,*.toml |
        Select-String -SimpleMatch $OldId
if ($left) {
  Warn "ยังพบคำว่า `"$OldId`" อีก $($left.Count) ตำแหน่ง (ตรวจสอบด้วยตนเอง):"
  $left | ForEach-Object { "  $($_.Path):$($_.LineNumber): $($_.Line.Trim())" } | Select-Object -First 10
} else {
  Ok "ทำความสะอาดเรียบร้อย ไม่เหลือ `$OldId` ในไฟล์ที่สแกน"
}

Info "เสร็จแล้ว ลอง commit/push แล้วเปิดหน้าเว็บดูอีกครั้งได้เลย"
