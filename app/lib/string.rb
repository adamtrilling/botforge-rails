class String
  def all_indexes(substr)
    i = -1
    all = []
    while i = self.index(substr,i+1)
      all << i
    end
    all
  end

  def find_chars_where(&block)
    all = []
    (0..self.size - 1).each do |i|
      all << i if yield self.send(:[], i)
    end
    all
  end
end