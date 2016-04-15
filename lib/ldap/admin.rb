module LdapAdmin
  module Administration

   def self.get_connection
    return LdapAdmin::Connection.new
   end

    def self.get_user(params={})
      return self.get_connection.find_users(params)
    end

   def self.get_group(params={})
#     return self.get_connection.find_group(params)
   end

   def self.get_all_users(params={})
     user_options = params
     user_options[:uid] = '*'

     return self.get_connection.find_users(user_options)
   end

   def self.get_all_groups(params={})
     group_options = params
     group_options[:gid] = '*'

     return self.get_connection.find_groups(group_options)
   end

   def self.get_organization_units(params={})
     return self.get_connection.find_organization_units(params)
   end

    def self.get_group_membership(params={})
      return self.get_connection
    end

  end
end
