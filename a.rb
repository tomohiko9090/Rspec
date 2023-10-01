class Lottery
  KUJI = %w(あたり はずれ はずれ はずれ)
  def initialize
    @result = KUJI.sample
  end
  def win?
    @result == 'あたり'
  end
  def self.generate_results(count)
    Array.new(count){ self.new }
  end
end

results = Lottery.generate_results(2)
p results
win_count = results.count(&:win?)
p win_count
probability = win_count.to_f / 10000 * 100
p probability