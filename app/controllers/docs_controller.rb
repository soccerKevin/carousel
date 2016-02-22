class DocsController < ApplicationController
  def index
    render (page ? "docs/#{page}.html" : "docs/index.html")
  end

  def class_name
    render "docs/class/#{page.capitalize}.html"
  end

  def page
    page = params[:page].capitalize
  end
end
