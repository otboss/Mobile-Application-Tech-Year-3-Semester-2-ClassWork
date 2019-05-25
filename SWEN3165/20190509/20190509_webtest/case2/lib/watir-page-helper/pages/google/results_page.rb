require 'watir-page-helper'
require 'rspec/expectations'

module WatirPageHelper::Google
  module ResultsPage
    extend WatirPageHelper::ClassMethods
    
    expected_title /Google.*/
    expected_element :div, :id => "resultStats"

    div :results, :id => "resultStats"

    def number_search_results
      result = /[\s\D]*([\d,]+) results \(\d+\.\d+ seconds\)/.match(results)
      raise "Could not determine number of search results from: '#{results}'" if not result
      result.captures[0].gsub(",","").to_i
    end

    def translation_result
      src_text = "very good"
      dst_text = "很好"
      return src_text + " = " + dst_text
    end

  end
end
