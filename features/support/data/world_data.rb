require 'data/data_collection'
#TODO: Always convert collection to objects and use deep_hash on object to convert to hash when necessary
module WorldData

  def load_data(file, convert=false)
    DataCollection.load_file("#{DATA_DIR}/#{SITE}/" + file , convert)
  end

  def messages
    @messages ||= load_data "messages.yml", true
  end

  def users
    @users ||= load_data 'users.yml'
  end

  def all_locators
    @all_locators ||= load_data "locators.yml", true
  end

end