class PagesController < ApplicationController
  def sitemap
    redirect_to 'https://2dots.s3.amazonaws.com/sitemap.xml.gz'
  end

  def sitemap_xml
    redirect_to 'https://2dots.s3.amazonaws.com/sitemap.xml.gz'
  end
end
