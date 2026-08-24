# MCU Watch Timeline

A tiny Cloudflare Pages + D1 app that tracks which MCU movies/shows you've
watched, laid out on a **story-chronological** timeline (not release order).
The public page reads its watch status from D1.

## Stack

- **Cloudflare Pages** — hosts `public/` (static HTML/CSS/JS)
- **Pages Functions** (`functions/api/*.js`) — small API routes
- **Cloudflare D1** (free tier) — stores the list + watched flags

No frontend framework, no build step — everything ships as-is.

## 1. Prerequisites

- A Cloudflare account (free plan is enough)
- Your domain added to Cloudflare (nameservers pointed at Cloudflare)
- Node.js installed locally, plus `npx wrangler` (already a devDependency)

```powershell
npm install
npx wrangler login
```

## 2. Create the D1 database

```powershell
npx wrangler d1 create mcu_tracker_db
```

Copy the `database_id` from the output into [wrangler.toml](wrangler.toml)
(replace `REPLACE_WITH_YOUR_D1_DATABASE_ID`).

Load the schema and seed data:

```powershell
npm run db:migrate:remote
```

(Use `db:migrate:local` first if you want to test with `wrangler pages dev`
before touching production data.)

## 3. Customize your list

Edit [schema.sql](schema.sql) — add/remove/reorder rows. `chronological_order`
controls timeline position (story order), `phase` (1-6) only controls which
Infinity Stone color the card and gauntlet segment use. Re-run the migrate
command after changes (safe to re-run, it drops and recreates the table).

## 4. Deploy to Cloudflare Pages

```powershell
npx wrangler pages project create mcu-tracker
npm run deploy
```

In the Cloudflare dashboard: **Workers & Pages → mcu-tracker → Settings →
Bindings**, confirm the `DB` D1 binding is attached to the Production
environment (wrangler.toml usually does this automatically on deploy).

### Custom domain

**Workers & Pages → mcu-tracker → Custom domains → Set up a custom domain**,
e.g. `mcu.yourdomain.com`. Cloudflare issues the certificate automatically.

## 5. Local development

```powershell
npm run db:migrate:local
npm run dev
```

This runs Pages + Functions + a local D1 replica on `http://localhost:8788`.

Use `image_url` in [schema.sql](schema.sql) for optional direct poster or
backdrop URLs. The page renders them dark and blurred behind each card.

## Design notes

- Colors and the "gauntlet" progress bar are themed after the six Infinity
  Stones, one per MCU phase — each stone fills up and glows as you finish
  watching that phase's entries.
- The vertical timeline is ordered by **in-story chronology**, so phases
  visibly interleave (e.g. *Black Widow* sits before *Black Panther* even
  though it released later) — that's intentional, not a bug.
