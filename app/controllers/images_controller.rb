class ImagesController < ApplicationController

  before_action :require_user
  before_action :set_image, only: [:remove, :unremove, :destroy, :share]

  def create
    @image = Image.new image_params.merge(version: 1)
    @image.save!

    redirect_to root_path
  end

  def remove
    @image.update!(removed: true)
    redirect_to root_path
  end

  def unremove
    @image.update!(removed: false)
    redirect_to root_path
  end

  def removed
    @images = Image.unscoped.where(user_id: current_user.id, removed: true)
  end

  def share
    user_id = params[:shared_user_id].to_i
    if @image.shared? user_id
      @image.share_images.find_by_shared_user_id(user_id).destroy!
    else
      @image.share_images.create!(shared_user_id: user_id)
    end
    redirect_to root_path
  end

  def destroy
    @image.destroy
    redirect_to removed_images_path
  end

  private

  def set_image
    @image = Image.unscoped.where(user_id: current_user.id).find(params[:id])
  end

  def image_params
    params.require(:image).permit(:avatar).merge(user_id: current_user.id)
  end

end
