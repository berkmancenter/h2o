class CreateImportCase < ActiveRecord::Migration
  def change
    create_table :import_cases do |t|
    	t.string :name
    	t.string :name_abbreviation
    	t.string :url
    	t.integer :jurisdiction_id
    	t.string :jurisdiction_name
    	t.string :docket_number
    	t.string :decisiondate_original
    	t.string :court_name
    	t.integer :court_id
    	t.string :reporter_name
    	t.integer :reporter_id
    	t.integer :volume
    	t.string :citation
    	t.integer :firstpage
    	t.integer :lastpage

    	t.timestamps
    end
  end
end


