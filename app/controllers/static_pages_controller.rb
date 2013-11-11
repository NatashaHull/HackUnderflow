class StaticPagesController < ApplicationController
  def root
    render :root, :layout => "layouts/backbone_application"
  end

  def about
  end
end
