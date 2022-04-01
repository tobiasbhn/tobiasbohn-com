# Load Custom Parts for Spina
Rails.application.reloader.to_prepare do
  Spina::Part.register(Spina::Parts::Tag)
end
