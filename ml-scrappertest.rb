#! /usr/bin/env ruby

require 'nokogiri'
require 'open-uri'

# Fetch and parse HTML document from web
# doc = Nokogiri::HTML(URI.open('https://www.mercadolibre.com.ve/categorias'))

# Read local HTML document of MercadoLibre categories
doc = Nokogiri::HTML(File.read('Categorías y Secciones en Mercado Libre.html'))

# Categories Level
cats_containers = doc.css(".categories__container").each do |cat_container|
  category = cat_container.children.first.text
  puts category

  # First subcategories level
  subcat_1_containers = cat_container.children.last.css("li a").each do |subcat_1_container|
    subcat_1 = subcat_1_container.children.first.text
    puts "|-> #{subcat_1}"

    # Second subcategories level
    subcat_1_doc = Nokogiri::HTML(URI.open(subcat_1_container.attributes["href"].value))
    # Possible Cases
    # Modal
    subcats_2_containers = subcat_1_doc.xpath('//*[@aria-label="Categorías"]')
    subcats_2_containers.each do |subcat_2_container|
       puts "|   |-> #{subcat_2_container.children[0].text}"
    end

    # Left Menu
    subcats_2_containers = subcat_1_doc.xpath('//*[@id="root-app"]/div/div/aside/section/dl[2]/dd/a')
    subcats_2_containers.each do |subcat_2_container|
      #  puts "|   |-> #{subcat_2_container.xpath('//elements[@aria-label]').size}"
       puts "|   |-> #{subcat_2_container.children[0].text}"
    end
  end
end


# cats_container = doc.xpath('//elements[@aria-label="Categorías"]').size
# cats_container.xpath("//elements[@aria-name").text

