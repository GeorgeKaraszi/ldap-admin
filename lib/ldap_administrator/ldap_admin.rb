require "net/ldap"

module LdapAdmin
  class Administrator
    def initialize

      ldap_config = YAML.load(ERB.new(File.read(::Devise.ldap_config ||
                                                    "#{Rails.root}/config/ldap.yml")).result)[Rails.env]


      @ldap = Net::LDAP.new
      @ldap.host = ldap_config["host"]
      @ldap.port = ldap_config["port"]

      if ldap_config["ssl"] === true
        @ldap.encryption(:simple_tls)
      end

      @ldap.authenticate(ldap_config["admin_user"], ldap_config["admin_password"])

      unless @ldap.bind
        LdapAdmin::Logger.send(@ldap.get_operation_result.code)
        LdapAdmin::Logger.send(@ldap.get_operation_result.message)
        false
      end

    end

    def findUser(params = {})

    end

    def findGroup(params = {})
    end

    

  end
end