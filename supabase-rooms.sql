create table rooms (
  code text primary key,
  created_at bigint not null
);
alter table rooms add column if not exists public boolean not null default false;

alter table rooms enable row level security;

drop policy if exists "read" on rooms;
create policy "read" on rooms for select using (true);
drop policy if exists "insert" on rooms;
create policy "insert" on rooms for insert with check (true);
-- Toggling public/private is the same permission model as kicking a roommate elsewhere in this
-- app: any authenticated user, not just whoever created the room.
drop policy if exists "update" on rooms;
create policy "update" on rooms for update using (true);

alter table boards add column room_code text null;
alter table boards add column if not exists accent text;
