#
#  File: agi.rb
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


require 'sync'

require 'agi/error.rb'
require 'agi/command.rb'
require 'agi/asterisk_variable.rb'
require 'agi/return_status.rb'


class AGI

	#
	# constructor method of class AGI
	#
	# <b>Parameters</b>
	# - none
	#
	# <b>Returns</b>
	# - self
	#
	def initialize
		@@debug				= nil
		@@stdin_semaphore	= nil
		@@stdout_semaphore	= nil
		@@stderr_semaphore	= nil

		begin
			@@env = AsteriskVariable.new if @@env.nil?
		rescue NameError
			@@env = AsteriskVariable.new
		rescue
			raise(AGIError, "Error to initialize @@env in AGI#initialize, please report to info@beeplove.com")
		end

		begin
			@@command = Command.new if @@command.nil?
		rescue NameError
			@@command = Command.new
		rescue
			raise(AGIError, "Error to initialize @@command in AGI#initialize, please report to info@beeplove.com")
		end
	end

	#
	# method to get Command object instance
	#
	# <b>Parameters</b>
	# - none
	# <b>Returns</b>
	# - Command object
	#
	private
	def command
		if @@command.nil?
			@@command = Command.new
		end
		return @@command
	end 

	#
	# <method description>
	#
	# <b>Parameters</b>
	# - none
	# <b>Returns</b>
	# - AsteriskVariable object
	#
	private
	def env
		if @@env.nil?
			@@env = AsteriskVariable.new
		end

		return @@env	
	end

	#
	# <method description>
	#
	# <b>Parameters</b>
	# - none
	# <b>Returns</b>
	# - Sync object
	#
	private
	def stdin_semaphore
		if @@stdin_semaphore.nil?
			@@stdin_semaphore = Sync.new
		end
		$stdin.sync = true
		
		return @@stdin_semaphore	
	end

	#
	# <method description>
	#
	# <b>Parameters</b>
	# - none
	# <b>Returns</b>
	# - Sync object
	#
	private
	def stdout_semaphore
		if @@stdout_semaphore.nil?
			@@stdout_semaphore = Sync.new
		end
		$stdout.sync = true
		
		return @@stdout_semaphore	
	end

	#
	# <method description>
	#
	# <b>Parameters</b>
	# - none
	# <b>Returns</b>
	# - Sync object
	#
	private
	def stderr_semaphore
		if @@stderr_semaphore.nil?
			@@stderr_semaphore = Sync.new
		end
		$stderr.sync = true
		
		return @@stderr_semaphore	
	end

	#
	# <method description>
	#
	# <b>Parameters</b>
	# - none
	# <b>Returns</b>
	# - yield
	#
	public
	def semaphore
		if block_given?
			stderr_semaphore.synchronize do 
				stdout_semaphore.synchronize do 
					stdin_semaphore.synchronize do 
						yield
					end
				end
			end
		end
	end

	#
	# <method description>
	#
	# <b>Parameters</b>
	# - val(Boolean)
	# <b>Returns</b>
	# - none
	#
	def debug=(val)
		@@debug = val
	end

	#
	# <method description>
	#
	# <b>Parameters</b>
	# - none
	# <b>Returns</b>
	# - Boolean
	#
	def debug?
		return @@debug == true
	end

	#
	# <method description>
	#
	# <b>Parameters</b>
	# - none
	# <b>Returns</b>
	# - String
	#
	def request
		return env.request
	end

	#
	# <method description>
	#
	# <b>Parameters</b>
	# - none
	# <b>Returns</b>
	# - String
	#
	def channel
		return env.channel
	end

	#
	# <method description>
	#
	# <b>Parameters</b>
	# - none
	# <b>Returns</b>
	# - String
	#
	def language
		return env.language
	end

	#
	# <method description>
	#
	# <b>Parameters</b>
	# - none
	# <b>Returns</b>
	# - String
	#
	def type
		return env.type
	end

	#
	# <method description>
	#
	# <b>Parameters</b>
	# - none
	# <b>Returns</b>
	# - String
	#
	def uniqueid
		return env.uniqueid
	end

	#
	# method to read callerid, Ex. "John Smith" <1234567890>
	# regardless of asterisk version, method callerid would return "Caller Name" <Number>
	#
	# <b>Parameters</b>
	# - none
	#
	# <b>Returns</b>
	# - String : empty string for Unidentified 
	#
	def callerid
		return env.callerid
	end

	#
	# method to read calleridname, Ex. John Smith
	#
	# <b>Parameters</b>
	# - none
	#
	# <b>Returns</b>
	# - String : empty string for Unidentified 
	#
	def calleridname
		return env.calleridname
	end

	#
	# method to read calleridnumber, Ex. 1234567890
	#
	# <b>Parameters</b>
	# - none
	#
	# <b>Returns</b>
	# - String : empty string for Unidentified 
	#
	def calleridnumber
		return env.calleridnumber
	end

	#
	# <method description>
	#
	# <b>Parameters</b>
	# - none
	# <b>Returns</b>
	# - String
	#
	def callingpres
		return env.callingpres
	end

	#
	# <method description>
	#
	# <b>Parameters</b>
	# - none
	# <b>Returns</b>
	# - String
	#
	def callingani2
		return env.callingani2
	end

	#
	# <method description>
	#
	# <b>Parameters</b>
	# - none
	# <b>Returns</b>
	# - String
	#
	def callington
		return env.callington
	end

	#
	# <method description>
	#
	# <b>Parameters</b>
	# - none
	# <b>Returns</b>
	# - String
	#
	def callingtns
		return env.callingtns
	end

	#
	# <method description>
	#
	# <b>Parameters</b>
	# - none
	# <b>Returns</b>
	# - String
	#
	def dnid
		return env.dnid
	end

	#
	# <method description>
	#
	# <b>Parameters</b>
	# - none
	# <b>Returns</b>
	# - String
	#
	def rdnid
		return env.rdnid
	end

	#
	# <method description>
	#
	# <b>Parameters</b>
	# - none
	# <b>Returns</b>
	# - String
	#
	def context
		return env.context
	end

	#
	# <method description>
	#
	# <b>Parameters</b>
	# - none
	# <b>Returns</b>
	# - String
	#
	def extension
		return env.extension
	end

	#
	# <method description>
	#
	# <b>Parameters</b>
	# - none
	# <b>Returns</b>
	# - String
	#
	def priority
		return env.priority
	end

	#
	# <method description>
	#
	# <b>Parameters</b>
	# - none
	# <b>Returns</b>
	# - String
	#
	def enhanced
		return env.enhanced
	end

	#
	# <method description>
	#
	# <b>Parameters</b>
	# - none
	# <b>Returns</b>
	# - String
	#
	def accountcode
		return env.accountcode
	end

	#
	# <method description>
	#
	# <b>Parameters</b>
	# - str(String)	: asterisk command in raw format to be executed
	# <b>Returns</b>
	# - ReturnStatus object
	#
	def raw_command(str)
		return command.raw_command(str)
	end

	# 
	# Answers channel if not already in answer state. 
	#
	# <b>Parameters</b>
	# - none
	#
	# <b>Returns</b> 
	# - ReturnStatus object
	#
	def answer
		return command.answer
	end

	#
	# <method description>
	#
	# <b>Parameters</b>
	# - val(Integer)	: time in secconds
	# <b>Returns</b>
	# - ReturnStatus object
	#
	def set_auto_hangup(val)
		return command.set_auto_hangup(val)
	end

	#	
	# Returns the status of the specified channel. 
	# If no channel name is given the returns the status of the current channel. 
	# 
	# <b>Parameters</b>
	# - channel	: name of the channel.
	#
	# <b>Returns</b>
	# - ReturnStatus object
	#
	def channel_status(channel=nil)
		return command.channel_status(channel)
	end 

	#
	# Executes <application> with given <options>. 
	# Applications are the functions you use to create a dial plan in extensions.conf. 
	#
	# <b>Parameters</b>
	# - application	: Asterisk command of the application 
	# - options		: options to be passed with the asterisk application
	#
	# <b>Returns</b>
	# - ReturnStatus object
	#
	def exec(asterisk_application, options=nil)
		return command.exec(asterisk_application, options)
	end		

	#
	# method to get digit(s)
	# pressing '#' will always terminate the input process
	#
	# <b>Parameters</b>
	# - filename : audio to be played before get as input
	# - timeout  : maximum allowed time in second(s) to receive each digit
	#              wait for ever if timeout is nil or negative or zero
	# - max_digit: maximum number of digits to get as input
	#              wait for unlimited number of digits if max_digit is nil or negative or zero
	# <b>Returns</b>
	# - ReturnStatus object
	#
	def wait_for_digits(filename, timeout=nil, max_digit=nil)
		return command.wait_for_digits(filename, timeout, max_digit)
	end

	#
	# method to read a variable
	#
	# <b>Parameters</b>
	# - name	: name of the variable to read
	#
	# <b>Returns</b>
	# - ReturnStatus object
	#
	def get_variable(name)
		return command.get_variable(name)
	end

	#
	# method to hang up the specified channel.
	# If no channel name is given, hangs up the current channel.
	#
	# <b>Parameters</b>
	# - channel	: name of the channel to hang up
	# <b>Returns</b>
	# - ReturnStatus object
	#
	def hangup(channel=nil)
		return command.hangup(channel)
	end

	#	
	# method that Does nothing !!
	#
	# <b>Parameters</b>
	# - msg : message to pass this method
	#
	# <b>Returns</b>
	# - ReturnStatus object
	# success: 200 result=0 
	#
	def noop(msg)
		return command.noop(msg)
	end

	#
	# Receives a character of text on a channel, and discards any further characters after the first one waiting.
	# Most channels do not support the reception of text. See Asterisk Text for details.
	#
	# <b>Parameters</b>
	# - timeout : maximum time to wait for input in seconds
	#             negative or zero is not acceptable
	#
	# <b>Returns</b>
	# - ReturnStatus object
	#
	def receive_char(timeout)
		return command.receive_char(timeout)
	end

    # 
	# Receives a string text on a channel.
	# Most channels do not support the reception of text.
	#
	# <b>Parameters</b>
	# - timeout	: time to wait for input in seconds
	#             negative or zero is not acceptable
	#
	# <b>Returns</b>
	# - ReturnStatus object
	#
	def receive_text(timeout)
		return command.receive_text(timeout)
	end

	#
	# Record to a file until <escape digits> are received as dtmf.
	#
	# <b>Parameters</b>
	# - filename	: location of the file where the audio file will be saved
	# - format		: specify what kind of file will be recorded.
	# - timeout		: maximum record time in seconds
	#                 nil, negative or 0 for no timeout.
	# - offset		: [offset samples] is optional,
	#                 and if provided will seek to the offset without exceeding the end of the file.
	# - silence		: number of seconds of silence allowed before the function returns
	#                 despite the lack of dtmf digits or reaching timeout.
	#                 Silence value must be preceeded by "s=" and is optional.
	#
	# <b>Returns</b>
	# - ReturnStatus object
	#
	def record_file(filename, format='gsm', escape_digits=nil, timeout=nil, beep=true)
		return command.record_file(filename, format, escape_digits, timeout, beep)
	end

	#
	# Say a given digit string, returning early if any of the given DTMF digits are received on the channel.
	#
	# <b>Parameters</b>
	# - number			: number to announce
	# - escape_digit	: if digit pressed during playback, will return from announce
	#
	# <b>Returns</b>
	# - ReturnStatus (object)
	#
	# failure: 200 result=-1
	# success: 200 result=0
	# digit pressed: 200 result=<digit>
	# <digit> is the ascii code for the digit pressed. 
	#
	def say_digits(digit_string, escape_digits=nil)
		return command.say_digits(digit_string, escape_digits)
	end

	#
	# Say a given number, returning early if any of the given DTMF digits are received on the channel.
	#
	# <b>Parameters</b>
	# - number			: number to announce
	# - escape_digit	: if pressed, return from program
	#
	# <b>Returns</b>
	# - ReturnStatus object
	#
	def say_number(number, escape_digits=nil)
		return command.say_number(number, escape_digits)
	end

	#
	# Say a given character string with phonetics, returning early if any of the given DTMF digits are received on the channel.
	#
	# <b>Parameters</b>
	# - string			: character string to announce 
	# - escape_digit	: digit to be pressed to escape from program 
	#
	# <b>Returns</b>
	# - ReturnStatus (object)
	#	
	def say_phonetic(string, escape_digits=nil)
		return command.say_phonetic(string, escape_digits)
	end

	#
	# Say a given time, returning early if any of the given DTMF digits are received on the channel.
	#
	# <b>Parameters</b>
	# - time			: number of seconds elapsed since 00:00:00 on January 1, 1970, Coordinated Universal Time (UTC).
	# - escape_digits	: digit to be pressed to escape from the program
	#
	# <b>Returns</b>
	# - ReturnStatus (object)
	#
	def say_time(time=Time.now.to_i, escape_digits='#')
		return command.say_time(time, escape_digits)
	end

	#
	# Sends the given image on a channel.
	# Most channels do not support the transmission of images.
	# Image names should not include extensions.
	#
	# <b>Parameters</b>
	# - image : location of image
	#
	# <b>Returns</b>
	# - ReturnStatus (object)
	#
	def send_image(image)
		return command.send_image(image)
	end

	#
	# Sends the given text on a channel.
	# Most channels do not support the transmission of text.
	# Text consisting of greater than one word should be placed in quotes since the command only accepts a single argument.
	#
	# <b>Parameters</b>
	# - text : text to be send 
	#
	# <b>Returns</b>
	# - ReturnStatus (object)
	#
	def send_text(text)
		return command.send_text(text)
	end

	#
	# Changes the callerid of the current channel.
	#
	# <b>Parameters</b>
	# - number : number to be set a callerid
	#
	# <b>Returns</b>
	# - ReturnStatus (object)
	#
	def set_caller_id(number)
		return command.set_caller_id(number)
	end

	#
	# Sets the context for continuation upon exiting the application.
	#
	# <b>Parameters</b>
	# - context : name of the context
	#
	# <b>Returns</b>
	# - ReturnStatus object
	#
	def set_context(context)
		return command.set_context(context)
	end

	#
	# Changes the extension for continuation upon exiting the application.
	#
	# <b>Parameters</b>
	# - extension: name or number of extension to be set
	#
	# <b>Returns</b>
	# - ReturnStatus object
	#
	def set_extension(extension)
		return command.set_extension(extension)
	end

	#
	# Changes the priority for continuation upon exiting the application.
	#
	# <b>Parameters</b>
	# - priority : number of priority
	#
	# <b>Returns</b>
	# - ReturnStatus object
	def set_priority(priority)
		return command.set_priority(priority)
	end

	#
	# Enables/Disables the music on hold generator.
	#
	# <b>Parameters</b>
	# - mode		: on or off
	# - moh_class	: name of the music on hold class 
	#                 'default' for not provided or nil
	#
	# <b>Returns</b>
	# - ReturnStatus object
	#
	def set_music(mode=true, moh_class='default')
		return command.set_music(mode, moh_class)
	end

	#
    # set variable: Sets a channel variable
	# These variables live in the channel Asterisk creates
	# when you pickup a phone and as such they are both local
	# and temporary. Variables created in one channel can not
	# be accessed by another channel. When you hang up the phone,
	# the channel is deleted and any variables in that channel are deleted as well. 
	#
	# <b>Parameters</b>
	# - variablename	: name of the variable
	# - value			: value to be set for the variable 
	#
	# <b>Returns</b> 
	# - ReturnStatus object
	#
	def set_variable(name, value)
		return command.set_variable(name, value)
	end

	#
    # stream file: Sends audio file on channel
	# Send the given file, allowing playback to be interrupted by the given digits, if any. 
	# Use double quotes for the digits if you wish none to be permitted. 
	# If sample offset is provided then the audio will seek to sample offset before play starts. 
	# Remember, the file extension must not be included in the filename. 
	# 
	# <b>Parameters</b>
	# - filename	: location of the file to be played
	# - escape_digit: digit to be pressed to escape from playback
	#
	# <b>Returns</b> 
	# - ReturnStatus object
	#
	def stream_file(filename, escape_digits='#')
		return command.stream_file(filename, escape_digits)
	end

	#
    # tdd mode: Activates TDD mode on channels supporting it, to enable communication with TDDs.
	# Enable/Disable TDD transmission/reception on a channel. 
	# This function is currently (01July2005) only supported on Zap channels. 
	# As of 02July2005, this function never returns 0 (Not Capable).
	# If it fails for any reason, -1 (Failure) will be returned, otherwise 1 (Success) will be returned.
	# The capability for returning 0 if the channel is not capable of TDD MODE is a future plan. 
	# 
	# <b>Parameters</b>
	# - mode : mode of the tdd to be set
	#          set tdd on if non-zero or 'true' specified
	#
	# <b>Returns</b> 
	# - ReturnStatus object
	#
	def tdd_mode(settings=true)
		return command.tdd_mode(settings)
	end

	#
	# Sends <message> to the console via verbose message system. 
	# The Asterisk verbosity system works as follows.
	# The Asterisk user gets to set the desired verbosity at startup time
	# or later using the console 'set verbose' command.
	# Messages are displayed on the console if their verbose level
	# is less than or equal to desired verbosity set by the user.
	# More important messages should have a low verbose level;
	# less important messages should have a high verbose level. 
	#
	# <b>Parameters</b>
	# - message : message to be send as log
	# - level   : verbose level to be set
	#             [level] is the the verbose level (1-4)
	#             If you specify a verbose level less than 1 or greater than 4, the verbosity is 1.
	#             The default verbosity seems to be 0 (in 1.0.8),
	#             and supplying a 0 (zero) verbosity does work:
	#             the message will be displayed regardless of the console verbosity setting. 
	#
	# <b>Returns</b>
	# - ReturnStatus object
	#
	def verbose(message, level=3)
		return command.verbose(message, level)
	end

	#
    # wait for digit: Waits for a digit to be pressed 
	# Waits up to <timeout> milliseconds for channel to receive a DTMF digit. 
	# 
	# <b>Parameters</b>
	# - timeout : maximum allow waiting time in seconds to get input
	#             nil, zero or negative would be considered as infinite wait time
	#
	# <b>Returns</b>
	# - ReturnStatus object
	#
	def wait_for_digit(timeout=nil)
		return command.wait_for_digit(timeout)
	end

	#
	# method to dial out
	#
	# <b>Parameters</b>
	# - telephone_number	: telephone_number or extension to dial
	# - protocol			: protocol to be used to make this call
	# - username			: username to be used to make this call using the specified protocol
	# - context				: name of the context to be used for authentication
	# - timeout				: maximum allowed time in seconds to make this call
	# - options				: options to be passed in 'Dial' command
	#
	# <b>Returns</b>
	# - ReturnStatus object
	#
	def dial(telephone_number=nil, protocol=nil, username=nil, context=nil, timeout=nil, options=nil)
		return command.dial(telephone_number, protocol, username, context, timeout, options)
	end

	#
	# method to jump in a specified context, extension and priority
	#
	# <b>Parameters</b>
	# - context		: name of the context
	# - extension	: name of the extension
	# - priority	: name of the priority
	#
	# <b>Returns</b>
	# - none
	#
	def jump_to(context=nil, extension=nil, priority=nil)
		command.jump_to(context, extension, priority)
	end
end

