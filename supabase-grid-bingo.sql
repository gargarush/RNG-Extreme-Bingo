-- Grid Bingo round tables (additive, run alongside supabase-rooms.sql)
--
-- Safe to re-run any time: creates the tables if missing, and adds any
-- columns introduced in later revisions if they aren't already there.
-- (The previous version of this file was a single `create table`, which
-- silently no-ops with "already exists" once the table has been created
-- once — that's how the `dnf` column ended up missing in production even
-- though this file listed it: re-running the file never actually added it.)

create table if not exists rounds (
  id text primary key,
  room_code text not null,
  created_at bigint not null,
  grid_size int,
  card_mode text not null,
  scoring_mode text not null,
  shared_card jsonb,
  winner_id text,
  ended_at bigint
);
alter table rounds add column if not exists card_visibility text not null default 'hidden';
alter table rounds add column if not exists started_by text;
alter table rounds add column if not exists ended_by text;
alter table rounds add column if not exists layout text not null default 'square';
alter table rounds add column if not exists dnf boolean not null default false;
alter table rounds add column if not exists teams jsonb;
alter table rounds add column if not exists team_shared_edit boolean not null default false;
alter table rounds add column if not exists underdog_bonus text not null default 'none';

alter table rounds enable row level security;
drop policy if exists "read" on rounds;
create policy "read"   on rounds for select using (true);
drop policy if exists "insert" on rounds;
create policy "insert" on rounds for insert with check (true);
drop policy if exists "update" on rounds;
create policy "update" on rounds for update using (true);

create table if not exists round_entries (
  round_id text not null references rounds(id),
  player_id text not null,
  player_name text not null,
  card jsonb not null,
  marks jsonb not null default '{}'::jsonb,
  lines_completed int not null default 0,
  points int not null default 0,
  finished_at bigint,
  primary key (round_id, player_id)
);
alter table round_entries add column if not exists marked_by jsonb not null default '{}'::jsonb;
alter table round_entries add column if not exists version int not null default 0;
alter table round_entries add column if not exists blocked_attempts jsonb not null default '{}'::jsonb;

alter table round_entries enable row level security;
drop policy if exists "read" on round_entries;
create policy "read"   on round_entries for select using (true);
drop policy if exists "insert" on round_entries;
create policy "insert" on round_entries for insert with check (true);
drop policy if exists "update" on round_entries;
create policy "update" on round_entries for update using (true);
