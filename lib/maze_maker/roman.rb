module MazeMaker


  class Roman
    def self.to_roman(arabic)
      roman = ''
      roman_map = {  1000 => "M", 900 => "CM", 500 => "D", 400 => "CD", 100 => "C", 90 => "XC", 50 => "L", 40 => "XL", 10 => "X", 9 => "IX", 5 => "V", 4 => "IV", 1 => "I"}
      raise ArgumentError unless arabic.is_a?(Numeric) and arabic < 4000
      # Sort the keys, highest value (1000) first, then descending,
      # and parse values
      roman_map.keys.sort{ |a,b| b <=> a }.each do |n|
        while arabic >= n do
          arabic = arabic-n
          roman += roman_map[n]
        end
      end
      roman
    end
  end
end
