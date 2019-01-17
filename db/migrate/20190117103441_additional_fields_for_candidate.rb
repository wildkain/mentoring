class AdditionalFieldsForCandidate < ActiveRecord::Migration
  def change
    add_column :candidates, :social_links, :string
    add_column :candidates, :prefered_child_type, :string
  end
end
