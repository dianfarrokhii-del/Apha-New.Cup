-- New.Cup 2 FINAL migration
-- Run this ONCE in Supabase SQL Editor.

alter table public.tournament_registrations enable row level security;

alter table public.tournament_registrations
  add column if not exists user_id uuid references auth.users(id) on delete cascade;

-- RPC: submit a registration without relying on PostgREST's cached table columns.
create or replace function public.submit_tournament_registration(
  p_player1 text,
  p_player2 text,
  p_contact text
)
returns json
language plpgsql
security definer
set search_path = public
as $$
declare
  new_id uuid;
begin
  if auth.uid() is null then
    raise exception 'ابتدا وارد حساب کاربری شو';
  end if;

  insert into public.tournament_registrations
    (user_id, player1, player2, contact, status)
  values
    (auth.uid(), p_player1, p_player2, p_contact, 'pending')
  returning id into new_id;

  return json_build_object('id', new_id);
end;
$$;

revoke all on function public.submit_tournament_registration(text,text,text) from public;
grant execute on function public.submit_tournament_registration(text,text,text) to authenticated;

-- RPC: get the latest registration of the current user.
create or replace function public.get_my_tournament_registration()
returns table (
  player1 text,
  player2 text,
  contact text,
  status text,
  admin_note text,
  created_at timestamptz
)
language sql
security definer
set search_path = public
as $$
  select r.player1, r.player2, r.contact, r.status, r.admin_note, r.created_at
  from public.tournament_registrations r
  where r.user_id = auth.uid()
  order by r.created_at desc
  limit 1;
$$;

revoke all on function public.get_my_tournament_registration() from public;
grant execute on function public.get_my_tournament_registration() to authenticated;

-- Admin/news table.
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

drop policy if exists "Public can read news" on public.news;
create policy "Public can read news"
on public.news for select
to anon, authenticated
using (true);

drop policy if exists "Admins can insert news" on public.news;
create policy "Admins can insert news"
on public.news for insert
to authenticated
with check (
  exists (select 1 from public.admin_users a where a.user_id = auth.uid())
);

drop policy if exists "Admins can update news" on public.news;
create policy "Admins can update news"
on public.news for update
to authenticated
using (
  exists (select 1 from public.admin_users a where a.user_id = auth.uid())
)
with check (
  exists (select 1 from public.admin_users a where a.user_id = auth.uid())
);

drop policy if exists "Admins can delete news" on public.news;
create policy "Admins can delete news"
on public.news for delete
to authenticated
using (
  exists (select 1 from public.admin_users a where a.user_id = auth.uid())
);

-- Make sure the admin can read all registrations.
drop policy if exists "Admins can view all registrations" on public.tournament_registrations;
create policy "Admins can view all registrations"
on public.tournament_registrations for select
to authenticated
using (
  exists (select 1 from public.admin_users a where a.user_id = auth.uid())
);

drop policy if exists "Admins can update registrations" on public.tournament_registrations;
create policy "Admins can update registrations"
on public.tournament_registrations for update
to authenticated
using (
  exists (select 1 from public.admin_users a where a.user_id = auth.uid())
)
with check (
  exists (select 1 from public.admin_users a where a.user_id = auth.uid())
);
