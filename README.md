# Ruby Language API for Asterisk

This is a fork of the original ruby-agi version 1.1.2 code, which is located @ rubyforge.

This library comes with absolutely no warranty. Agi is a library to write AGI scripts in ruby language for Asterisk. agi does not depend of Asterisk Manager.

Here are a sites that may help to know more about agi
http://agi.rubyforge.org           (agi homepage)

## Installation

Install from githib:

    git clone git@github.com:gordienko/agi.git
    cd agi
    gem build agi.gemspec
    gem install agi-<version>.gem
    
Add this line to your application's Gemfile:

    gem 'agi'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install agi

## AGI example

Here’s the dialplan that goes with this AGI script:

    [default]
        exten => 1234,1,AGI(informer.rb)

Example AGI script /var/lib/asterisk/agi-bin/informer.rb
 
    #!/bin/env ruby
    
    require 'agi'
    require 'dbi'
   
    agi = AGI.new
    dbh = DBI.connect(...)
    
    timeout = 10
    
    agi.answer
    agi.stream_file("welсome", nil)
    agi.verbose("informer: %s" % agi.callerid)
    
    if agi.wait_for_digits('listen_balance_account',timeout, 1).result.to_i == 1
        loop do
            account_number = agi.wait_for_digits('enter-account-number',timeout, 9).result
            account = dbh.select_one("select balance from accounts where number = '#{account_number}'")
            if account.nil?
                agi.stream_file('account-not-found', nil)
            else
                agi.stream_file('say-balance', nil)
                agi.say_digits(account[0])
                balance_another_account = agi.wait_for_digits('balance_another_account',timeout, 1).result.to_i 
                break unless balance_another_account == 1
            end
        end
    end
    
    agi.stream_file('goodbay', nil)
    agi.hangup

## Contributing

1. Fork it ( http://github.com/gordienko/agi/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
