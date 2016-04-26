class AboutController < ApplicationController
  def show
    render template: "about/about.html.erb"
  end
end
