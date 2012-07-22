# DealbaseText

stolen from https://github.com/twitter/twitter-text-rb/blob/master/lib/twitter-text/extractor.rb to extract screen names from any given text


## Usage

    DealbaseText::Extractor.new(text).screen_names
    
    DealbaseText::Extractor.new(text).screen_names do |sceen_name| ... end
    
    DealbaseText::Extractor.new(text).screen_names_with_indices
    
    DealbaseText::Extractor.new(text).screen_names_with_indices do |sceen_name, begin_char_index, end_char_index| ... end


## Installation

Add this line to your application's Gemfile:

    gem 'dealbase_text'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dealbase_text
