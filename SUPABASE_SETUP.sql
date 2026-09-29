-- MC BIM Mission Control - shared collaboration layer
-- Run once in: Supabase Dashboard > SQL Editor.
-- This script never uses or exposes a service_role key in the browser.

create extension if not exists pgcrypto;

create table if not exists public.mc_workspaces (
  id uuid primary key default gen_random_uuid(),
  name text not null check (char_length(name) between 1 and 120),
  access_code text not null unique check (char_length(access_code) >= 8),
  created_by uuid not null references auth.users(id),
  created_at timestamptz not null default now()
);

create table if not exists public.mc_workspace_members (
  workspace_id uuid not null references public.mc_workspaces(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  role text not null check (role in ('admin','editor','viewer')) default 'editor',
  joined_at timestamptz not null default now(),
  primary key (workspace_id, user_id)
);

create table if not exists public.mc_workspace_state (
  workspace_id uuid primary key references public.mc_workspaces(id) on delete cascade,
  data jsonb not null,
  revision bigint not null default 1,
  updated_by uuid not null references auth.users(id),
  updated_at timestamptz not null default now()
);

-- Immutable server-side snapshots complement MC's in-app change log.
create table if not exists public.mc_workspace_audit (
  id bigint generated always as identity primary key,
  workspace_id uuid not null references public.mc_workspaces(id) on delete cascade,
  revision bigint not null,
  changed_by uuid not null references auth.users(id),
  changed_at timestamptz not null default now(),
  state_snapshot jsonb not null
);

create or replace function public.mc_is_member(p_workspace_id uuid)
returns boolean language sql stable security definer set search_path = public as $$
  select exists (
    select 1 from public.mc_workspace_members
    where workspace_id = p_workspace_id and user_id = auth.uid()
  );
$$;

create or replace function public.mc_can_edit(p_workspace_id uuid)
returns boolean language sql stable security definer set search_path = public as $$
  select exists (
    select 1 from public.mc_workspace_members
    where workspace_id = p_workspace_id and user_id = auth.uid()
      and role in ('admin','editor')
  );
$$;

alter table public.mc_workspaces enable row level security;
alter table public.mc_workspace_members enable row level security;
alter table public.mc_workspace_state enable row level security;
alter table public.mc_workspace_audit enable row level security;

revoke all on public.mc_workspaces, public.mc_workspace_members, public.mc_workspace_state, public.mc_workspace_audit from anon;
grant select on public.mc_workspaces, public.mc_workspace_members, public.mc_workspace_state, public.mc_workspace_audit to authenticated;

drop policy if exists "MC members read workspaces" on public.mc_workspaces;
create policy "MC members read workspaces" on public.mc_workspaces for select to authenticated
using (public.mc_is_member(id));

drop policy if exists "MC members read members" on public.mc_workspace_members;
create policy "MC members read members" on public.mc_workspace_members for select to authenticated
using (public.mc_is_member(workspace_id));

drop policy if exists "MC members read state" on public.mc_workspace_state;
create policy "MC members read state" on public.mc_workspace_state for select to authenticated
using (public.mc_is_member(workspace_id));

drop policy if exists "MC members read audit" on public.mc_workspace_audit;
create policy "MC members read audit" on public.mc_workspace_audit for select to authenticated
using (public.mc_is_member(workspace_id));

create or replace function public.mc_write_audit()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.mc_workspace_audit(workspace_id, revision, changed_by, state_snapshot)
  values (new.workspace_id, new.revision, new.updated_by, new.data);
  return new;
end;
$$;

drop trigger if exists mc_workspace_audit_trigger on public.mc_workspace_state;
create trigger mc_workspace_audit_trigger
after insert or update on public.mc_workspace_state
for each row execute function public.mc_write_audit();

create or replace function public.mc_create_workspace(
  p_name text, p_access_code text, p_state jsonb
)
returns table(workspace_id uuid, access_code text, revision bigint, role text)
language plpgsql security definer set search_path = public as $$
declare v_id uuid;
begin
  if auth.uid() is null then raise exception 'Sign in required'; end if;
  insert into public.mc_workspaces(name, access_code, created_by)
  values (trim(p_name), upper(trim(p_access_code)), auth.uid()) returning id into v_id;
  insert into public.mc_workspace_members(workspace_id, user_id, role) values (v_id, auth.uid(), 'admin');
  insert into public.mc_workspace_state(workspace_id, data, revision, updated_by) values (v_id, p_state, 1, auth.uid());
  return query select v_id, upper(trim(p_access_code)), 1::bigint, 'admin'::text;
end;
$$;

create or replace function public.mc_join_workspace(p_access_code text)
returns table(workspace_id uuid, access_code text, revision bigint, role text)
language plpgsql security definer set search_path = public as $$
declare v_id uuid; v_role text; v_revision bigint; v_code text;
begin
  if auth.uid() is null then raise exception 'Sign in required'; end if;
  select id, access_code into v_id, v_code from public.mc_workspaces where access_code = upper(trim(p_access_code));
  if v_id is null then raise exception 'Workspace not found'; end if;
  insert into public.mc_workspace_members(workspace_id, user_id, role)
  values(v_id, auth.uid(), 'editor') on conflict (workspace_id,user_id) do nothing;
  select m.role, s.revision into v_role, v_revision from public.mc_workspace_members m join public.mc_workspace_state s on s.workspace_id=m.workspace_id where m.workspace_id=v_id and m.user_id=auth.uid();
  return query select v_id, v_code, v_revision, v_role;
end;
$$;

create or replace function public.mc_save_workspace_state(
  p_workspace_id uuid, p_expected_revision bigint, p_state jsonb, p_force boolean default false
)
returns table(revision bigint)
language plpgsql security definer set search_path = public as $$
declare v_revision bigint;
begin
  if auth.uid() is null or not public.mc_can_edit(p_workspace_id) then raise exception 'Editor permission required'; end if;
  update public.mc_workspace_state
     set data=p_state, revision=revision+1, updated_by=auth.uid(), updated_at=now()
   where workspace_id=p_workspace_id and (p_force or revision=p_expected_revision)
   returning revision into v_revision;
  if v_revision is null then raise exception 'Revision conflict'; end if;
  return query select v_revision;
end;
$$;

revoke all on function public.mc_create_workspace(text,text,jsonb), public.mc_join_workspace(text), public.mc_save_workspace_state(uuid,bigint,jsonb,boolean) from public, anon;
grant execute on function public.mc_create_workspace(text,text,jsonb), public.mc_join_workspace(text), public.mc_save_workspace_state(uuid,bigint,jsonb,boolean) to authenticated;

-- Enable real-time events for the one state row per workspace.
alter table public.mc_workspace_state replica identity full;
do $$ begin
  alter publication supabase_realtime add table public.mc_workspace_state;
exception when duplicate_object then null;
end $$;

-- Administration: change a member's role in the Supabase SQL Editor, for example:
-- update public.mc_workspace_members set role='viewer' where workspace_id='...' and user_id='...';
