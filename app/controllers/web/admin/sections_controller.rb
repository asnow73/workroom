class Web::Admin::SectionsController < ApplicationController
  def index
    @q = Section.ransack params[:q]
    @sections = @q.result.order('created_at DESC').page(params[:page])
  end

  def new
    @section = Section.new
  end

  def create
    @section = Section.new(section_params)
    if @section.save
      flash[:success] = "Раздел создан"
      redirect_to admin_sections_url
    else
      render 'new'
    end
  end

  def destroy
    Section.find(params[:id]).destroy
    flash[:success] = "Раздел удален"
    redirect_to admin_sections_url
  end

  def edit
    @section = Section.find(params[:id])
  end

  def update
    @section = Section.find(params[:id])
    if @section.update_attributes(section_params)
      flash[:success] = "Раздел обновлён"
      redirect_to admin_sections_url
    else
      render 'edit'
    end
  end

  private
    def section_params
      params.require(:section).permit(:name)
    end
end
