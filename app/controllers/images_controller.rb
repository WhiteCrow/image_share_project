class ImagesController < ApplicationController

  before_action :require_user
  before_action :set_image, only: [:remove, :unremove, :destroy, :share, :effect, :versions]

  def create
    @image = Image.new image_params.merge(version: 1)
    @image.save!
    @image.update!(origin_image_id: @image.id)

    redirect_to root_path
  end

  def remove
    @image.remove
    redirect_to root_path
  end

  def unremove
    @image.unremove
    redirect_to root_path
  end

  def removed
    @images = Image.unscoped.where(user_id: current_user.id, removed: true).last_version
  end

  def versions
    @images = Image.unscoped.where(origin_image_id: @image.origin_image_id)
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

  def effect
    @image.create_version(params[:filter])
    redirect_to root_path
  end

  def destroy
    @image.full_destroy
    redirect_to removed_images_path
  end

  private

  def set_image
    @image = Image.unscoped.where(user_id: current_user.id).find(params[:id])
  end

  def image_params
    params.require(:image).permit(:avatar, :avatar_cache).merge(user_id: current_user.id)
  end

end
