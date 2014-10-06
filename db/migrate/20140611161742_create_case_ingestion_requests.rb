class CreateCaseIngestionRequests < ActiveRecord::Migration
  def change
    create_table :case_ingestion_requests do |t|
      t.string :url, :null => false
      t.references :user, :null => false
      t.references :case

      t.timestamps
    end
  end
end
