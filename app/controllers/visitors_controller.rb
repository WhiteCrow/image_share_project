class VisitorsController < ApplicationController
  def index
    if current_user
      @image = Image.new
    end
  end
end
