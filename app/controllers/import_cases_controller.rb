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


        cases = response["results"]
        @results = remove_preexisting_cases(cases)

        render :show
    end

    # def show
    #     binding.remote_pry 
    # end

    private

    def remove_preexisting_cases(cases)
    end

    def import_case_params
        params.require(:import_case).permit(
            :name, :name_abbreviation, :url, :jurisdiction_id, :jurisdiction_name, 
            :docket_number, :decisiondate_original, :court_name, :court_id, :reporter_name, 
            :reporter_id, :volume, :citation, :firstpage, :lastpage
        )
    end
end