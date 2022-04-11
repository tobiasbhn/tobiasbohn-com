# Load Custom Parts for Spina
Rails.application.reloader.to_prepare do
  Spina::Part.register(Spina::Parts::Tag)
  Spina::Part.register(Spina::Parts::Project)
  Spina::Part.register(Spina::Parts::Article)
  Spina::Part.register(Spina::Parts::Dynamic)
end
