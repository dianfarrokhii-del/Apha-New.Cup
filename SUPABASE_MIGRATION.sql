-- New.Cup 2 / Supabase migration for the real website
-- Run this ONCE after the original setup.

alter table public.tournament_registrations
add column if not exists user_id uuid references auth.users(id) on delete cascade;

-- Replace the original INSERT policy so users can only create a row for themselves.
drop policy if exists "Authenticated users can create registrations" on public.tournament_registrations;
create policy "Users can create their own registrations"
on public.tournament_registrations
for insert
to authenticated
with check (user_id = auth.uid());

-- Users can see only their own registration; admins can see all.
drop policy if exists "Admins can view all registrations" on public.tournament_registrations;
create policy "Users can view own registrations or admins can view all"
on public.tournament_registrations
for select
to authenticated
using (
  user_id = auth.uid()
  or exists (
    select 1 from public.admin_users
    where admin_users.user_id = auth.uid()
  )
);

-- Only admins can update registrations.
drop policy if exists "Admins can update registrations" on public.tournament_registrations;
create policy "Admins can update registrations"
on public.tournament_registrations
for update
to authenticated
using (
  exists (
    select 1 from public.admin_users
    where admin_users.user_id = auth.uid()
  )
)
with check (
  exists (
    select 1 from public.admin_users
    where admin_users.user_id = auth.uid()
  )
);

-- Helpful index
create index if not exists tournament_registrations_user_id_idx
on public.tournament_registrations(user_id);
