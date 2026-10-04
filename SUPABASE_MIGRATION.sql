-- New.Cup 2 — Team Name + Registration RPC
-- Run once in Supabase SQL Editor if the 4-argument RPC has not already been created.

ALTER TABLE public.tournament_registrations
ADD COLUMN IF NOT EXISTS team_name text;

DROP FUNCTION IF EXISTS public.submit_tournament_registration(text,text,text);

CREATE OR REPLACE FUNCTION public.submit_tournament_registration(
  p_team_name text,
  p_player1 text,
  p_player2 text,
  p_contact text
)
RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  new_id uuid;
BEGIN
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'ابتدا وارد حساب کاربری شو';
  END IF;

  IF trim(coalesce(p_team_name, '')) = '' THEN
    RAISE EXCEPTION 'نام تیم را وارد کنید';
  END IF;

  INSERT INTO public.tournament_registrations
    (user_id, team_name, player1, player2, contact, status)
  VALUES
    (auth.uid(), trim(p_team_name), p_player1, p_player2, p_contact, 'pending')
  RETURNING id INTO new_id;

  RETURN json_build_object('id', new_id);
END;
$$;

REVOKE ALL ON FUNCTION public.submit_tournament_registration(text,text,text,text) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.submit_tournament_registration(text,text,text,text) TO authenticated;

DROP FUNCTION IF EXISTS public.get_my_tournament_registration();

CREATE OR REPLACE FUNCTION public.get_my_tournament_registration()
RETURNS TABLE (
  team_name text,
  player1 text,
  player2 text,
  contact text,
  status text,
  admin_note text,
  created_at timestamptz
)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT r.team_name, r.player1, r.player2, r.contact, r.status, r.admin_note, r.created_at
  FROM public.tournament_registrations r
  WHERE r.user_id = auth.uid()
  ORDER BY r.created_at DESC
  LIMIT 1;
$$;

REVOKE ALL ON FUNCTION public.get_my_tournament_registration() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_my_tournament_registration() TO authenticated;
