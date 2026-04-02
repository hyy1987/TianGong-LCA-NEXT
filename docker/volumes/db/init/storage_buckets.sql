-- Bootstrap TianGong storage buckets required by the self-hosted deployment.
insert into storage.buckets (id, name)
values
  ('external_docs', 'external_docs'),
  ('sys-files', 'sys-files'),
  ('lca_results', 'lca_results')
on conflict (id) do nothing;

do $$
begin
  if not exists (
    select 1
    from pg_policies
    where schemaname = 'storage'
      and tablename = 'objects'
      and policyname = 'tg_external_docs_authenticated_select'
  ) then
    create policy tg_external_docs_authenticated_select
      on storage.objects for select
      to authenticated
      using (bucket_id = 'external_docs');
  end if;

  if not exists (
    select 1
    from pg_policies
    where schemaname = 'storage'
      and tablename = 'objects'
      and policyname = 'tg_external_docs_authenticated_insert'
  ) then
    create policy tg_external_docs_authenticated_insert
      on storage.objects for insert
      to authenticated
      with check (bucket_id = 'external_docs');
  end if;

  if not exists (
    select 1
    from pg_policies
    where schemaname = 'storage'
      and tablename = 'objects'
      and policyname = 'tg_external_docs_authenticated_update'
  ) then
    create policy tg_external_docs_authenticated_update
      on storage.objects for update
      to authenticated
      using (bucket_id = 'external_docs')
      with check (bucket_id = 'external_docs');
  end if;

  if not exists (
    select 1
    from pg_policies
    where schemaname = 'storage'
      and tablename = 'objects'
      and policyname = 'tg_external_docs_authenticated_delete'
  ) then
    create policy tg_external_docs_authenticated_delete
      on storage.objects for delete
      to authenticated
      using (bucket_id = 'external_docs');
  end if;

  if not exists (
    select 1
    from pg_policies
    where schemaname = 'storage'
      and tablename = 'objects'
      and policyname = 'tg_sys_files_public_select'
  ) then
    create policy tg_sys_files_public_select
      on storage.objects for select
      to anon, authenticated
      using (bucket_id = 'sys-files');
  end if;

  if not exists (
    select 1
    from pg_policies
    where schemaname = 'storage'
      and tablename = 'objects'
      and policyname = 'tg_sys_files_authenticated_insert'
  ) then
    create policy tg_sys_files_authenticated_insert
      on storage.objects for insert
      to authenticated
      with check (bucket_id = 'sys-files');
  end if;

  if not exists (
    select 1
    from pg_policies
    where schemaname = 'storage'
      and tablename = 'objects'
      and policyname = 'tg_sys_files_authenticated_update'
  ) then
    create policy tg_sys_files_authenticated_update
      on storage.objects for update
      to authenticated
      using (bucket_id = 'sys-files')
      with check (bucket_id = 'sys-files');
  end if;

  if not exists (
    select 1
    from pg_policies
    where schemaname = 'storage'
      and tablename = 'objects'
      and policyname = 'tg_sys_files_authenticated_delete'
  ) then
    create policy tg_sys_files_authenticated_delete
      on storage.objects for delete
      to authenticated
      using (bucket_id = 'sys-files');
  end if;
end
$$;
