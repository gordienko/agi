#
#  File: error.rb
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

# all the subclass of Exception is defined here


class Error < Exception
end

class DigitError < Exception
end

class HangupError < Exception
end

#class TimeoutError < Exception
#end

class ChannelError < Exception
end

class CommandError < Exception
end

class AGIError < Exception
end
