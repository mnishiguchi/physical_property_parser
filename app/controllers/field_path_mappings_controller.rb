class FieldPathMappingsController < ApplicationController
  before_action :set_field_path_mapping, only: [:show, :edit, :update]

  # GET /field_path_mappings/1
  def show
  end

  # GET /field_path_mappings/1/edit
  def edit
    @scroll = params[:scroll]
  end

  # PATCH/PUT /field_path_mappings/1
  def update
    if @field_path_mapping.update(field_path_mapping_params)
      flash[:success] = 'Field path mapping was successfully updated.'
      scroll = params[:field_path_mapping][:scroll]
      redirect_to edit_field_path_mapping_path(scroll: scroll)
    else
      render :edit
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_field_path_mapping
      @field_path_mapping = FieldPathMapping.includes(:feed_source).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def field_path_mapping_params
      permit = @field_path_mapping.field_attributes.keys
      permit << :scroll
      params.require(:field_path_mapping).permit(*permit)
    end
end
