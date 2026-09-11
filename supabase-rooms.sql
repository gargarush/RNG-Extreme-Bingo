create table rooms (
  code text primary key,
  created_at bigint not null
);

alter table rooms enable row level security;

create policy "read" on rooms for select using (true);
create policy "insert" on rooms for insert with check (true);

alter table boards add column room_code text null;
alter table boards add column if not exists accent text;
