class PeopleRelationships < ActiveRecord::Migration
  def change
    create_table :people_relationships do |t|
      t.belongs_to :person
      t.belongs_to :relationship
    end
  end
end
