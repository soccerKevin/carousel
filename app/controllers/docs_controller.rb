class DocsController < ApplicationController
  def index
    page = params[:page]
    render (page ? "docs/#{page}.html" : "docs/index.html")
  end

  def class_name
    render "docs/class/#{params[:page]}.html"
  end
end
