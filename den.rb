require 'sinatra'
require 'date'

class TheRyansDen < Sinatra::Base

		set :public_folder, 'public'
		set :show_exceptions, false
		set :raise_errors, false	
		
		$header = "Welcome to the Ryans Den"

		get '/' do
				slim :index
		end

		get '/riddles' do
				slim :riddles
		end

		get '/countdone' do
				countdown = DateTime.new(2016,10,01,20,59,0,'-4:00')
				if countdown > DateTime::now 
					return "Too eager young grasshopper."
				else
					redirect to('/rules')
				end
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
				@corrects = []
				@guesses.each_with_index do |guess, index|
						@corrects[index] = checkRiddleGuess(guess, index+1)
						@corrects[index][0] = ''
				end
				completely_right = true
				@corrects.each do |result|
					if result != 'correct'
						completely_right = false
					end
				end
				if completely_right
					@winner = params[:name]
					File.open(File.join('public','assets/winners'), 'a') { |f|
						f.puts @winner
					}
					redirect to('/winners')
				else
					slim :results
				end
		end

		get '/winners' do
			@header = 'Winners!'
			@winners = []
			File.foreach(File.join('public', 'assets/winners')).with_index do |line, index|
				if index == 0
					@winner = line
				else 
					@winners[index-1] = line
				end
			end
			slim :winners
		end

		get '/reset' do
			File.truncate(File.join('public', 'assets/winners'), 0)
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
						if line[0,1] == num.to_s
								@answer = line[2,line.length-2].split(',')
								puts "guess: #{guess}"
								if @answer.is_a?(Array)
										correct = checkMatch(guess, @answer)
										close = checkCloseness(guess, @answer)
										if correct
												puts 'correct'
												return ('/correct')
										elsif close
												puts 'close'
												return ('/close')
										else
												puts 'wrong'
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
