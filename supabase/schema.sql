-- TimeVault cloud sync: one row per account holding that account's whole vault.
-- Run once in Supabase → SQL Editor → New query → Run.

create table if not exists public.timevault_state (
  user_id    uuid primary key default auth.uid() references auth.users (id) on delete cascade,
  data       jsonb not null,
  updated_at timestamptz not null default now()
);

-- Row-level security: each signed-in user can only see and change their own row.
alter table public.timevault_state enable row level security;

drop policy if exists "Read own vault" on public.timevault_state;
create policy "Read own vault" on public.timevault_state
  for select to authenticated using ((select auth.uid()) = user_id);

drop policy if exists "Create own vault" on public.timevault_state;
create policy "Create own vault" on public.timevault_state
  for insert to authenticated with check ((select auth.uid()) = user_id);

drop policy if exists "Update own vault" on public.timevault_state;
create policy "Update own vault" on public.timevault_state
  for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);

-- Live updates to other open devices.
do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'timevault_state'
  ) then
    alter publication supabase_realtime add table public.timevault_state;
  end if;
end $$;
