class ImagesController < ApplicationController

  before_action :require_user

  def create
    @image = Image.new image_params.merge(version: 1)
    @image.save!

    redirect_to root_path
  end

  private

  def set_image
    @image = image.find(params[:id])
  end

  def image_params
    params.require(:image).permit(:avatar).merge(user_id: current_user.id)
  end

end
