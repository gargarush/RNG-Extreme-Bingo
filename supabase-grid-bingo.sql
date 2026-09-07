-- Grid Bingo round tables (additive, run alongside supabase-rooms.sql)

create table rounds (
  id text primary key,
  room_code text not null,
  created_at bigint not null,
  grid_size int not null,
  card_mode text not null,
  scoring_mode text not null,
  shared_card jsonb,
  winner_id text,
  ended_at bigint,
  card_visibility text not null default 'hidden'
);

alter table rounds enable row level security;
create policy "read"   on rounds for select using (true);
create policy "insert" on rounds for insert with check (true);
create policy "update" on rounds for update using (true);

create table round_entries (
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

alter table round_entries enable row level security;
create policy "read"   on round_entries for select using (true);
create policy "insert" on round_entries for insert with check (true);
create policy "update" on round_entries for update using (true);
