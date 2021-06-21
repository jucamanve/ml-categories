#! /usr/bin/env ruby

require 'nokogiri'
require 'open-uri'
require 'json'
require 'csv'

# Fetch and parse HTML document
# doc = Nokogiri::HTML(URI.open('https://nokogiri.org/tutorials/installing_nokogiri.html'))
doc = Nokogiri::HTML(URI.open('https://www.mercadolibre.com.ve/categorias'))
path = 'categs.csv'
# Search for nodes by css
# doc.css('nav ul.menu li a', 'article h2').each do |link|
#   puts link.content
# end

# Or mix and match
# doc.search('nav ul.menu li a', '//article//h2').each do |link|
#     puts link.content
# end

# doc.search('categories__title', '//article//h2').each do |link|
#   puts link.content
# end


CSV.open(path, 'w') do |csv|
  containers = doc.css(".categories__container").each do |container|
    row = []
    category = container.children.first.text
    puts category
    row << category
    
    subcategories = container.children.last.css("li a h3").each do |subcategory|
      subcat = subcategory.text
      puts "|-> " + subcat
      row << subcategory.text
    end
    csv << row
    10.times {
      csv << []
    }
  end
end

# categories = doc.css('h2 a').map(&:text)
# File.open("ml-categories.txt", "w") { |file| file << array }

# File.open("ml-categories.txt", "w") { |file| file.write(categories.to_json) }