module Saphyr
  module Helpers
    class Format
      class << self
        def errors_to_text errors
          errors.each do |error|
            type = error[:type]
            puts "path: #{error[:path]}"
            errs = error[:errors]
            errs.each do |err|
              puts "  - type: #{err[:type]}"
              puts "  - data: #{err[:data].to_s}"
              puts "  - msg: #{make_msg err}"
            end
            puts ''
          end
        end

        def make_msg(err)
          type = err[:type]
          data = err[:data]

          # ------------------------------------
          # BASE
          # ------------------------------------
          # eq
          if type.end_with? 'eq'
            return "Expecting value to be equals to: #{data[:eq]}, got: #{data[:_val]}"
          end
          # class
          if type.end_with? 'type'
            return "Expecting type '#{data[:type]}', got: #{data[:got]}"
          end
          # in
          if type.end_with? 'in'
            return "Expecting value to be in: #{data[:in].to_s}, got: #{data[:_val]}"
          end

          # ------------------------------------
          # Numeric
          # ------------------------------------
          # gt
          if type.end_with? 'gt'
            return "Expecting value to be > #{data[:gt]}, got: #{data[:_val]}"
          end
          # gte
          if type.end_with? 'gte'
            return "Expecting value to be >= #{data[:gte]}, got: #{data[:_val]}"
          end
          # lt
          if type.end_with? 'lt'
            return "Expecting value to be < #{data[:lt]}, got: #{data[:_val]}"
          end
          # lte
          if type.end_with? 'lte'
            return "Expecting value to be <= #{data[:lte]}, got: #{data[:_val]}"
          end

          # ------------------------------------
          # Size
          # ------------------------------------
          # len
          if type.end_with? 'len'
            return "Expecting size to be equals to: #{data[:len]}, got: #{data[:_val].size}"
          end
          # min
          if type.end_with? 'min'
            return "Expecting size to be >= #{data[:min]}, got: #{data[:_val].size}"
          end
          # max
          if type.end_with? 'max'
            return "Expecting size to be <= #{data[:max]}, got: #{data[:_val].size}"
          end

          # ------------------------------------
          # String
          # ------------------------------------
          # regexp
          if type.end_with? 'regexp'
            return "Value failed to match regexp: #{data[:regexp].to_s}, got: #{data[:_val]}"
          end

          # ------------------------------------
          # Strict mode
          # ------------------------------------
          if type.end_with? 'missing_in_data'
            return 'Missing fields in data'
          end

          if type.end_with? 'missing_in_schema'
            return 'Missing fields in schema'
          end

          # ------------------------------------
          # Conditional fields
          # ------------------------------------
          if type.end_with? 'conditional:not-allowed'
            return 'Conditional field not allowed'
          end

          # ------------------------------------
          # Not Empty
          # ------------------------------------
          if type.end_with? 'not-empty'
            return 'Cannot be empty'
          end

          # ------------------------------------
          # Not Nullable
          # ------------------------------------
          if type == 'not-nullable'
            return 'Not nullable'
          end

          # ------------------------------------
          # Common
          # ------------------------------------
          # invalid
          if type.end_with? 'invalid'
            return "Invalid format, got: '#{data[:_val]}'"
          end

          'unknown'
        end
      end
    end
  end
end
