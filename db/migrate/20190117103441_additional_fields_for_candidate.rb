class AdditionalFieldsForCandidate < ActiveRecord::Migration
  def change
    add_column :candidates, :social_links, :string
  end
end
