require "csv"

# NOTE: We need to require 'csv' in `config/application.rb`.
module CsvHelper

  class Base
    def initialize(model, controller)
      @model       = model
      @controller  = controller
      @view        = controller.view_context
      send_csv
    end

    private def send_csv
      @controller.send_data(render_csv, headers)
    end

    # Default headers.
    # http://api.rubyonrails.org/classes/ActionDispatch/Request.html#method-i-headers
    private def headers
      {
        type:        "application/csv",
        filename:    "#{@model.model_name.singular}-#{@model.id}-#{Date.today}.csv",
        disposition: "attachment"
      }
    end
  end

  class SendFeedSourceCsv < Base

    private def headers
      super.merge(
        filename: "#{@model.model_name.singular}-#{@model.url}-#{Date.today}.csv"
      )
    end

    private def render_csv
      feed_source = @model

      # Set options if needed (e.g. :col_sep, :headers, etc)
      # http://ruby-doc.org/stdlib-2.0.0/libdoc/csv/rdoc/CSV.html#DEFAULT_OPTIONS
      options = { headers: true }

      field_path_mapping_hash = feed_source.field_path_mapping.field_attributes

      output = CSV.generate(options) do |csv|
        csv << ["Source URL", feed_source.url]
        csv << ["Last updated", feed_source.updated_at]
        csv << [""]
        csv << ["---"]
        csv << ["Field-path mapping that is currently set"]
        csv << ["---"]
        csv << ["Field name", "Xpath"]

        field_path_mapping_hash.each do |field, xpath|
          csv << [field, xpath]
        end

        csv << [""]
        csv << ["---"]
        csv << ["All the xpath of this feed schema"]
        csv << ["---"]
        feed_source.xpaths.each do |xpath|
          csv << [xpath]
        end
      end

      output
    end
  end
end
