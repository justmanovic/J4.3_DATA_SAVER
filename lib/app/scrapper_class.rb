require 'pry'
require 'open-uri'
require 'nokogiri'
require 'json'
require 'csv'
require 'google_drive'

class Departement
  attr_accessor :emails_list, :dpt_name
  # @@dpts

  def initialize(name_to_save, url_to_scrap)
    @dpt_name = name_to_save
    @emails_list = self.get_all_emails(url_to_scrap)
  end  
  
  # Récupération des URL des communes dans un tableau à partir de la liste des communes du département
  def get_townhall_urls(page_liste)
    doc = Nokogiri::HTML(URI.open(page_liste))
    tab_url = []

    # On trouve toutes les URL des communes, et on les ajoute dans le tableau créé précedemment, et on remplace le "." par le début de l'URL
    doc.xpath("//tr/td/p/a/@href").each  {|url| tab_url << url.to_s.sub(/[.]/ , 'http://annuaire-des-mairies.com/')} 
    return tab_url
  end

  def get_townhall_email(town_url)
      doc = Nokogiri::HTML(URI.open(town_url))
      email_h = {(doc.xpath("//div/div[1]/h1/small").text.split - ["Commune", "de"]).join => doc.xpath("//section[2]/div/table/tbody/tr[4]/td[2]").text}
  end
  
  # Combinaison des 2 fonctions : à partir de la page du département, on va récupérer toutes les adresses emails associées
  def get_all_emails(page_dept)
    list_emails = []
    list_pages = []

    # On récupère les URL
    list_pages =  self.get_townhall_urls(page_dept)

    # Constitution du tableau de hash
    list_pages.each {|url| list_emails << self.get_townhall_email(url)}
    return list_emails
  end

  def save_as_JSON
    # emails_json = File.new("../../db/json_emails.json","w")
    emails_json = File.open("db/json_emails.json","w")
    
    self.emails_list.each do |hash|
      emails_json.write(hash)
      emails_json.write("\n")
    end

    emails_json.close
  end

#   # To a file
# CSV.open("path/to/file.csv", "wb") do |csv|
#   csv << ["row", "of", "CSV", "data"]
#   csv << ["another", "row"]
#   # ...
# end

# # To a String
# csv_string = CSV.generate do |csv|
#   csv << ["row", "of", "CSV", "data"]
#   csv << ["another", "row"]
#   # ...
# end

  def save_as_spreadsheet
    
    session = GoogleDrive::Session.from_config("config.json")
    ws = session.spreadsheet_by_key("1wZB_dmA6LcSuo-LboqlNKfLwRYpK7szJFOXkQsAVyno").worksheets[0]

    # https://docs.google.com/spreadsheets/d/1wZB_dmA6LcSuo-LboqlNKfLwRYpK7szJFOXkQsAVyno/edit?usp=sharing    
    i =1
    self.emails_list.each do |hash|
      ws[i, 1] = hash
      i += 1
    end
    ws.save  

  end

  def save_as_csv
    csv_var = CSV.open("db/file.csv", "w") do |csv|
      self.emails_list.each do |hash|
        csv << [hash]
      end
      # csv << self.emails_list
    end

  end

end

# binding.pry

# ID client
# 344725590173-cpb44am7fljn5vg6tvcfc7u83ntl1l07.apps.googleusercontent.com

# code secret : qECH0_lM-KvXjugaOZpIXrdI