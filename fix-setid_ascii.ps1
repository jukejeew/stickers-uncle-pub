param(
  [Parameter(Mandatory = $true)][string]$OldId,
  [Parameter(Mandatory = $true)][string]$NewId,
  [string]$RepoRoot = ".",
  [switch]$NoPrompt
)

function Info($msg){ Write-Host "[i] $msg" -ForegroundColor Cyan }
function Ok($msg){ Write-Host "[ok] $msg" -ForegroundColor Green }
function Warn($msg){ Write-Host "[!] $msg" -ForegroundColor Yellow }
function Err($msg){ Write-Host "[xx] $msg" -ForegroundColor Red }

$repo = Resolve-Path $RepoRoot
$dataDir   = Join-Path $repo "site\data\stickers"
$staticDir = Join-Path $repo "site\static\assets\stickers"

if (-not (Test-Path $dataDir)) { Err "Missing folder: $dataDir"; exit 1 }
if (-not (Test-Path $staticDir)) { Err "Missing folder: $staticDir"; exit 1 }

$oldYml = Join-Path $dataDir "$OldId.yml"
$newYml = Join-Path $dataDir "$NewId.yml"
$oldDir = Join-Path $staticDir $OldId
$newDir = Join-Path $staticDir $NewId

Info "Planned changes:"
if (Test-Path $oldYml) { Info "  YAML file: $oldYml -> $newYml" } else { Warn "  YAML file not found: $oldYml" }
if (Test-Path $oldDir) { Info "  Asset dir: $oldDir -> $newDir" } else { Warn "  Asset dir not found: $oldDir" }

$hits = Get-ChildItem -Path (Join-Path $repo "site") -Recurse -File -Include *.yml,*.yaml,*.html,*.md,*.toml |
        Select-String -SimpleMatch $OldId
if ($hits) {
  Info ("Found {0} occurrences of '{1}' (showing first 8):" -f $hits.Count, $OldId)
  $hits | Select-Object -First 8 | ForEach-Object { Write-Host ("  {0}:{1}: {2}" -f $_.Path, $_.LineNumber, $_.Line.Trim()) }
} else {
  Info "No plain occurrences of OldId found in 'site' folder."
}

if (-not $NoPrompt) {
  $ans = Read-Host "Proceed? (Y/N)"
  if ($ans -notin @('y','Y')) { Info "Cancelled."; exit 0 }
}

# 1) Rename YAML file, if present
if (Test-Path $oldYml) {
  if (Test-Path $newYml) {
    Warn "Target YAML already exists: $newYml (skipping rename)"
  } else {
    Rename-Item -Path $oldYml -NewName (Split-Path -Leaf $newYml)
    Ok "Renamed YAML file."
  }
}

# 2) Update keys inside all YAML files in site/data/stickers
$ymls = Get-ChildItem -Path $dataDir -Filter *.yml -File
$escaped = [Regex]::Escape($OldId)

foreach ($f in $ymls) {
  $content = Get-Content $f.FullName -Raw -Encoding UTF8
  $orig = $content

  # id: "old"  -> id: "new"
  $content = $content -replace "id:\s*[""`']$escaped[""`']", ('id: "' + $NewId + '"')

  # base_dir: "assets/stickers/old" -> .../new
  $content = $content -replace "base_dir:\s*[""`']assets/stickers/$escaped[""`']", ('base_dir: "assets/stickers/' + $NewId + '"')

  # cover: "assets/stickers/old/cover.png" -> .../new/cover.png
  $content = $content -replace "cover:\s*[""`']assets/stickers/$escaped/cover\.png[""`']", ('cover: "assets/stickers/' + $NewId + '/cover.png"')

  if ($content -ne $orig) {
    Set-Content -Path $f.FullName -Value $content -Encoding UTF8
    Ok ("Updated keys in: {0}" -f $f.Name)
  }
}

# 3) Rename asset folder
if (Test-Path $oldDir) {
  if (Test-Path $newDir) {
    Warn "Target asset dir already exists: $newDir (skipping rename)"
  } else {
    Rename-Item -Path $oldDir -NewName (Split-Path -Leaf $newDir)
    Ok "Renamed asset folder."
  }
}

# 4) Final scan for leftovers
$left = Get-ChildItem -Path (Join-Path $repo "site") -Recurse -File -Include *.yml,*.yaml,*.html,*.md,*.toml |
        Select-String -SimpleMatch $OldId
if ($left) {
  Warn ("Still found {0} occurrences of '{1}' (showing first 10):" -f $left.Count, $OldId)
  $left | Select-Object -First 10 | ForEach-Object { Write-Host ("  {0}:{1}: {2}" -f $_.Path, $_.LineNumber, $_.Line.Trim()) }
} else {
  Ok "All done. No OldId left in scanned files."
}
