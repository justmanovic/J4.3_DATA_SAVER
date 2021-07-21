class Departement
  attr_accessor :dpt_url, :dpt_nom
  # @@dpts

  def initialize(nom)
    
  end

  def self.all

  end

  class Mairie
    attr_accessor : 
    @@tab_villes = []
  
    def initialize()
      @
    end
  
    # Fonction qui génère un hash constitué du nom de la commune et de son adresse email à partir de l'URL de la commune
    # def get_townhall_email(townhall_url)
    #   doc = Nokogiri::HTML(URI.open(townhall_url))
    #   email_h = {(doc.xpath("//div/div[1]/h1/small").text.split - ["Commune", "de"]).join=>doc.xpath("//section[2]/div/table/tbody/tr[4]/td[2]").text}
    # end
  
    # Récupération des URL des communes dans un tableau à partir de la liste des communes du département
    def get_townhall_urls(page_liste)
      doc = Nokogiri::HTML(URI.open(page_liste))
      tab_url = []
  
      # On trouve toutes les URL des communes, et on les ajoute dans le tableau créé précedemment, et on remplace le "." par le début de l'URL
      doc.xpath("//tbody/tr/td/p/a/@href").each  {|url| tab_url << url.to_s.sub(/[.]/ , 'http://annuaire-des-mairies.com/')} 
      binding.pry
  
  
      return tab_url
    end
  
    # Combinaison des 2 fonctions : à partir de la page du département, on va récupérer toutes les adresses emails associées
    def get_all_emails(page_dept)
      list_emails = []
      list_pages = []
  
      # On récupère les URL
      list_pages =  get_townhall_urls(page_dept)
  
      # Constitution du tableau de hash
      list_pages.each {|url| list_emails << get_townhall_email(url)}
      return list_emails
    end
  
  end

end