module LdapAdmin
  module Administration
   def get_connection
    resource = LdapAdmin::Connection.new
   end

    def self.get_user(params={})
      get_connection.find_users(params)
    end

   def self.get_group(params={})
     get_connection.find_group(params)
   end

   def get_all_users(params={})
     user_options = params
     user_options[:uid] = '*'

     get_connection.find_users(user_options)
   end

   def get_all_groups(params={})
     group_options = params
     group_options[:gid] = '*'

     get_connection.find_groups(group_options)
   end

   def self.get_organization_units(params={})
     get_connection.find_organization_units(params)
   end

    def self.get_group_membership(params={})
      get_connection
    end

  end
end