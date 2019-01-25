class RandomData
  class << self

    def digits(length)
      rand(10 ** length).to_s.rjust(length, "0")
    end

    def alphas(length)
      (0...length).map { (97 + rand(26)).chr }.join
    end
  end
end
