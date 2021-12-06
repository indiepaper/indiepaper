defmodule IndiePaper.ChapterMembershipTiers.ChapterMembershipTier do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "chapter_membership_tiers" do
    belongs_to :membership_tier, IndiePaper.MembershipTiers.MembershipTier
    belongs_to :chapter, IndiePaper.Chapters.Chapter
  end

  @doc false
  def changeset(chapter_membership_tier, attrs) do
    chapter_membership_tier
    |> cast(attrs, [:chapter_id, :membership_tier_id])
    |> validate_required([:chapter_id, :membership_tier_id])
    |> unique_constraint(:membership_tier_id,
      name: :chapter_membership_tiers_chapter_id_membership_tier_id_index
    )
  end
end
