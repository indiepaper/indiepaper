defmodule IndiePaper.ChapterMembershipTiers do
  import Ecto.Query
  alias IndiePaper.Repo

  alias IndiePaper.ChapterMembershipTiers.ChapterMembershipTier
  alias IndiePaper.Chapters

  def list_membership_tiers(chapter_id) do
    from(cm in ChapterMembershipTier, where: cm.chapter_id == ^chapter_id)
    |> Repo.all()
  end

  def new_chapter_membership_tier(attrs \\ %{}) do
    %ChapterMembershipTier{}
    |> ChapterMembershipTier.changeset(attrs)
  end

  def build_insert_all_chapter_membership_tiers(
        %Chapters.Chapter{id: chapter_id},
        membership_tier_ids
      ) do
    Enum.map(membership_tier_ids, fn membership_tier_id ->
      %{
        chapter_id: chapter_id,
        membership_tier_id: membership_tier_id
      }
    end)
  end
end
