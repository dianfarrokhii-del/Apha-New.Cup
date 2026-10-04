-- New.Cup 2 - Safe Migration

-- اتصال ثبت‌نام به حساب کاربری
alter table public.tournament_registrations
add column if not exists user_id uuid
references auth.users(id) on delete cascade;

-- =========================
-- TOURNAMENT REGISTRATIONS
-- =========================

drop policy if exists "Authenticated users can create registrations"
on public.tournament_registrations;

drop policy if exists "Users can create their own registrations"
on public.tournament_registrations;

create policy "Users can create their own registrations"
on public.tournament_registrations
for insert
to authenticated
with check (user_id = auth.uid());


drop policy if exists "Admins can view all registrations"
on public.tournament_registrations;

drop policy if exists "Users can view own registrations or admins can view all"
on public.tournament_registrations;

create policy "Users can view own registrations or admins can view all"
on public.tournament_registrations
for select
to authenticated
using (
  user_id = auth.uid()
  or exists (
    select 1
    from public.admin_users
    where admin_users.user_id = auth.uid()
  )
);


drop policy if exists "Admins can update registrations"
on public.tournament_registrations;

create policy "Admins can update registrations"
on public.tournament_registrations
for update
to authenticated
using (
  exists (
    select 1
    from public.admin_users
    where admin_users.user_id = auth.uid()
  )
)
with check (
  exists (
    select 1
    from public.admin_users
    where admin_users.user_id = auth.uid()
  )
);

create index if not exists tournament_registrations_user_id_idx
on public.tournament_registrations(user_id);


-- =========================
-- NEWS
-- =========================

create table if not exists public.news (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  content text not null,
  tag text not null default 'OFFICIAL',
  icon text not null default '📰',
  is_featured boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.news enable row level security;


drop policy if exists "Public can read news"
on public.news;

create policy "Public can read news"
on public.news
for select
to anon, authenticated
using (true);


drop policy if exists "Admins can insert news"
on public.news;

create policy "Admins can insert news"
on public.news
for insert
to authenticated
with check (
  exists (
    select 1
    from public.admin_users
    where admin_users.user_id = auth.uid()
  )
);


drop policy if exists "Admins can update news"
on public.news;

create policy "Admins can update news"
on public.news
for update
to authenticated
using (
  exists (
    select 1
    from public.admin_users
    where admin_users.user_id = auth.uid()
  )
)
with check (
  exists (
    select 1
    from public.admin_users
    where admin_users.user_id = auth.uid()
  )
);


drop policy if exists "Admins can delete news"
on public.news;

create policy "Admins can delete news"
on public.news
for delete
to authenticated
using (
  exists (
    select 1
    from public.admin_users
    where admin_users.user_id = auth.uid()
  )
);