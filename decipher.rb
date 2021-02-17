require 'numbers_in_words'
require 'numbers_in_words/duck_punch'

class Decipher

    attr_accessor :original, :expression, :result

    def initialize(orignal_str)
        @expression = ''
        @original = orignal_str
        @result = nil
    end
    
    def execute
        first_part, operator, last_part = operator_split(@original)
        first_part = check_and_cut_negative(first_part)
        @expression += first_part.in_numbers.to_s
        @expression += check_middle_operator(operator)
        last_part = check_and_cut_negative(last_part)
        @expression += last_part.in_numbers.to_s

        @result = eval(@expression)

        return @result
    end

    def check_and_cut_negative(str)
        operator = check_nagative(str)
        unless operator.empty?
            @expression += operator
            str = cut_negative(str)
        end
        return str
    end

    def check_negative(str)
        operator = ''
        operator = "=" if str.match?(/^negative/)
        return operator
    end

    def cut_negative(str)
        return str.sub(/^negative/, "")
    end

    def operator_split(str)
        split = str.split(/\s+(plus|minus|times|divided by)\s+/,3)
        return split
    end

    def check_middle_operator(str)
        operator = nil
        if str.match?(/plus/)
            operator='+'
        elsif str.match?(/minus/)
            operator='-'
        elsif str.match?(/times/)
            operator='*'
        elsif str.match?(/divided by/)
            operator='/'
        else
            return nil
        end
        
        return operator
    end
end
