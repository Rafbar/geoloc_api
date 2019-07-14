class AddWorkflowStateToGeoLocation < ActiveRecord::Migration[5.2]
  def change
    add_column :geo_locations, :workflow_state, :string
    add_index :geo_locations, :workflow_state
  end
end
