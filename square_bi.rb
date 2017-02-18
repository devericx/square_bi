# splits given equation into array: [first term, second term]
# second term is prepended a "-" if negative
def parse(string)
	operation = string.match(/ [-,+] /)[0]
	neg_op = string.match(/- /)
	coeff_reg = string.match(/^-.?/)

	binomial = string.split(operation)

	binomial.delete ""

	binomial.each_with_index do |s, index|
		new_s = s.strip
		binomial[index] = new_s
	end

	unless coeff_reg
		binomial[0].prepend "+"
	end

	if neg_op
		binomial[1].prepend "-"
	else
		binomial[1].prepend "+"
	end

	return binomial
end

# splits individual term into array: [coefficient (fixnum), exponent (fixnum), variable]
def split_term(string)
	variable = string.match(/[a-zA-Z]/)

	unless variable
		term = [string.to_i, 1, 1]
		return term
	end

	exp_match = string.match(/\^/)

	unless exp_match
		term = string.split(/[a-zA-Z]/)
		term.delete ""

		if term[0] == "+"
			term[0] = 1
		elsif term[0] == "-"
			term[0] = -1
		else
			term[0] = term[0].to_i
		end

		term[1] = 1

		term.push variable[0]

		return term
	end

	term = string.split(/[a-zA-Z, \^]/)
	term.delete ""
	term.push variable[0]

	if term[0] == "+"
		term[0] = 1
	elsif term[0] == "-"
		term[0] = -1
	else
		term[0] = term[0].to_i
	end

	term[1] = term[1].to_i

	return term
end

# squares given term array, returns squared term as string, removes coefficient if it equals 1
def square(array)

	coefficient = array[0]
	exponent = array[1]
	variable = array[2]

	coefficient **= 2
	exponent *= 2

	if coefficient == 1 && variable == 1
		term = "#{coefficient}"
		return term
	end

	if coefficient == 1
		term = "#{variable}^#{exponent}"
		return term
	end

	if variable == 1
		term = "#{coefficient}"
		return term
	end

	term = "#{coefficient}#{variable}^#{exponent}"

	return term
end

# doubles the products of two (already split) terms, returns as string
def double_product(a, b)
	coefficient_one = a[0]
	exponent_one = a[1]
	variable_one = a[2]

	coefficient_two = b[0]
	exponent_two = b[1]
	variable_two = b[2]

	coefficient_three = 2 * coefficient_one * coefficient_two

	if variable_one == 1
		exponent_three = 1

		if exponent_two > 1
			product = "#{coefficient_three}#{variable_two}^#{exponent_two}"
		else
			product = "#{coefficient_three}#{variable_two}"
		end

		return product
	end

	if variable_two == 1
		exponent_three = 1

		if exponent_one > 1
			product = "#{coefficient_three}#{variable_one}^#{exponent_one}"
		else
			product = "#{coefficient_three}#{variable_one}"
		end

		return product
	end

	if variable_one == variable_two
		variable_three = variable_one
		exponent_three = exponent_one + exponent_two
		product = "#{coefficient_three}#{variable_three}^#{exponent_three}"

		return product
	else
		if exponent_one == 1 && exponent_two == 1
			variable_exponent = "#{variable_one}#{variable_two}"
		elsif exponent_one == 1
			variable_exponent = "#{variable_one}#{variable_two}^#{exponent_two}"
		elsif exponent_two == 1
			variable_exponent = "#{variable_one}^#{exponent_one}#{variable_two}"
		else
			variable_exponent = "#{variable_one}^#{exponent_one}#{variable_two}^#{exponent_two}"
		end

		product = "#{coefficient_three}#{variable_exponent}"

		return product
	end
end

# combines all three terms from square and double product
def combine(square_one, double_product, square_two)
	if double_product.include? "-"
		clean_double = " - #{double_product.delete "-"} "
	else
		clean_double = " + #{double_product} "
	end

	clean_two = "+ #{square_two}"

	polynomial = square_one + clean_double + clean_two

	return polynomial
end



=begin [-unit test-]
tests = ["7x + 3", "8x - 7y", "5x^2 + 2", "2x^3 - 7y^3"]

tests.each do |input|
	binomial = parse(input)

	split_first = split_term(binomial[0])
	split_second = split_term(binomial[1])

	square_one = square(split_first)
	dp = double_product(split_first, split_second)
	square_two = square(split_second)

	puts combine(square_one, dp, square_two)
end

[-self test-]
input = ARGV[0]
binomial = parse(input)

split_first = split_term(binomial[0])
split_second = split_term(binomial[1])

square_one = square(split_first)
dp = double_product(split_first, split_second)
square_two = square(split_second)

puts "Split binomial: " + binomial.inspect
puts "Split first term: " + split_first.inspect
puts "Split second term: " + split_second.inspect
puts "Square one: " + square_one
puts "Square two: " + square_two
puts "DP: " + dp
puts "Combined: " + combine(square_one, dp, square_two)
=end
input = ARGV[0]
binomial = parse(input)

split_first = split_term(binomial[0])
split_second = split_term(binomial[1])

square_one = square(split_first)
dp = double_product(split_first, split_second)
square_two = square(split_second)

puts combine(square_one, dp, square_two)
