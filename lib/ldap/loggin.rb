module LdapAdmin

  class Logger
    def self.send(message, logger = Rails.logger)
      if ::Devise.ldap_logger
        logger.add 0, "  \e[36mLDAP-Admin:\e[0m #{message}"
      end
    end
  end

end