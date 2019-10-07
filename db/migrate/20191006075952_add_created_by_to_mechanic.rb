class AddCreatedByToMechanic < ActiveRecord::Migration
  def change
    add_reference :mechanics, :created_by, class:'User' ,index: true
  end
end
