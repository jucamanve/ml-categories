#! /usr/bin/env ruby

require 'nokogiri'
require 'open-uri'
require 'json'
require 'csv'

# Fetch and parse HTML document
doc = Nokogiri::HTML(URI.open('https://www.mercadolibre.com.ve/categorias'))
file_path = 'categs.csv'

# File.open("ml-categories.txt", "w") { |file| file.write(categories.to_json) }
CSV.open(file_path, 'w') do |csv|
  containers = doc.css(".categories__container").each do |container|
    row = []
    category = container.children.first.text
    puts category
    row << category
    
    subcategories = container.children.last.css("li a").each do |subcategory|
      subcat = subcategory.children.first.text
      puts "|-> #{subcat}"
      row << subcat

      subcat_doc = Nokogiri::HTML(URI.open(subcategory.attributes["href"].value))

      # subcats_containers = subcat_doc.css('//*[@id="modal"]/div[2]/a').each do |subcats_container|
      subcats_containers = subcat_doc.xpath('//*[@id="root-app"]/div/div/aside/section/dl[2]/dd').each do |subcats_container|
        puts "|   |-> #{subcats_container.children.first.children.first.text}"
      end
    end
    csv << row
    10.times {
      csv << []
    }
  end
end


# doc = Nokogiri::HTML(URI.open('https://nokogiri.org/tutorials/installing_nokogiri.html'))

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

# categories = doc.css('h2 a').map(&:text)
# File.open("ml-categories.txt", "w") { |file| file << array }


# https://ruby-doc.org/core-3.0.1/doc/csv/recipes/generating_rdoc.html#label-Recipe-3A+Generate+to+File+with+Headers