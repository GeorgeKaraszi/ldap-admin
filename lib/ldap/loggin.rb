module LdapAdmin

  class Loggin
    def self.send(message, logger = Rails.logger)
        logger.add 0, "  \e[36mLDAP-Admin:\e[0m #{message}"
    end
  end

end