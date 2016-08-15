module TestApp
  module Shared

    def wait_for_text_in_view(text, mark)
      query = "* marked:'#{mark}'"
      actual = wait_for_view(query).first["text"]
      if actual != text
        fail %Q[
Expected query:

#{query}

to return a view with the correct text:

  Actual: #{actual}
Expected: #{text}

]
      end
    end

  end
end

World(TestApp::Shared)

Given(/^the app has launched$/) do
  wait_for do
    !query("*").empty?
  end

  if keyboard_visible?
    ['textField', 'textView'].each do |ui_class|
      query = "#{ui_class} isFirstResponder:1"
      if !query(query).empty?
        query(query, :resignFirstResponder)
      end
    end

    wait_for_no_keyboard
  end
end

Given(/^I am looking at the (Touch|Pan|Rotate\/Pinch|Misc|Tao) tab$/) do |tabname|
  query = "* marked:'#{tabname}'"
  wait_for_view(query)
  touch(query)
end
