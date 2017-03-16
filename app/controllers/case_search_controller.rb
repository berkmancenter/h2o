class CaseSearchController < BaseController
    def new
    end

    def create

        puts params
        puts "*****"
        puts "*****"
        puts "*****"

        # @importCase = ImportCase.new(import_case_params)

        # results = 

        # importCaseColumnNames = ImportCase.columns.map(&:name)

        # variables = {}
        # importCaseColumnNames.each do |variable| 
        #     if @importCase[variable].present?
        #         variables[variable] = @importCase[variable]
        #     end
        # end

        # response = HTTParty.get("https://capapi.org/api/v1/cases/?#{variables.to_query}&format=json")


        # @results = response["results"]

        render :show
    end

    private

    def import_case_params
        params.require(:case_search).permit(
            :name, :name_abbreviation, :url, :jurisdiction_id, :jurisdiction_name, 
            :docket_number, :decisiondate_original, :court_name, :court_id, :reporter_name, 
            :reporter_id, :volume, :citation, :firstpage, :lastpage
        )
    end
end