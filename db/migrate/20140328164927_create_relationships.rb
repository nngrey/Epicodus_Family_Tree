class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.column :type, :string
      t.column :mother_id, :integer
      t.column :father_id, :integer

      t.timestamps
    end
  end
end
