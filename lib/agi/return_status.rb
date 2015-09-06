#
#  File: return_status.rb
#
#  agi: Ruby Language API for Asterisk
#
#  Copyright (C) <2005>  Mohammad Khan <info@beeplove.com>
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#


#  every method of this class would return string or boolean
#  methods of command class usually return ReturnStatus object

class ReturnStatus

	def initialize(command, message)
		@command = command.chomp
		@message = message
		@result = nil
		@digit = nil
		@digits = nil
		@return_code = nil
		@command_error = false

		if message.nil?
			@messsage = "No responses !!"
		else
			str = @message.split(' ')
			@return_code = str[0]
			if @return_code == '200'
				@result = str[1].split('=')[1]
			end
		end
	end

	public
	def to_s
		return @command.to_s + ' >> ' + @message.to_s
	end

	public
	def result
		return @result.to_s
	end

	public
	def digit
		if (@result == '0')
			return nil
		else
			return @result.to_i.chr
		end
	end

	public
	def digits
		return @result.to_s
	end
	
	public
	def message
		return @message.to_s
	end
	
	public	
	def command_error?
		return (result.nil? or (not (@return_code == '200')))
	end

	public
	def timeout?
		rgx = Regexp.new(/\(timeout\)/)
		if rgx.match(@message)
			return true
		else
			return false
		end
	end
end
