policy CREATE POLICY "Enable read access for authenticated users" ON "public"."contacts" FOR
SELECT TO authenticated USING (
    -- Public data access
    (state_code >= 100)
    OR -- Personal data access
    (
      (
        SELECT auth.uid()
      ) = user_id
    )
    OR -- Team member access
    (
      EXISTS (
        SELECT 1
        FROM roles
        WHERE roles.team_id = contacts.team_id
          AND roles.role IN ('admin', 'member', 'owner')
          AND roles.user_id = (
            SELECT auth.uid()
          )
      )
    )
    OR -- Reviewer access
    (
      (state_code = 20)
      AND (
        -- Review admin
        (
          EXISTS (
            SELECT 1
            FROM roles
            WHERE roles.team_id = '00000000-0000-0000-0000-000000000000'::uuid
              AND roles.role = 'review-admin'
              AND roles.user_id = (
                SELECT auth.uid()
              )
          )
        )
        OR -- Assigned reviewer
        (
          EXISTS (
            SELECT 1
            FROM reviews r
            WHERE r.state_code > 0
              AND ((r.json->'data'->>'id'))::uuid = contacts.id
              AND (r.json->'data'->>'version') = contacts.version::text
              AND r.reviewer_id @> jsonb_build_array(
                (
                  SELECT auth.uid()
                )::text
              )
          )
        )
        OR -- Historical reviewer
        (
          EXISTS (
            SELECT 1
            FROM reviews r
            WHERE r.id IN (
                SELECT ((review_item.value->>'id'))::uuid
                FROM jsonb_array_elements(contacts.reviews) review_item(value)
              )
              AND r.reviewer_id @> jsonb_build_array(
                (
                  SELECT auth.uid()
                )::text
              )
          )
        )
      )
    )
  );