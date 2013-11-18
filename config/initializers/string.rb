class String
  def |(what)
    self.strip.blank? ? what : self
  end

  def pref(s)
    self.strip.blank? ? '' : s + ' ' + self
  end
end