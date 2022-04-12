# Theme configuration file
# ========================
# This file is used for all theme configuration.
# It's where you define everything that's editable in Spina CMS.

Spina::Theme.register do |theme|
  # All views are namespaced based on the theme's name
  theme.name = 'default'
  theme.title = 'Default Theme'

  # Parts
  # Define all editable parts you want to use in your view templates
  #
  # Built-in part types:
  # - Line
  # - MultiLine
  # - Text (Rich text editor)
  # - Image
  # - ImageCollection
  # - Attachment
  # - Option
  # - Repeater
  theme.parts = [
    # Home Specials
    { name: 'home_heading', title: I18n.t('theme.parts.home_heading.title'), part_type: "Spina::Parts::Line", hint: I18n.t('theme.parts.home_heading.hint') },
    { name: 'home_text', title: I18n.t('theme.parts.home_text.title'), part_type: "Spina::Parts::MultiLine", hint: I18n.t('theme.parts.home_text.hint') },
    { name: 'thumbnail', title: I18n.t('theme.parts.thumbnail.title'), part_type: "Spina::Parts::Image", hint: I18n.t('theme.parts.thumbnail.hint') },
    { name: 'home_welcome', title: I18n.t('theme.parts.home_welcome.title'), part_type: "Spina::Parts::Line", hint: I18n.t('theme.parts.home_welcome.hint') },

    # Layout Specials
    { name: 'footer', title: I18n.t('theme.parts.footer.title'), part_type: "Spina::Parts::Text", hint: I18n.t('theme.parts.footer.hint') },
    { name: 'footer_text', title: I18n.t('theme.parts.footer_text.title'), part_type: "Spina::Parts::MultiLine", hint: I18n.t('theme.parts.footer_text.hint') },

    # # Repeater Parts
    { name: 'single_tag_selector', title: I18n.t('theme.parts.single_tag_selector.title'), part_type: "Spina::Parts::Tag", hint: I18n.t('theme.parts.single_tag_selector.hint') },
    { name: 'single_project_selector', title: I18n.t('theme.parts.single_project_selector.title'), part_type: "Spina::Parts::Project", hint: I18n.t('theme.parts.single_project_selector.hint') },
    { name: 'single_article_selector', title: I18n.t('theme.parts.single_article_selector.title'), part_type: "Spina::Parts::Article", hint: I18n.t('theme.parts.single_article_selector.hint') },

    # SECTIONS
    # Dynamic Contents
    { name: 'image', title: I18n.t('theme.parts.image.title'), part_type: "Spina::Parts::Image", hint: I18n.t('theme.parts.image.hint') },
    { name: 'images', title: I18n.t('theme.parts.images.title'), part_type: "Spina::Parts::ImageCollection", hint: I18n.t('theme.parts.images.hint') },
    { name: 'tags', title: I18n.t('theme.parts.tags.title'), part_type: "Spina::Parts::Repeater", parts: %w(single_tag_selector), hint: I18n.t('theme.parts.tags.hint') },
    { name: 'skills', title: I18n.t('theme.parts.skills.title'), part_type: "Spina::Parts::Repeater", parts: %w(single_tag_selector), hint: I18n.t('theme.parts.skills.hint') },
    { name: 'projects', title: I18n.t('theme.parts.projects.title'), part_type: "Spina::Parts::Repeater", parts: %w(single_project_selector), hint: I18n.t('theme.parts.projects.hint') },
    { name: 'articles', title: I18n.t('theme.parts.articles.title'), part_type: "Spina::Parts::Repeater", parts: %w(single_article_selector), hint: I18n.t('theme.parts.articles.hint') },
    { name: 'rich', title: I18n.t('theme.parts.rich.title'), part_type: "Spina::Parts::Text", hint: I18n.t('theme.parts.rich.hint') },

    # Main Section
    { name: 'heading', title: I18n.t('theme.parts.heading.title'), part_type: "Spina::Parts::MultiLine", hint: I18n.t('theme.parts.heading.hint') },
    { name: 'text_before', title: I18n.t('theme.parts.text_before.title'), part_type: "Spina::Parts::MultiLine", hint: I18n.t('theme.parts.text_before.hint') },
    { name: 'dynamic', title: I18n.t('theme.parts.dynamic.title'), part_type: "Spina::Parts::Dynamic", parts: %w(image images tags skills projects articles rich), hint: I18n.t('theme.parts.dynamic.hint') },
    { name: 'text_after', title: I18n.t('theme.parts.text_after.title'), part_type: "Spina::Parts::MultiLine", hint: I18n.t('theme.parts.text_after.hint') },

    # Section Repeater
    { name: 'sections_repeater', title: I18n.t('theme.parts.sections_repeater.title'), part_type: "Spina::Parts::Repeater", parts: %w(heading text_before dynamic text_after), hint: I18n.t('theme.parts.sections_repeater.hint') },
  ]

  # View templates
  # Every page has a view template stored in app/views/my_theme/pages/*
  # You define which parts you want to enable for every view template
  # by referencing them from the theme.parts configuration above.
  theme.view_templates = [
    { name: 'homepage', title: I18n.t('theme.homepage'), parts: %w(home_heading home_text home_welcome thumbnail sections_repeater) },
    { name: 'articles', title: I18n.t('theme.articles'), parts: %w(sections_repeater) },
    { name: 'projects', title: I18n.t('theme.projects'), parts: %w(sections_repeater) },
    { name: 'snake', title: I18n.t('theme.snake_template'), parts: %w(thumbnail sections_repeater) },
    { name: 'page', title: I18n.t('theme.page_template'), parts: %w(thumbnail sections_repeater) },
  ]

  # Custom pages
  # Some pages should not be created by the user, but generated automatically.
  # By naming them you can reference them in your code.
  theme.custom_pages = [
    { name: 'homepage', title: I18n.t('theme.homepage'), deletable: false, view_template: "homepage" },
    { name: 'articles', title: I18n.t('theme.articles'), deletable: false, view_template: "articles" },
    { name: 'projects', title: I18n.t('theme.projects'), deletable: false, view_template: "projects" },
  ]

  # Navigations (optional)
  # If your project has multiple navigations, it can be useful to configure multiple
  # navigations.
  theme.navigations = [
    {name: 'main', label: I18n.t('theme.mainmenu')}
  ]

  # Layout parts (optional)
  # You can create global content that doesn't belong to one specific page. We call these layout parts.
  # You only have to reference the name of the parts you want to have here.
  theme.layout_parts = %w(footer_text footer)

  # Resources (optional)
  # Think of resources as a collection of pages. They are managed separately in Spina
  # allowing you to separate these pages from the 'main' collection of pages.
  theme.resources = [
    { name: "articles", label: I18n.t('theme.articles'), view_template: "resource_template", slug_en: I18n.t('theme.articles', locale: :en), slug_de: I18n.t('theme.articles', locale: :de), order_by: "" },
    { name: "projects", label: I18n.t('theme.projects'), view_template: "resource_template", slug_en: I18n.t('theme.projects', locale: :en), slug_de: I18n.t('theme.projects', locale: :de), order_by: "" },
    { name: "tags", label: I18n.t('theme.tags'), view_template: "default_template", slug_en: I18n.t('theme.tags', locale: :en), slug_de: I18n.t('theme.tags', locale: :de), order_by: "" },
  ]

  # Plugins (optional)
  theme.plugins = []

  # Embeds (optional)
  theme.embeds = []
end
