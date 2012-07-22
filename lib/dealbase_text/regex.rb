# encoding: UTF-8

# shamelessly stolen from https://github.com/twitter/twitter-text-rb/blob/master/lib/twitter-text/regex.rb
module DealbaseText
  class Regex
    REGEXEN = {} # :nodoc:

    def self.regex_range(from, to = nil) # :nodoc:
      if $RUBY_1_9
        if to
          "\\u{#{from.to_s(16).rjust(4, '0')}}-\\u{#{to.to_s(16).rjust(4, '0')}}"
        else
          "\\u{#{from.to_s(16).rjust(4, '0')}}"
        end
      else
        if to
          [from].pack('U') + '-' + [to].pack('U')
        else
          [from].pack('U')
        end
      end
    end

    # Space is more than %20, U+3000 for example is the full-width space used with Kanji. Provide a short-hand
    # to access both the list of characters and a pattern suitible for use with String#split
    #  Taken from: ActiveSupport::Multibyte::Handlers::UTF8Handler::UNICODE_WHITESPACE
    UNICODE_SPACES = [
          (0x0009..0x000D).to_a,  # White_Space # Cc   [5] <control-0009>..<control-000D>
          0x0020,          # White_Space # Zs       SPACE
          0x0085,          # White_Space # Cc       <control-0085>
          0x00A0,          # White_Space # Zs       NO-BREAK SPACE
          0x1680,          # White_Space # Zs       OGHAM SPACE MARK
          0x180E,          # White_Space # Zs       MONGOLIAN VOWEL SEPARATOR
          (0x2000..0x200A).to_a, # White_Space # Zs  [11] EN QUAD..HAIR SPACE
          0x2028,          # White_Space # Zl       LINE SEPARATOR
          0x2029,          # White_Space # Zp       PARAGRAPH SEPARATOR
          0x202F,          # White_Space # Zs       NARROW NO-BREAK SPACE
          0x205F,          # White_Space # Zs       MEDIUM MATHEMATICAL SPACE
          0x3000,          # White_Space # Zs       IDEOGRAPHIC SPACE
    ].flatten.map{|c| [c].pack('U*')}.freeze
    REGEXEN[:spaces] = /[#{UNICODE_SPACES.join('')}]/o

    # Character not allowed in Tweets
    INVALID_CHARACTERS = [
      0xFFFE, 0xFEFF, # BOM
      0xFFFF,         # Special
      0x202A, 0x202B, 0x202C, 0x202D, 0x202E # Directional change
    ].map{|cp| [cp].pack('U') }.freeze
    REGEXEN[:invalid_control_characters] = /[#{INVALID_CHARACTERS.join('')}]/o

    # Latin accented characters
    # Excludes 0xd7 from the range (the multiplication sign, confusable with "x").
    # Also excludes 0xf7, the division sign
    LATIN_ACCENTS = [
          regex_range(0xc0, 0xd6),
          regex_range(0xd8, 0xf6),
          regex_range(0xf8, 0xff),
          regex_range(0x0100, 0x024f),
          regex_range(0x0253, 0x0254),
          regex_range(0x0256, 0x0257),
          regex_range(0x0259),
          regex_range(0x025b),
          regex_range(0x0263),
          regex_range(0x0268),
          regex_range(0x026f),
          regex_range(0x0272),
          regex_range(0x0289),
          regex_range(0x028b),
          regex_range(0x02bb),
          regex_range(0x0300, 0x036f),
          regex_range(0x1e00, 0x1eff)
    ].join('').freeze

    NON_LATIN_HASHTAG_CHARS = [
      # Cyrillic (Russian, Ukrainian, etc.)
      regex_range(0x0400, 0x04ff), # Cyrillic
      regex_range(0x0500, 0x0527), # Cyrillic Supplement
      regex_range(0x2de0, 0x2dff), # Cyrillic Extended A
      regex_range(0xa640, 0xa69f), # Cyrillic Extended B
      regex_range(0x0591, 0x05bf), # Hebrew
      regex_range(0x05c1, 0x05c2),
      regex_range(0x05c4, 0x05c5),
      regex_range(0x05c7),
      regex_range(0x05d0, 0x05ea),
      regex_range(0x05f0, 0x05f4),
      regex_range(0xfb12, 0xfb28), # Hebrew Presentation Forms
      regex_range(0xfb2a, 0xfb36),
      regex_range(0xfb38, 0xfb3c),
      regex_range(0xfb3e),
      regex_range(0xfb40, 0xfb41),
      regex_range(0xfb43, 0xfb44),
      regex_range(0xfb46, 0xfb4f),
      regex_range(0x0610, 0x061a), # Arabic
      regex_range(0x0620, 0x065f),
      regex_range(0x066e, 0x06d3),
      regex_range(0x06d5, 0x06dc),
      regex_range(0x06de, 0x06e8),
      regex_range(0x06ea, 0x06ef),
      regex_range(0x06fa, 0x06fc),
      regex_range(0x06ff),
      regex_range(0x0750, 0x077f), # Arabic Supplement
      regex_range(0x08a0),         # Arabic Extended A
      regex_range(0x08a2, 0x08ac),
      regex_range(0x08e4, 0x08fe),
      regex_range(0xfb50, 0xfbb1), # Arabic Pres. Forms A
      regex_range(0xfbd3, 0xfd3d),
      regex_range(0xfd50, 0xfd8f),
      regex_range(0xfd92, 0xfdc7),
      regex_range(0xfdf0, 0xfdfb),
      regex_range(0xfe70, 0xfe74), # Arabic Pres. Forms B
      regex_range(0xfe76, 0xfefc),
      regex_range(0x200c, 0x200c), # Zero-Width Non-Joiner
      regex_range(0x0e01, 0x0e3a), # Thai
      regex_range(0x0e40, 0x0e4e), # Hangul (Korean)
      regex_range(0x1100, 0x11ff), # Hangul Jamo
      regex_range(0x3130, 0x3185), # Hangul Compatibility Jamo
      regex_range(0xA960, 0xA97F), # Hangul Jamo Extended-A
      regex_range(0xAC00, 0xD7AF), # Hangul Syllables
      regex_range(0xD7B0, 0xD7FF), # Hangul Jamo Extended-B
      regex_range(0xFFA1, 0xFFDC)  # Half-width Hangul
    ].join('').freeze
    REGEXEN[:latin_accents] = /[#{LATIN_ACCENTS}]+/o

    CJ_HASHTAG_CHARACTERS = [
      regex_range(0x30A1, 0x30FA), regex_range(0x30FC, 0x30FE), # Katakana (full-width)
      regex_range(0xFF66, 0xFF9F), # Katakana (half-width)
      regex_range(0xFF10, 0xFF19), regex_range(0xFF21, 0xFF3A), regex_range(0xFF41, 0xFF5A), # Latin (full-width)
      regex_range(0x3041, 0x3096), regex_range(0x3099, 0x309E), # Hiragana
      regex_range(0x3400, 0x4DBF), # Kanji (CJK Extension A)
      regex_range(0x4E00, 0x9FFF), # Kanji (Unified)
      regex_range(0x20000, 0x2A6DF), # Kanji (CJK Extension B)
      regex_range(0x2A700, 0x2B73F), # Kanji (CJK Extension C)
      regex_range(0x2B740, 0x2B81F), # Kanji (CJK Extension D)
      regex_range(0x2F800, 0x2FA1F), regex_range(0x3003), regex_range(0x3005), regex_range(0x303B) # Kanji (CJK supplement)
    ].join('').freeze

    PUNCTUATION_CHARS = '!"#$%&\'()*+,-./:;<=>?@\[\]^_\`{|}~'
    SPACE_CHARS = " \t\n\x0B\f\r"
    CTRL_CHARS = "\x00-\x1F\x7F"

    # A hashtag must contain latin characters, numbers and underscores, but not all numbers.
    HASHTAG_ALPHA = /[a-z_#{LATIN_ACCENTS}#{NON_LATIN_HASHTAG_CHARS}#{CJ_HASHTAG_CHARACTERS}]/io
    HASHTAG_ALPHANUMERIC = /[a-z0-9_#{LATIN_ACCENTS}#{NON_LATIN_HASHTAG_CHARS}#{CJ_HASHTAG_CHARACTERS}]/io
    HASHTAG_BOUNDARY = /\A|\z|[^&a-z0-9_#{LATIN_ACCENTS}#{NON_LATIN_HASHTAG_CHARS}#{CJ_HASHTAG_CHARACTERS}]/o

    HASHTAG = /(#{HASHTAG_BOUNDARY})(#|＃)(#{HASHTAG_ALPHANUMERIC}*#{HASHTAG_ALPHA}#{HASHTAG_ALPHANUMERIC}*)/io

    REGEXEN[:valid_hashtag] = /#{HASHTAG}/io
    # Used in Extractor for final filtering
    REGEXEN[:end_hashtag_match] = /\A(?:[#＃]|:\/\/)/o

    REGEXEN[:valid_mention_preceding_chars] = /(?:[^a-zA-Z0-9_!#\$%&*@＠]|^|RT:?)/o
    REGEXEN[:at_signs] = /[@＠]/
    REGEXEN[:valid_mention] = /
      (#{REGEXEN[:valid_mention_preceding_chars]})  # $1: Preceeding character
      (#{REGEXEN[:at_signs]})                       # $2: At mark
      ([a-zA-Z0-9_]{1,20})                          # $3: Screen name
    /ox
    REGEXEN[:valid_reply] = /^(?:#{REGEXEN[:spaces]})*#{REGEXEN[:at_signs]}([a-zA-Z0-9_]{1,20})/o
    # Used in Extractor for final filtering
    REGEXEN[:end_mention_match] = /\A(?:#{REGEXEN[:at_signs]}|#{REGEXEN[:latin_accents]}|:\/\/)/o

    REGEXEN.each_pair{|k,v| v.freeze }

    # Return the regular expression for a given <tt>key</tt>. If the <tt>key</tt>
    # is not a known symbol a <tt>nil</tt> will be returned.
    def self.[](key)
      REGEXEN[key]
    end
  end
end