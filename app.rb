require 'bundler'
Bundler.require

require_relative 'lib/app/scrapper_class'


oise_var = Departement.new("Oise","http://annuaire-des-mairies.com/val-d-oise.html")
# oise_var.save_as_JSON
# oise_var.save_as_csv
oise_var.save_as_spreadsheet


# liste_emails = oise_var.emails_list