class CaseSearchController < BaseController
    def new
    end

    def create
        variables = {}
        CaseSearch::CASE_FIELDS.each do |field|
            if import_case_params[field].present?
                variables[field] = import_case_params[field]
            end
        end

        response = HTTParty.get("https://capapi.org/api/v1/cases/?#{variables.to_query}&format=json")
        @cases = response["results"]

        @cases.each do |kase|
            if Case.where(short_name: kase["name_abbreviation"], case_jurisdiction_id: kase["jurisdiction_id"], decision_date: kase["decisiondate_original"]).exists?
                kase["downloaded"] = true
            else
                kase["downloaded"] = false
            end
        end

        render :show
    end

    private

    def preexisting?
    end

    def import_case_params
        params.require(:case_search).permit(
            :name, :name_abbreviation, :url, :jurisdiction_id, :jurisdiction_name, 
            :docket_number, :decisiondate_original, :court_name, :court_id, :reporter_name, 
            :reporter_id, :volume, :citation, :firstpage, :lastpage
        )
    end
end