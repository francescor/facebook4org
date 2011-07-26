class AddTestingOrganisations < ActiveRecord::Migration
  def self.up
    #Organisation.delete_all
    #    Organisation.create(:name => "", :homepage =>"",:city => "", :country_id =>"")
#    Organisation.create(:name => "Changing Room developers",
#                        :short_name => "Admins",
#                        :homepage => "www.teh.net",
#                        :city => "Lund",
#                        :post_code => "22223",
#                        :country =>"Sweden")
    Organisation.create(:name => "Trans Europe Halles",
                        :short_name => "TEH",
                        :homepage =>"www.teh.net",
                        :city => "Lund",
                        :street => "Stora Södergatan 64",
                        :post_code => "22223",
                        :country =>"Sweden")
    Organisation.create(:name => "Oficina di Buenaventura",
                        :short_name => "Buenaventura",
                        :homepage =>"www.buenaventura.it",
                        :city => "Castelfranco Veneto",
                        :street => "Via Circonvallazione Ovest, 23",
                        :state => "Veneto",
                        :post_code => "31033",
                        :country =>"Italy")
    Organisation.create(:name => "Melkweg",
                        :short_name => "Melkweg",
                        :homepage =>"www.melkweg.nl",
                        :city => "Amsterdam",
                        :street => "Lijnbaansgracht 234a",
                        :post_code => "1017 PH",
                        :country =>"Netherlands")
  end

  def self.down
    Organisation.delete_all
  end
end
