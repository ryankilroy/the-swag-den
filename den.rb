require 'sinatra'

class TheRyansDen < Sinatra::Base

		set :public_folder, 'public'
		set :show_exceptions, false
		set :raise_errors, false	

		get '/' do
				slim :index
		end

		get '/riddles' do
				slim :riddles
		end

		get '/riddles/:num' do
				@num = params[:num]
				if @num.to_i > 6
						redirect to('/error')
				end
				File.foreach(File.join('public', '/assets/riddles')) do |line|
						if line[0,1] == @num
								@riddle = line[2,line.length-2]
						end
				end
				slim :riddle
		end

		post '/riddles/:num' do
				@guess = params[:guess].strip.downcase
				@num = params[:num]
				redirect to(checkRiddleGuess(@guess,@num))
		end

		get '/answer' do
				return 'smartass.'
		end

		post '/answer' do
				riddle1 = params[:riddle1].strip.downcase
				riddle2 = params[:riddle2].strip.downcase
				riddle3 = params[:riddle3].strip.downcase
				riddle4 = params[:riddle4].strip.downcase
				riddle5 = params[:riddle5].strip.downcase
				riddle6 = params[:riddle6].strip.downcase
				@guesses = [riddle1, riddle2, riddle3, riddle4, riddle5, riddle6]
				puts @guesses
				@corrects = [false, false, false, false, false, false]
				puts @corrects
				@guesses.each_with_index do |guess, index|
						@corrects[index] = checkRiddleGuess(guess, index+1)
				end
				slim :results
		end

		get '/:page' do
				@page = params[:page]
				if checkFinalMatch(@page.strip.downcase)
						slim :answer
				else
						slim @page.to_sym
				end

		end

		error do
				redirect to('http://www.warnerbros.com/archive/spacejam/movie/jam.htm')
		end

		def checkRiddleGuess(guess, num)
				File.foreach(File.join('public', '/assets/answers')) do |line|
						puts num
						puts line[0,1]
						if line[0,1] == num
								@answer = line[2,line.length-2].split(',')
								puts "guess: #{guess}"
								puts "answer: #{@answer}"
								if @answer.is_a?(Array)
										correct = checkMatch(guess, @answer)
										close = checkCloseness(guess, @answer)
										if correct
												return ('/correct')
										elsif close
												return ('/close')
										else
												return ('/wrong')
										end
								end
						end
				end
		end

		def checkFinalMatch(guess)
				answer = File.open(File.join('public', '/assets/answers')).to_a.last.strip.downcase
				answer = answer[2,answer.length-2].split(',')
				return checkMatch(guess, answer)
		end

		def checkMatch(guess, ansArray)
				correct = true
				ansArray.each { |ans|
						ans = ans.strip.downcase

						if guess.include?(ans)

						elsif guess == '9' and ans == 'nine'

						else
								correct = false
						end
				}
				return correct 
		end

		def checkCloseness(guess, ansArray)
				partial = false
				ansArray.each { |ans|
						str = ans.dup
						sim = 0
						guess.split(//).inject(0) do |sum, char|
								sim += 1 if str.sub!(char,'')
						end

						if sim > (guess.length*0.3)
								partial = true
						end
				}
				return partial
		end

end
