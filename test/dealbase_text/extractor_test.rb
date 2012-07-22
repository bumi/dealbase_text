require "test_helper"

class DealbaseText::ExtractorTest < MiniTest::Unit::TestCase
  include DealbaseText::Extractor

  CONFORMANCE_DIR = File.expand_path("../../", __FILE__)

  %w(description expected text json hits).each do |key|
    define_method key.to_sym do
      @test_info[key]
    end
  end

  def self.def_conformance_test(test_type, &block)
    yaml = YAML.load_file(File.join(CONFORMANCE_DIR, "test_cases.yml"))
    raise  "No such test suite: #{test_type.to_s}" unless yaml["tests"][test_type.to_s]

    yaml["tests"][test_type.to_s].each do |test_info|
      name = :"test_#{test_type}_#{test_info['description']}"
      define_method name do
        @test_info = test_info
        instance_eval(&block)
      end
    end
  end
  def_conformance_test(:mentions) do
    assert_equal expected, extract_mentioned_screen_names(text), description
  end

  def_conformance_test(:mentions_with_indices) do
    e = expected.map{|elem| elem.inject({}){|h, (k,v)| h[k.to_sym] = v; h} }
    assert_equal e, extract_mentioned_screen_names_with_indices(text), description
  end
end