# withyou+ 관리자 페이지

withyou+ 앱의 **웹 관리자 대시보드**입니다. Supabase 백엔드에 연결해
사용자·마음 리포트·대화·안전 로그를 조회합니다. 순수 정적 사이트(HTML 하나)라
GitHub Pages 로 배포됩니다.

## 🔗 배포 링크
GitHub Pages: `https://withyou-app.github.io/withyou-admin/`

> 앱의 백엔드(Supabase)가 설정돼 있어야 실제 데이터가 보입니다. 백엔드 설정은
> 앱 레포의 `docs/BACKEND_SETUP.md` 를 참고하세요.

## 사용 방법
1. 위 링크 접속.
2. **Supabase URL / anon public key** 입력(앱과 동일한 프로젝트).
3. **관리자 이메일/비밀번호**로 로그인.
4. 사용자 / 마음 리포트 / 대화 / 안전 로그 탭에서 조회.

값은 브라우저 `localStorage` 에만 저장되며 서버로 전송되지 않습니다.

## 관리자 계정 설정(중요)
관리자만 전체 사용자 데이터를 볼 수 있도록 RLS 로 제한합니다.

1. 앱 레포의 `supabase/schema.sql` 을 먼저 실행(테이블+기본 RLS).
2. 이 레포의 [`schema_admin.sql`](./schema_admin.sql) 을 Supabase **SQL Editor** 에서 실행.
3. Supabase **Authentication → Users** 에서 관리자 이메일로 계정 생성.
4. 아래 SQL 로 그 계정을 `admins` 에 등록:
   ```sql
   insert into public.admins (id)
   select id from auth.users where email = 'admin@example.com'
   on conflict do nothing;
   ```

이제 해당 계정으로 관리자 페이지에 로그인하면 모든 사용자 데이터가 보입니다.
등록되지 않은 계정은 RLS 에 의해 자신의 데이터만(또는 아무것도) 보이지 않습니다.

## 보안 메모
- 이 사이트는 **anon key** 만 사용합니다(공개돼도 안전한 키). 전체 조회 권한은
  Supabase Auth 로그인 + `admins` 등록 여부로만 부여됩니다.
- `service_role` 키는 절대 이 사이트/레포에 넣지 마세요.

## 로컬 실행
정적 파일이라 그냥 열어도 되고, 간단히:
```bash
python -m http.server 8080   # http://localhost:8080
```
