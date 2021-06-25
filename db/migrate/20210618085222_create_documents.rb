class CreateDocuments < ActiveRecord::Migration[6.1]
  def change
    create_table :documents do |t|
      t.integer :document_id
      t.string :document_name
      t.string :project_name
      t.string :pm_standard
      t.string :document_type
      t.string :process_step
      t.string :document_version
      t.datetime :document_timestamp
      t.jsonb :j_document, null: false, default: '{}'

      t.timestamps
      end

      add_index :documents, :document_name
    end
end
