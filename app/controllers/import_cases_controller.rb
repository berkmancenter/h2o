class ImportCasesController < BaseController
    def new
        @importCase = ImportCase.new
    end

    def create
        @importCase = ImportCase.new(import_case_params)

        importCaseColumnNames = ImportCase.columns.map(&:name)

        variables = {}
        importCaseColumnNames.each do |variable| 
            if @importCase[variable].present?
                variables[variable] = @importCase[variable]
            end
        end

        response = HTTParty.get("https://capapi.org/api/v1/cases/?#{variables.to_query}&format=json")


        @results = response["results"]

        render :show
    end

    private

    def import_case_params
        params.require(:import_case).permit(
            :name, :name_abbreviation, :url, :jurisdiction_id, :jurisdiction_name, 
            :docket_number, :decisiondate_original, :court_name, :court_id, :reporter_name, 
            :reporter_id, :volume, :citation, :firstpage, :lastpage
        )
    end
end