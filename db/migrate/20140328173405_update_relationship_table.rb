class UpdateRelationshipTable < ActiveRecord::Migration
  def change
    rename_column :relationships, :type, :relationship_type
    rename_column :relationships, :mother_id, :person1_id
    rename_column :relationships, :father_id, :person2_id
  end
end
