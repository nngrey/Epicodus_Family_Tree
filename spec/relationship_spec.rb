require 'spec_helper'

describe Relationship do
  it {should have_and_belong_to_many :people}
end
