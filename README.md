# shiftly — TimeVault

A personal work-time and salary vault in a single file, [index.html](index.html): workplaces, time entries with a live timer, monthly salary, people you manage, and reports with CSV export.

Live site: https://k-7-bee.github.io/shiftly/

## How data is stored

Every change is saved in the browser first, so the app works offline. If cloud sync is set up and you sign in (Settings → *Sync between devices*), the same data syncs to every device signed in to the same account:

- Changes upload about a second after you make them.
- Other open devices update live, and also check for changes whenever you return to the tab or come back online.
- If two devices change data at the same time, the most recent change wins.
- The first time you sign in on a device that already has its own data, that data is merged with your cloud copy, so nothing is lost.

## Setting up cloud sync (Supabase, free tier)

1. Create a project at [supabase.com](https://supabase.com).
2. Open **SQL Editor → New query**, paste the contents of [supabase/schema.sql](supabase/schema.sql), and click **Run**.
3. Go to **Authentication → URL Configuration**:
   - Set **Site URL** to `https://k-7-bee.github.io/shiftly/`.
   - Add the same URL under **Redirect URLs**.
4. Go to **Project Settings → API** and copy the **Project URL** and the **anon public** key.
5. Paste them into `SUPABASE_URL` and `SUPABASE_ANON_KEY` near the top of the *Cloud sync* section in `index.html`, then commit.

The anon key is designed to be public. The row-level security in `schema.sql` means each account can only read and write its own data.
