module Saphyr
  module Fields

    # The +IP+ field type
    #
    # Allowed options is: +:kind in (:any, :ipv4, :ipv6)+
    #
    # - +:any+ : can be an ipv4 or ipv6 (default)
    # - +:ipv4+ : must be an ipv4
    # - +:ipv6+ : must be an ipv6
    class IpField < FieldBase
      PREFIX = 'ip'
      EXPECTED_TYPES = String
      AUTHORIZED_OPTIONS = [:kind]

      def initialize(opts={})
        if opts[:kind].nil?
          opts[:kind] = :any
        else
          unless [:any, :ipv4, :ipv6].include? opts[:kind]
            raise Saphyr::Error.new 'Bad IP kind option must be one of :any, :ipv4, :ipv6'
          end
        end
        super opts
      end

      private

        def do_validate(ctx, name, value, errors)
          if value.empty?
            add_error value, errors
            return
          end

          begin
            ip = IPAddr.new value
            if @opts[:kind] == :ipv4 and not ip.ipv4?
              add_error value, errors
            elsif @opts[:kind] == :ipv6 and not ip.ipv6?
              add_error value, errors
            end
          rescue
            add_error value, errors
          end
        end

        def add_error(value, errors)
          errors << {
            type: err('invalid'),
            data: {
              _val: value
            }
          }
        end
    end
  end
end
