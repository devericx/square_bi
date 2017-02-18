def parse(string)
	if string.include? "+"
			binomial = string.split("+")
	elsif string.include? "-"
			binomial = string.split("-")
	else
			puts "Invalid equation."
			exit
	end

	binomial.each_with_index do |s, index|
			new_s = s.strip
			binomial[index] = new_s
	end

	return binomial
end

input = ARGV[0]

print parse(input)

