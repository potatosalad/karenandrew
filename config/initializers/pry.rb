# replace irb with pry
# rails console should use pry
silence_warnings do
  begin
    require 'pry'
    IRB = Pry
  rescue LoadError
  end
end