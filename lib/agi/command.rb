#
#  File: command.rb
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

# this would be the most used class

# most common arguements
# timeout: nil, zero, neative =forever, 
# escape_digit, by default #, if nil passed as argument there will not have any escape
# escape_digits, by default #, if nil passed as argument there will not have any escape
# channel, current channel otherwise mentioned
# max_digit, maximum number of digits would be accepted from user, always 255 otherwise mentioned
# filename, name of file to be streamed, recoreds ..
# beep, always yes, otherwise passed false or nil as argument
# format, always gsm otherwise mentioned
# secs, all methods need time as an argument are passed as seconds

require 'sync'

require 'agi/agi.rb'
require 'agi/return_status.rb'
require 'agi/error.rb'

class AGI
end


class Command < AGI
	def initialize
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
	# failure: 200 result=-1 
	# success: 200 result=0 
	# Command Reference: ANSWER
	#
	public
	def answer
		cmd = "ANSWER"
		rs = exec_command(cmd)
		raise CommandError, rs.to_s if rs.command_error?
		return rs
	end

	#
	# Cause the channel to automatically hangup at <time> seconds in the future. 
	# Of course it can be hungup before then as well. 
	# Setting to 0 will cause the autohangup feature to be disabled on this channel. 
	#
	# <b>Parameters</b>
	# - time : number of seconds, after this time period channel will be automatically hung up
	#
	# <b>Returns</b>
	# - ReturnStatus object
	#
	# 200 result=0 
	# Command Reference: SET AUTOHANGUP <time> 
	#
	public
	def set_auto_hangup(secs=0)
		cmd = "SET AUTOHANGUP #{secs.to_s}"
		rs = exec_command(cmd)
		raise CommandError, rs.to_s if rs.command_error?
		return rs
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
	# failure: 200 result=-1 
	# success: 200 result=<status> 
	# <status> values: 
	# 0 Channel is down and available 
	# 1 Channel is down, but reserved 
	# 2 Channel is off hook 
	# 3 Digits (or equivalent) have been dialed 
	# 4 Line is ringing 
	# 5 Remote end is ringing 
	# 6 Line is up 
	# 7 Line is busy 
	# Command Reference: CHANNEL STATUS [<channelname>] 
	#
	public
	def channel_status(channel=nil)
		if channel.nil?
			channel = ""
		end

		cmd = "CHANNEL STATUS #{channel.to_s}"
		rs = exec_command(cmd)
		raise CommandError, rs.to_s if rs.command_error?
		return rs
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
	# failure: 200 result=-2 
	# success: 200 result=<ret> 
	# Command Reference: EXEC <application> <options> 
	#
	public
	def exec(application, options=nil)
		if options.nil?
			options = ""
		end
		cmd = "EXEC #{application.to_s} #{options.to_s}"
		rs = exec_command(cmd)
		raise CommandError, rs.to_s if rs.command_error?
		return rs
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
	# failure: 200 result=-1
	# timeout: 200 result=<digits> (timeout)
	# success: 200 result=<digits>
	# <digits> is the digits pressed. 
	# Command Reference: GET DATA <file to be streamed> [timeout] [max digits]
	#
	public
	def wait_for_digits(filename, timeout=nil, max_digit=nil)
		
		timeout = sanitize_timeout(timeout)
		max_digit = sanitize_max_digit(max_digit)

		cmd = "GET DATA #{filename.to_s} #{timeout.to_s} #{max_digit.to_s}"

		rs = exec_command(cmd)
		raise CommandError, rs.to_s if rs.command_error?
		return rs
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
	# Does not work with global variables. Does not work with some variables that are generated by modules.
	# failure or not set: 200 result=0
	# success: 200 result=1 <value>
	# Command Reference: GET VARIABLE <variablename>
	# 
	public
	def get_variable(name)
		cmd = "GET VARIABLE #{name.to_s}"
		rs = exec_command(cmd)
		raise CommandError, rs.to_s if rs.command_error?
		return rs
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
	# failure: 200 result=-1
	# success: 200 result=1
	# Command Reference: HANGUP [<channelname>] 
	#
	public
	def hangup(channel=nil)
		if channel.nil?
			channel = ""
		end

		cmd = "HANGUP #{channel.to_s}"
		rs = exec_command(cmd)
		raise CommandError, rs.to_s if rs.command_error?
		return rs
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
	# Command Reference: Usage: NOOP 
	#
	public
	def noop(msg)
		cmd = "NOOP #{msg.to_s}"
		rs = exec_command(cmd)
		raise CommandError, rs.to_s if rs.command_error?
		return rs
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
	# failure or hangup: 200 result=-1 (hangup)
	# timeout: 200 result=<char> (timeout)
	# success: 200 result=<char>
	# <char> is the character received, or 0 if the channel does not support text reception.
	# Command Reference: RECEIVE CHAR <timeout>
	#
	public
	def receive_char(timeout)
		timeout = sanitize_timeout(timeout)
		raise(ArgumentError, "timeout need to be positive") if (timeout < 1)

		cmd = "RECEIVE CHAR #{timeout.to_s}"
		rs = exec_command(cmd)
		raise CommandError, rs.to_s if rs.command_error?
		return rs
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
	# failure, hangup, or timeout: 200 result=-1
	# success: 200 result=<text>
	# <text> is the text received on the channel.
	# Command Reference: RECEIVE TEXT <timeout>
	#
	public
	def receive_text(timeout)
		timeout = sanitize_timeout(timeout)
		raise(ArgumentError, "timeout need to be positive") if (timeout < 1)

		cmd = "RECEIVE TEXT #{timeout.to_s}"
		rs = exec_command(cmd)
		raise CommandError, rs.to_s if rs.command_error?
		return rs
	end

	#
	# Record to a file until <escape digits> are received as dtmf.
	#
	# <b>Parameters</b>
	# - filename		: location of the file where the audio file will be saved
	# - format			: specify what kind of file will be recorded.
	# - escape_digits	: digit(s) to be pressed to complete recording
	# - timeout			: maximum record time in seconds
	#                     nil, negative or 0 for no timeout.
	# - offset			: [offset samples] is optional,
	#                     and if provided will seek to the offset without exceeding the end of the file.
	# - silence		 	: number of seconds of silence allowed before the function returns
	#                     despite the lack of dtmf digits or reaching timeout.
	#                     Silence value must be preceeded by "s=" and is optional.
	#
	# <b>Returns</b>
	# - ReturnStatus object
	#
	# failure to write: 200 result=-1 (writefile)
	# failure on waitfor: 200 result=-1 (waitfor) endpos=<offset>
	# hangup: 200 result=0 (hangup) endpos=<offset>
	# interrrupted: 200 result=<digit> (dtmf) endpos=<offset>
	# timeout: 200 result=0 (timeout) endpos=<offset>
	# random error: 200 result=<error> (randomerror) endpos=<offset>
	# <offset> is the end offset in the file being recorded.
	# <digit> is the ascii code for the digit pressed.
	# <error> ?????
	#
	# Command Reference: RECORD FILE <filename> <format> <escape digits> <timeout> [offset samples] [BEEP] [s=<silence>]
	#
	public
	def record_file(filename, format='gsm', escape_digits='#', timeout=nil, beep=true)

		format = sanitize_file_format(format)
		escape_digits = sanitize_escape_digits(escape_digits)
		timeout = sanitize_timeout(timeout)
		
		
		if ((escape_digits == "X") and (timeout == -1))
			raise(ArgumentError, "need at least one valid escape digit or timeout need te positive")
		end
		
		cmd = "RECORD FILE #{filename} #{format} #{escape_digits} #{timeout}"
		cmd = "#{cmd} beep" if beep == true
		rs = exec_command(cmd)
		raise CommandError, rs.to_s if rs.command_error?
		return rs
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
	# Command Reference:  SAY DIGITS <number> <escape digits>
	#
	public
	def say_digits(digit_string, escape_digits=nil)
		escape_digits = sanitize_escape_digits(escape_digits)

		cmd = "SAY DIGITS #{digit_string.to_s} #{escape_digits}" 
		rs = exec_command(cmd)
		raise CommandError, rs.to_s if rs.command_error?
		return rs
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
	# failure: 200 result=-1
	# success: 200 result=0
	# digit pressed: 200 result=<digit>
	#<digit> is the ascii code for the digit pressed. 
	#
	# Command Reference:  SAY NUMBER <number> <escape digits>
	#
	public
	def say_number(number, escape_digits=nil)
		escape_digits = sanitize_escape_digits(escape_digits)
		cmd = "SAY NUMBER #{number.to_s} #{escape_digits.to_s}"
		rs = exec_command(cmd)
		raise CommandError, rs.to_s if rs.command_error?
		return rs
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
	# failure: 200 result=-1
	# success: 200 result=0
	# digit pressed: 200 result=<digit>
	# <digit> is the ascii code for the digit pressed.
	#
	# Command Reference: SAY PHONETIC <string> <escape digits>
	#
	public
	def say_phonetic(string, escape_digits=nil)
		escape_digits = sanitize_escape_digits(escape_digits)
		cmd = "SAY PHONETIC #{string.to_s} #{escape_digits}"
		rs = exec_command(cmd)
		raise CommandError, rs.to_s if rs.command_error?
		return rs
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
	# failure: 200 result=-1
	# success: 200 result=0
	# digit pressed: 200 result=<digit>
	# <digit> is the ascii code for the digit pressed.
	#
	# Command Reference: SAY TIME <time> <escape digits>
	#
	public
	def say_time(time=Time.now.to_i, escape_digits='#')
		escape_digits = sanitize_escape_digits(escape_digits)
		cmd = "SAY TIME #{time.to_s} #{escape_digits.to_s}"
		rs = exec_command(cmd)
		raise CommandError, rs.to_s if rs.command_error?
		return rs
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
	# failure: 200 result=-1
	# success: 200 result=0 
	#
	# Command Reference: SEND IMAGE <image>
	#
	public
	def send_image(image)
		cmd = "SEND IMAGE #{image.to_s}"
		rs = exec_command(cmd)
		raise CommandError, rs.to_s if rs.command_error?
		return rs
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
	# failure: 200 result=-1
	# success: 200 result=0 
	#
	# Command Reference: SEND TEXT "<text to send>"
	#
	public
	def send_text(text)
		cmd = "SEND TEXT #{text.to_s}"
		rs = exec_command(cmd)
		raise CommandError, rs.to_s if rs.command_error?
		return rs
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
	# 200 result=1 
	#	
	# Command Reference: SET CALLERID <number>
	#
	public
	def set_caller_id(number)
		cmd = "SET CALLERID #{number.to_s}"
		rs = exec_command(cmd)
		raise CommandError, rs.to_s if rs.command_error?
		return rs
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
	# 200 result=0
	# Note: no checking is done to verify that the context is valid.
	#       Specifying an invalid context will cause the call to drop
	#
	# Command Reference: SET CONTEXT <desired context>
	#
	public
	def set_context(context)
		cmd = "SET CONTEXT #{context.to_s}"
		rs = exec_command(cmd)
		raise CommandError, rs.to_s if rs.command_error?
		return rs
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
	# 200 result=0
	# Note: no checking is done to verify that the extension extists.
	#       If the extension does not exist, the PBX will attempt to move to the "i" (invalid) extension.
	#       If the invalid "i" extension does not exist, the call will drop
	#
	# Command Reference: SET EXTENSION <new extension>
	#
	public
	def set_extension(extension)
		cmd = "SET EXTENSION #{extension.to_s}"
		rs = exec_command(cmd)
		raise CommandError, rs.to_s if rs.command_error?
		return rs
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
	# 200 result=0 
	# Command Reference: SET MUSIC <on|off> <class>
	#
	public
	def set_music(mode=true, moh_class='default')
		if ((mode == true) or (not (mode == 0)))
			mode = 'ON'
		else
			mode = 'OFF'
		end
		cmd = "SET MUSIC #{mode.to_s} #{moh_class.to_s}"
		rs = exec_command(cmd)
		raise CommandError, rs.to_s if rs.command_error?
		return rs
	end

	#
	# Changes the priority for continuation upon exiting the application.
	#
	# <b>Parameters</b>
	# - priority : number of priority
	#
	# <b>Returns</b>
	# - ReturnStatus object
	#
	# 200 result=0 
	# Command Reference: SET PRIORITY <num>
	#
	public
	def set_priority(priority)
		cmd = "SET PRIORITY #{priority.to_s}"
		rs = exec_command(cmd)
		raise CommandError, rs.to_s if rs.command_error?
		return rs
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
	# 200 result=1 
	# Command Reference: SET VARIABLE <variablename> <value> 
	#
	public
	def set_variable(name, value)
		cmd = "SET VARIABLE #{name.to_s} \"#{value.to_s}\""
		rs = exec_command(cmd)
		raise CommandError, rs.to_s if rs.command_error?
		return rs
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
	# failure: 200 result=-1 endpos=<sample offset> 
	# failure on open: 200 result=0 endpos=0 
	# success: 200 result=0 endpos=<offset> 
	# digit pressed: 200 result=<digit> endpos=<offset> 
	# <offset> is the stream position streaming stopped. If it equals <sample offset> there was probably an error. 
	# <digit> is the ascii code for the digit pressed. 
	# Command Reference: STREAM FILE <filename> <escape digits> [sample offset] 
	#
	public
	def stream_file(filename, escape_digits='#')

		escape_digits = sanitize_escape_digits(escape_digits)
		
		cmd = "STREAM FILE #{filename.to_s} #{escape_digits}"
		rs = exec_command(cmd)
		raise CommandError, rs.to_s if rs.command_error?

		return rs
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
	# failure: 200 result=-1 
	# not capable: 200 result=0 
	# success: 200 result=1
	# Command Reference: TDD MODE <on|off|mate> 
	#
	public
	def tdd_mode(mode=true)
		if ((mode == true) or ( not (mode == 1)))
			mode = 'ON'
		else
			mode = 'OFF'
		end
		cmd = "TDD MODE #{mode.to_s}"
		rs = exec_command(cmd)
		raise CommandError, rs.to_s if rs.command_error?
		return rs
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
	# 200 result=1 
	# Command Reference: VERBOSE <message> [level] 
	# 
	public
	def verbose(message, level=3)
		cmd = "VERBOSE \"#{message.to_s}\" #{level.to_s}"
		rs = exec_command(cmd)
		raise CommandError, rs.to_s if rs.command_error?
		return rs
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
	# failure: 200 result=-1 
	# timeout: 200 result=0 
	# success: 200 result=<digit> 
	# <digit> is the ascii code for the digit received. 
	# Command Reference: WAIT FOR DIGIT <timeout> 
	#
	public
	def wait_for_digit(timeout=nil)
		timeout = sanitize_timeout(timeout)
		
		cmd = "WAIT FOR DIGIT #{timeout.to_s}"
		rs = exec_command(cmd)
		raise CommandError, rs.to_s if rs.command_error?
		return rs
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
	# Command Reference: Dial(type/identifier,timeout,options,URL) 
	#
	def dial(telephone_number=nil, protocol=nil, username=nil, context='default', timeout=nil, options=nil)
		dial_string = nil

		if protocol == 'LOCAL'
			return nil if (telephone_number.nil? or context.nil?)
			dial_string = "LOCAL/#{telephone_number}@#{context}"
		elsif protocol == 'IAX2'
			return nil if (telephone_number.nil? or username.nil? or context.nil?)
			telephone_number.strip!
			dial_string = "IAX2/#{username}@#{context}/#{telephone_number}" 
		elsif protocol == 'SIP'
		else
			return nil
		end

		timeout.nil? ? dial_string += "|" : dial_string += "|#{timeout}"
		options.nil? ? dial_string += "|" : dial_string += "|#{options}"
		rs = exec('DIAL', dial_string)
		return rs
	end

	###### Process methods #######
	
	public
	def raw_command(cmd)
		rs = exec_command(cmd)
		raise CommandError, rs.to_s if rs.command_error?
		return rs
	end

	#private
	#def escape(str)
	#	rxp = Regexp.new(/\"/)
	#	return str.gsub(rxp, '\"') 
	#end

	protected
	def exec_command(cmd)
		rs = nil
		begin
			semaphore do
				$stderr.puts "    -- agi << #{cmd}" if debug?
				$stdout.puts cmd
				responses = $stdin.gets
				$stderr.puts "    -- agi >> #{responses}" if debug?
				rs = ReturnStatus.new(cmd, responses)

			end

		rescue Errno::EPIPE
			raise HangupError, "Line hung up during command execution!!"
		end

		return rs
	end

	protected
	def sanitize_escape_digits(digits)
		if digits.nil?
			digits = "#"	
		elsif digits.size == 0
			digits = "X"
		else
			digits = digits.to_s
		end

		return digits	
	end

	protected
	def sanitize_timeout(timeout)
		if timeout.nil? or timeout <= 0
			timeout = -1
		else
			timeout = timeout * 1000
		end
		
		return timeout
	end
	
	protected
	def sanitize_file_format(format)
		if format.nil? or format.size == 0
			format = "gsm"
		else
			format = format.to_s
		end

		return format
	end

	protected
	def sanitize_max_digit(max_digit)
		if ((max_digit.nil?) or (max_digit <= 0))
			max_digit = ""
		else
			max_digit = max_digit.to_i
		end

		return max_digit
	end

	############################################
	###        More synthetic methods        ###
	############################################

	public
	def jump_to(context, extension, priority)
		set_context(context)		if not context.nil?
		set_extension(extension)	if not extension.nil?
		set_priority(priority)		if not priority.nil?
	end
end
