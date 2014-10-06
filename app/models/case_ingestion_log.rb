class CaseIngestionLog < ActiveRecord::Base
  belongs_to :case_ingestion_request
end
