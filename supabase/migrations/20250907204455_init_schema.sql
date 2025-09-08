-- Extensions
create extension if not exists "uuid-ossp";
create extension if not exists "pgcrypto";

-- =========================
-- Core entities
-- =========================

create table public.organizations (
  id   uuid primary key default gen_random_uuid(),
  name text not null
);

create table public.events (
  id      uuid primary key default gen_random_uuid(),
  org_id  uuid not null
          references public.organizations(id)
          on delete cascade,
  name    text not null
);

create table public.tasks (
  id       uuid primary key default gen_random_uuid(),
  event_id uuid not null
           references public.events(id)
           on delete cascade,
  name     text not null
);

create table public.volunteers (
  id   uuid primary key default gen_random_uuid(),
  name text not null
);

-- =========================
-- Many-to-many join tables
-- =========================

-- Volunteers <-> Events
create table public.volunteer_events (
  id           uuid primary key default gen_random_uuid(),
  volunteer_id uuid not null
               references public.volunteers(id)
               on delete cascade,
  event_id     uuid not null
               references public.events(id)
               on delete cascade,
  -- Prevent duplicate (volunteer, event) rows
  constraint volunteer_events_unique unique (volunteer_id, event_id)
);

-- Volunteers <-> Tasks
create table public.volunteer_tasks (
  id           uuid primary key default gen_random_uuid(),
  volunteer_id uuid not null
               references public.volunteers(id)
               on delete cascade,
  task_id      uuid not null
               references public.tasks(id)
               on delete cascade,
  -- Prevent duplicate (volunteer, task) rows
  constraint volunteer_tasks_unique unique (volunteer_id, task_id)
);