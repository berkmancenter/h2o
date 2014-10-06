class CreateCaseIngestionLogs < ActiveRecord::Migration
  def change
    create_table :case_ingestion_logs do |t|
      t.references :case_ingestion_request
      t.string :status
      t.text :content
      t.timestamps
    end
  end
end
