#!/usr/bin/env ruby

# File : call_log.rb
# Purpose: log caller and calleridname in syslog as warning message
# Author: Alexey Gordienko, alx@anadyr.org
# Liscense: GNU GENERAL PUBLIC LICENSE
# 


require 'syslog'
require 'rubygems'
require 'agi'


log = Syslog.open("call_log.rb")
agi = AGI.new

log.warning("#{agi.callerid} <#{agi.calleridname}>")
