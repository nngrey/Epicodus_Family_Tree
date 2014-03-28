class Person < ActiveRecord::Base
 has_and_belongs_to_many :relationships

  validates :name, :presence => true

  after_save :make_marriage_reciprocal

  def spouse
    if spouse_id.nil?
      nil
    else
      Person.find(spouse_id)
    end
  end

private

  def make_marriage_reciprocal
    if spouse_id_changed?
      spouse.update(:spouse_id => id)
    end
  end
end
