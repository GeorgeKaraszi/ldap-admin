module LdapAdmin
  module Entry
    class Parser

      def initialize
        @entryObject = Hash.new



      end

      def parse(entry)

        unless entry.nil? && entry.has_key?(:dn)
          LdapAdmin::Logger.send('Error parsing empty entry object')
          return false
        end

        dn_split = entry.dn.split(',')
        dn_split.each do |str|

          unless str.include? 'dc'
            @entryObject['dc'].push str
            next
          end
          split_obj = str.split('=')
          @entryObject[split_obj[0]] = split_obj[1]


        end

        entry.each do|attribute,value|
          @entryObject[attribute].push value
        end


        @entryObject

      end

    end
  end
end