require 'pry'

class Departement
  attr_accessor :dpt_url, :dpt_nom, :dpt_towns, :townhall_urls_tab
  # @@dpts

  def initialize(name_to_save, url_to_save)
    @dpt_url = url_to_save
    @dpt_nom = name_to_save
    @dpt_towns = []
    @townhall_urls_tab = get_townhall_urls(@dpt_url))
  end

  def get_townhall_urls(page_list)
    # doc.xpath.each do |ville|
    #   Mairie.new(self, ville.text, tbd@email.com, ville@href)
    # end
    
  end

  def get_townhall_urls(page_liste)
    doc = Nokogiri::HTML(URI.open(page_liste))
    tab_url = []

    # On trouve toutes les URL des communes, et on les ajoute dans le tableau créé précedemment, et on remplace le "." par le début de l'URL
    doc.xpath("//tbody/tr/td/p/a/@href").each  {|url| tab_url << url.to_s.sub(/[.]/ , 'http://annuaire-des-mairies.com/')} 
    binding.pry
    return tab_url
  end


end

class Mairie
  attr_accessor :parent_dpt, :nom_ville , :email , :town_url
  @@tab_villes = []

  def initialize(dpt_to_save, ville_to_save, url_to_save, email_to_save)
    @parent_dpt = dpt_to_save
    @nom_ville = ville_to_save
    @town_url = url_to_save
    @email = email_to_save
    @parent_dpt.dpt_towns << self 
  end

  def get_townhall_email(townhall_url)
      doc = Nokogiri::HTML(URI.open(townhall_url))
      email_h = {(doc.xpath("//div/div[1]/h1/small").text.split - ["Commune", "de"]).join=>doc.xpath("//section[2]/div/table/tbody/tr[4]/td[2]").text}
  end


  Object#const_missing

end

binding.pry