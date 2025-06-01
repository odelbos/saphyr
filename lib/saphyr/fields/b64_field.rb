require 'base64'

module Saphyr
  module Fields

    # The +B64+ field type
    #
    # Allowed options is: +:strict+ (boolean)
    #
    # When in strict mode (:strict == true):
    # - Line breaks are not allowed
    # - Padding must be correct
    #
    # Not in strict mode (:strict == false):
    # - Line breaks are allowed
    # - Padding is not required
    class B64Field < FieldBase
      PREFIX = 'b64'
      EXPECTED_TYPES = String

      AUTHORIZED_OPTIONS = [:strict]     # :strict = true / false

      FORMAT_REGEXP = /^(?:[A-Za-z0-9+\/]*[\r\n|\n]*)*(?:[=]{1,2})?$/

      def initialize(opts={})
        if opts[:strict].nil?
          opts[:strict] = true
        else
          unless [true, false].include? opts[:strict]
            raise Saphyr::Error.new "Bad B64 strict option must be a boolean"
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
            if @opts[:strict]
              # NOTE: When in strict mode
              # - Line breaks are not allowed
              # - Padding must be correct (length % 4 == 0)
              # In this case, we use Base64.strict_decode64 because it's a way
              # faster than using regexp. An invalid base64 string will raise an error.
              Base64.strict_decode64 value
            else
              # NOTE: When not in strict mode
              # - Line breaks are allowed (like in PEM or EMAIL)
              # - Padding is not required
              # But, we can't use Base64.decode64 because it will not raise an error
              # for a string like this one : 'not-b54**str'.
              # (and obviously it's not a valid base64 format)
              unless FORMAT_REGEXP.match? value
                add_error value, errors
              end
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
