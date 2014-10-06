class CaseIngestionRequest < ActiveRecord::Base
  validates_presence_of :url, :user_id

  belongs_to :user
  belongs_to :case
  has_one :case_ingestion_log

  after_create :request_delayed_job 

  def public
    true
  end

  def active
    true
  end

  def ingest
    #url parsing code
      #content = parsed stuff
      #short_name = parsed stuff
    
    if Case.new(user_id: User.where(login: 'h2ocases').first.id, short_name: "temp. short name", content: "temp. content").save!
      CaseIngestionRequest.last.update_attributes(:case_id => Case.last.id)
    else
      CaseIngestionLog.create!(case_ingestion_request_id: CaseIngestionRequest.last)      
    end
  end

  def error(ingest, error)
    CaseIngestionLog.create!(case_ingestion_request_id: CaseIngestionRequest.last.id, status: 'new')
    Delayed::Job.find(ingest.id).destroy
  end

  def request_delayed_job
    CaseIngestionRequest.last.delay.ingest
  end
end
