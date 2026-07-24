-- withyou+ 관리자 권한(RLS) 추가 스키마
-- 앱 스키마(supabase/schema.sql)를 먼저 실행한 뒤, 이 파일을 SQL Editor 에서 실행하세요.
-- 이 정책으로 'admins 테이블에 등록된 사용자'만 모든 사용자 데이터를 조회할 수 있습니다.

-- 1) 관리자 목록 테이블 ------------------------------------------------------
create table if not exists public.admins (
  id         uuid primary key references auth.users (id) on delete cascade,
  created_at timestamptz not null default now()
);

alter table public.admins enable row level security;

-- 본인이 admin 인지 확인할 수 있게 자기 행 조회 허용(정책 서브쿼리에 필요).
drop policy if exists "admins read self" on public.admins;
create policy "admins read self"
  on public.admins for select
  using (auth.uid() = id);

-- 2) 관리자에게 전체 조회(select) 허용 --------------------------------------
drop policy if exists "admins read all profiles" on public.profiles;
create policy "admins read all profiles"
  on public.profiles for select
  using (exists (select 1 from public.admins a where a.id = auth.uid()));

drop policy if exists "admins read all user_state" on public.user_state;
create policy "admins read all user_state"
  on public.user_state for select
  using (exists (select 1 from public.admins a where a.id = auth.uid()));

-- 3) 관리자 계정 등록 --------------------------------------------------------
-- (1) Supabase Authentication → Users 에서 관리자 이메일로 계정을 먼저 만든 뒤,
-- (2) 아래에 그 계정의 uuid 를 넣어 실행하세요.
--     예) insert into public.admins (id) values ('00000000-0000-0000-0000-000000000000');
--
-- 이메일로 바로 등록하려면:
-- insert into public.admins (id)
-- select id from auth.users where email = 'admin@example.com'
-- on conflict do nothing;
