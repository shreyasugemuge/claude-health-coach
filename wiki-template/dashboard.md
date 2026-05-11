# Dashboard

Live read-only view powered by the [DataView](https://github.com/blacksmithgu/obsidian-dataview) and [Obsidian Charts](https://github.com/phibr0/obsidian-charts) community plugins. Open this file in Obsidian (reading view). Claude writes the YAML frontmatter that drives everything here. See the "Frontmatter contract" section in `CLAUDE.md`.

---

## Today

```dataviewjs
const today = window.moment().format("YYYY-MM-DD")
const yyyy = today.slice(0,4), mm = today.slice(5,7), dd = today.slice(8,10)
const path = `wiki/logs/${yyyy}/${mm}/${dd}.md`

const targets = dv.page("wiki/targets/current")
const log = dv.page(path)

if (!targets) {
  dv.paragraph("_No targets file. Run onboarding first._")
} else {
  const kcalTgt = targets.kcal ?? 0
  const pTgt = targets.protein_g ?? 0
  const kcal = log?.kcal_actual ?? 0
  const p = log?.protein_g_actual ?? 0
  const kcalPct = kcalTgt ? Math.min(100, Math.round(kcal / kcalTgt * 100)) : 0
  const pPct = pTgt ? Math.min(100, Math.round(p / pTgt * 100)) : 0

  const status = log ? "end-of-day" : "in progress (no frontmatter yet)"
  dv.paragraph(`**${today}** , status: _${status}_`)
  dv.paragraph(`Energy: **${kcal}** / ${kcalTgt} kcal (${kcalPct}%)`)
  dv.paragraph(`Protein: **${p}** / ${pTgt} g (${pPct}%)`)
}
```

---

## Weight trend

```dataviewjs
const a = dv.page("wiki/profile/anthropometry")
if (!a || !a.weight_log) {
  dv.paragraph("_No weight_log frontmatter in wiki/profile/anthropometry.md_")
} else {
  const entries = a.weight_log.slice(-60)
  const toDateStr = v => (v && typeof v === "object" && v.toISOString)
    ? v.toISOString().slice(0,10)
    : String(v)
  const labels = entries.map(e => toDateStr(e[0]))
  const data = entries.map(e => Number(e[1]))
  const chart = {
    type: "line",
    data: {
      labels,
      datasets: [{label: "Weight (kg)", data, borderWidth: 2, tension: 0.2}]
    },
    options: {
      scales: {y: {beginAtZero: false}},
      plugins: {legend: {display: false}}
    }
  }
  window.renderChart(chart, this.container)
}
```

---

## Latest biomarkers

```dataviewjs
const cutoffs = {
  LDL:  {hi: 100, label: "mg/dL"},
  HDL:  {lo: 50,  label: "mg/dL"},
  TG:   {hi: 150, label: "mg/dL"},
  TC:   {hi: 200, label: "mg/dL"},
  HbA1c:{hi: 5.7, label: "%"},
  FPG:  {hi: 100, label: "mg/dL"},
}
const files = dv.pages('"wiki/biomarkers"').where(p => p.latest)
if (!files.length) {
  dv.paragraph("_No biomarker files with a `latest:` frontmatter block yet._")
} else {
  const rows = []
  for (const f of files) {
    const L = f.latest
    for (const [k, v] of Object.entries(L)) {
      if (k === "date" || k === "lab") continue
      const c = cutoffs[k]
      let flag = ""
      if (c?.hi && Number(v) > c.hi) flag = " ⚠"
      if (c?.lo && Number(v) < c.lo) flag = " ⚠"
      rows.push([f.file.name, k, `${v}${flag}`, L.date, L.lab ?? ""])
    }
  }
  dv.table(["Panel", "Metric", "Value", "Date", "Lab"], rows)
}
```

---

## 30-day adherence

```dataviewjs
const targets = dv.page("wiki/targets/current")
const kcalTgt = targets?.kcal ?? 0
const cutoff = window.moment().subtract(29, "days")
const pages = dv.pages('"wiki/logs"')
  .where(p => p.date && window.moment(p.date.toString()).isSameOrAfter(cutoff))
  .sort(p => p.date, "asc")

if (!pages.length) {
  dv.paragraph("_No daily logs with frontmatter in the last 30 days._")
} else {
  const rows = pages.map(p => {
    const k = p.kcal_actual ?? 0
    const pct = kcalTgt ? Math.round(k / kcalTgt * 100) : 0
    let band = "-"
    if (kcalTgt) {
      if (pct >= 90 && pct <= 110) band = "🟢"
      else if (pct >= 80 && pct <= 120) band = "🟡"
      else band = "🔴"
    }
    return [p.date.toString(), k, p.protein_g_actual ?? 0, p.weight_kg ?? "", band]
  })
  dv.table(["Date", "kcal", "Protein g", "Weight kg", "Adherence"], rows)
}
```

---

## Recent activity

```dataviewjs
const text = await dv.io.load("log.md")
if (!text) {
  dv.paragraph("_No log.md found._")
} else {
  const lines = text.split("\n").filter(l => l.startsWith("## ["))
  const last = lines.slice(-20).reverse()
  dv.list(last.map(l => l.replace(/^## /, "")))
}
```
