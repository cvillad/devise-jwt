class AddSlugToNotes < ActiveRecord::Migration[6.1]
  def change
    add_column :notes, :slug, :string
  end
end
