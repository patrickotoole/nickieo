

require 'openid/store/filesystem'
Rails.application.config.middleware.use OmniAuth::Builder do  
  provider :twitter, 'kYUNxwOF7U42neZPy6BarA', 'xkrWBAykTgO2TyckfMHSwpDOeCjmt0MjHuKW1sw'  
#  provider :google, 'nickieotoole.com', 'OT1fVH0pwPsUK8aR/jWLkVHt'
  provider :open_id, OpenID::Store::Filesystem.new('/tmp'), :name => 'yahoo', :identifier => 'yahoo.com' 
  provider :open_id, OpenID::Store::Filesystem.new('/tmp'), :name => 'google', :identifier => 'gmail.com'
#  provider :facebook, 'APP_ID', 'APP_SECRET'  
#  provider :linked_in, 'CONSUMER_KEY', 'CONSUMER_SECRET'  
end