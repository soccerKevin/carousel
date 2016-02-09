class DocsController < ApplicationController
  def index
    page = params[:page]
    render "docs/app/assets/javascripts/#{page}.coffee.html"
  end
end
