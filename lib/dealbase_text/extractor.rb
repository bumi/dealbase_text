# encoding: utf-8
module DealbaseText
  class Extractor
    attr_accessor :text

    def initialize(text)
      self.text = text
    end

    # stolen from https://github.com/twitter/twitter-text-rb/blob/master/lib/twitter-text/extractor.rb
    def screen_names(&block) # :yields: username
      @screen_names = screen_names_with_indices.map{|m| m[:screen_name]}
      @screen_names.each(&block) if block_given?
      @screen_names
    end
    # stolen from https://github.com/twitter/twitter-text-rb/blob/master/lib/twitter-text/extractor.rb
    def screen_names_with_indices
      return [] unless self.text

      possible_entries = []
      self.text.to_s.scan(DealbaseText::Regex[:valid_mention]) do |before, at, screen_name|
        match_data = $~
        after = $'
        unless after =~ DealbaseText::Regex[:end_mention_match]
          start_position = match_data.begin(3) - 1
          end_position = match_data.end(3)
          possible_entries << {
            :screen_name => screen_name,
            :indices => [start_position, end_position]
          }
        end
      end

      if block_given?
        possible_entries.each do |mention|
          yield mention[:screen_name], mention[:indices].first, mention[:indices].last
        end
      end

      possible_entries
    end
  end
end