#
#  File: asterisk_variables.rb
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

# == Overview
#

# Followings are the list of AGI variables
#    -- agi >> agi_request
#    -- agi >> agi_channel
#    -- agi >> agi_language
#    -- agi >> agi_type
#    -- agi >> agi_uniqueid
#    -- agi >> agi_callerid
#    -- agi >> agi_dnid
#    -- agi >> agi_rdnis
#    -- agi >> agi_context
#    -- agi >> agi_extension
#    -- agi >> agi_priority
#    -- agi >> agi_enhanced
#    -- agi >> agi_accountcode


require 'agi/agi.rb'
require 'agi/error.rb'

class AGI
end

class AsteriskVariable < AGI

	def initialize
		env
	end

	protected
	def env
		if @asterisk_variable.nil?
			@asterisk_variable = Hash.new
			semaphore do 
				$stdin.each_line do | line |
					line.strip!
					break if line.nil? or line.size.zero? or line == "\n"
					key, value = line.split(':')
					value.strip! if not value.nil?
					if ((not key.nil?) and (not key.to_s.size.zero?))
						@asterisk_variable[key.to_s] = value
					end
				end
			end
		end

		return @asterisk_variable
	end

	protected
	def read_env(name)
		if debug?
			semaphore do
				$stderr.puts "    -- agi << Read asterisk variable '#{name}'"
				$stderr.puts "    -- agi >> Asterisk variable #{name} = #{env[name].to_s}"
			end	
		end

		return env[name]
	end

	public
	def request
		return read_env('agi_request')
	end

	public
	def channel
		return read_env('agi_channel')
	end

	public
	def language
		return read_env('agi_language')
	end

	public
	def type
		return read_env('agi_type')
	end

	public
	def uniqueid
		return read_env('agi_uniqueid')
	end

	public
	def callerid
		if @callerid.nil?
			init_caller_variable
		end

		return @callerid
	end

	public
	def dnid
		return read_env('agi_dnid')	
	end

	public
	def rdnid
		return read_env('agi_rdnid')	
	end

	public
	def context
		return read_env('agi_context')	
	end

	public
	def extension
		return read_env('agi_extension')	
	end

	public
	def priority
		return read_env('agi_priority')	
	end

	public
	def enhanced
		return read_env('agi_enhanced')	
	end

	public
	def accountcode 
		return read_env('agi_accountcode')
	end

	####################################################################
	####  additional methods generated from existing basic methods  ####
	####################################################################

	public
	def calleridname
		if @calleridname.nil?
			init_caller_variable
		end
		
		return @calleridname
	end

	public
	def calleridnumber
		if @calleridnumber.nil?
			init_caller_variable
		end

		return @calleridnumber
	end

	# following methods are not confirm that they are AGI variables
	public
	def callingpres
		return read_env('agi_callingpres')	
	end

	public
	def callingani2
		return read_env('agi_callingani2')	
	end

	public
	def callington
		return read_env('agi_callington')	
	end

	public
	def callingtns
		return read_env('agi_callingtns')	
	end

	# asterisk-1.0.9  : agi_callerid (default value is 'unknown')
	# asterisk-1.0.10 : agi_callerid (default value is 'unknown')
	# asterisk-1.0.10 : agi_callerid, agi_calleridname (default value for both is 'unknown')
	protected
	def init_caller_variable
		@callerid = read_env('agi_callerid').to_s.strip
		if @callerid == "unknown"
			@callerid		= ""
			@calleridname	= ""
			@calleridnumber	= ""
		elsif Regexp.new(/^\d+\d$/).match(@callerid)
			@calleridname	= read_env('agi_calleridname')
			@calleridnumber	= @callerid
		else
			@calleridname	= read_env('agi_calleridname')
			if @calleridname.nil?					# for asterisk that don't have agi variable 'agi_calleridname'
				name		= Regexp.new(/\".+\"/).match(@callerid)
				number		= Regexp.new(/\<\d+\>/).match(@callerid)

				if name.nil?
					@calleridname = ""
				else
					name = name.to_s
					name.gsub!(/\"/, '')
					@calleridname = name.to_s.strip
				end

				if number.nil?
					@calleridnumber = ""
				else
					number = number.to_s
					number.sub!(/\</, '')
					number.sub!(/\>/, '')
					@calleridnumber = number.to_s.strip
				end
			else									# for asterisk that have agi variable 'agi_calleridname'
				@calleridnumber	= @callerid
				@callerid		= "\"#{@calleridname}\" <#{@calleridnumber}>"
			end
		end
	end
end
