-- Run in Supabase SQL Editor.
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null default '',
  role text not null default 'user' check (role in ('user','admin')),
  created_at timestamptz not null default now()
);
alter table public.profiles enable row level security;

create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = ''
as $$
begin
  insert into public.profiles (id, full_name)
  values (new.id, coalesce(new.raw_user_meta_data ->> 'full_name', ''));
  return new;
end;
$$;
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users
for each row execute procedure public.handle_new_user();

create policy "Users can read own profile" on public.profiles
for select to authenticated using (auth.uid() = id);
create policy "Users can update own name" on public.profiles
for update to authenticated using (auth.uid() = id) with check (auth.uid() = id);

-- Content tables for shared library data. Admin-only writes are enforced using profiles.role.
create table if not exists public.books (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  author text not null,
  type text not null default 'Book' check (type in ('Book','Manga')),
  category text,
  description text,
  cover_path text,
  created_by uuid references auth.users(id),
  created_at timestamptz not null default now()
);
create table if not exists public.announcements (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  body text not null,
  created_by uuid references auth.users(id),
  created_at timestamptz not null default now()
);
create table if not exists public.events (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  body text not null,
  created_by uuid references auth.users(id),
  created_at timestamptz not null default now()
);
create table if not exists public.book_requests (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null,
  author text,
  message text,
  status text not null default 'pending' check (status in ('pending','approved','rejected')),
  created_at timestamptz not null default now()
);
alter table public.books enable row level security;
alter table public.announcements enable row level security;
alter table public.events enable row level security;
alter table public.book_requests enable row level security;

create policy "Signed-in users can read books" on public.books for select to authenticated using (true);
create policy "Admins manage books" on public.books for all to authenticated
using (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin'))
with check (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin'));

create policy "Signed-in users read announcements" on public.announcements for select to authenticated using (true);
create policy "Admins manage announcements" on public.announcements for all to authenticated
using (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin'))
with check (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin'));

create policy "Signed-in users read events" on public.events for select to authenticated using (true);
create policy "Admins manage events" on public.events for all to authenticated
using (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin'))
with check (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin'));

create policy "Users read own requests" on public.book_requests for select to authenticated
using (user_id = auth.uid() or exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin'));
create policy "Users create own requests" on public.book_requests for insert to authenticated
with check (user_id = auth.uid());
create policy "Admins update requests" on public.book_requests for update to authenticated
using (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin'))
with check (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin'));

-- After registering your account, replace the email below with your account email.
-- Run this separately in SQL Editor to grant admin privileges:
-- update public.profiles set role = 'admin'
-- where id = (select id from auth.users where email = 'your-admin@email.com');
