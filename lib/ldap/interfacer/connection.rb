require 'net/ldap'

module LdapAdmin
  DEFAULT_OU_GROUP = 'Groups'
  DEFAULT_OU_PEOPLE = 'People'
  class Connection

    #
    #Initialize connection class and bind to the interfacer server
    ##############################################################
    def initialize

      ldap_config = YAML.load(ERB.new(File.read(::Devise.ldap_config ||
                                                    "#{Rails.root}/config/ldap.yml")).result)[Rails.env]


      @ldap = Net::LDAP.new
      @ldap.host = ldap_config['host']
      @ldap.port = ldap_config['port']
      @tree_base  = ldap_config['domain']

      if ldap_config['ssl'] === true
        @ldap.encryption(:simple_tls)
      end

      @ldap.authenticate(ldap_config['admin_user'], ldap_config['admin_password'])

      unless @ldap.bind
        LdapAdmin::Logger.send(@ldap.get_operation_result.code)
        LdapAdmin::Logger.send(@ldap.get_operation_result.message)
        false
      end

    end


    def find_by(params = {})

      if params.blank?
        LdapAdmin::Logger.send('Error in find_by. No parameter provided')
      end

      base = params.include?(:dn) ? params[:dn] : @tree_base
      filter = Net::LDAP::Filter.pres('dn')

      params.except!(:dn).each do|key,value|
        value.each do|v|
          eql = Net::LDAP::Filter.eq("#{key}","#{v}")
          filter = Net::LDAP::Filter.join(filter,eql)
        end
      end

      @ldap.search(:base => base, :filter => filter)

    end

    #
    #Performs a search query with a given DN
    #####################################################
    def find(params = {})
      unless params.include?(:dn)
        LdapAdmin::Logger.send('Error in find. No dn parameter provided')
        return false
      end

      @ldap.search(:base => params[:dn])

    end

    #
    #Find all LDAP Users
    #####################################################
    def find_users(params = {})

      unless params.include?(:uid)
        LdapAdmin::Logger.send('Error in find_users. No uid parameter provided')
        return false
      end

      #Setup base search and organization parameters
      ou = params.include?(:ou) ? params[:ou] : LdapAdmin::DEFAULT_OU_PEOPLE
      base = "ou=#{ou}," + (params.include?(:base)? params[:base] : @tree_base)


      filter = Net::LDAP::Filter.eq('uid', params[:uid])

      @ldap.search(:base => base, :filter => filter)
    end

    #
    #Find group(s) in a given domain
    #####################################################
    def find_groups(params = {})

      unless params.include?(:cn)
        LdapAdmin::Logger.send('Error in find_groups. No CN parameter provided')
        return false
      end

      #Setup base search and organization parameters
      ou = params.include?(:ou) ? params[:ou] : LdapAdmin::DEFAULT_OU_GROUP
      base = "ou=#{ou}," + (params.include?(:base)? params[:base] : @tree_base)

      filter = Net::LDAP::Filter.eq('cn', params[:cn])

      @ldap.search(:base => base, :filter => filter)
    end

    #
    #Find all object hierarchy objects
    #####################################################
    def list_object_classes(params = {})

    end

    #
    #Find all OU objects
    #####################################################
    def find_organization_units(params = {})
      base = params.include?(:base)? params[:base] : @tree_base

      filter = Net::LDAP::Filter.eq('ou', '*')
      @ldap.search(:base => base, :filter => filter).map {|entry| entry.ou}
    end

    #
    #Find all members of a group
    #####################################################
    def find_group_members(params = {})

      unless params.include?(:cn)
        LdapAdmin::Logger.send('Error in find_group_members. No CN parameter provided.')
        return false
      end

      base = params.include?(:base)? params[:base] : @tree_base
      filter = Net::LDAP::Filter.eq('cn', params[:cn])


        user_list = Hash.new

        ldap.search(:base => base, :filter => filter) do |entry|
          if entry.attribute_names.include?(:uniquemember)
            user_list['uniquemember'] = entry.uniquemember
          elsif entry.attribute_names.include?(:memberuid)
            user_list['memberuid'] = entry.memberuid
          end
        end

      user_list
    end


    def user_belongs_to_group(params ={})
      unless params.include?(:uid)

      end
    end

    def find_user_groups(params = {})
      unless params.include?(:dn)
        LdapAdmin::Logger.send('Error in find_groups_user_belongs_to. No dn provided.')
        false
      end

      user = self.find(:dn => params[:dn]).first
      unless user.attribute_names.include?(:gidNumber) || user.attribute_names.include?(:uid)
        LdapAdmin::Logger.send('Error in find_groups_user_belongs_to. Could not locate target user with DN parameter.')
        false
      end

      ou     = params.include?(:ou) ? params.ou : LdapAdmin::DEFAULT_OU_GROUP
      base   = "ou=#{ou}," + (params.include?(:base) ? params.base : @tree_base)
      filter = Net::LDAP::Filter.eq('uniquemember', user.dn) |
               Net::LDAP::Filter.eq('memberuid', user.uid.first) |
               Net::LDAP::Filter.eq('gidnumber', user.gidNumber.first)


      @ldap.search(:base => base, :filter => filter)
    end

  end

end