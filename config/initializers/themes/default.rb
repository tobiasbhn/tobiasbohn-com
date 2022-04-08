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
    { name: 'home_welcome', title: I18n.t('theme.parts.home_welcome.title'), part_type: "Spina::Parts::Line", hint: I18n.t('theme.parts.home_welcome.hint') },
    { name: 'home_sub_heading', title: I18n.t('theme.parts.home_sub_heading.title'), part_type: "Spina::Parts::Line", hint: I18n.t('theme.parts.home_sub_heading.hint') },
    { name: 'home_introduction', title: I18n.t('theme.parts.home_introduction.title'), part_type: "Spina::Parts::MultiLine", hint: I18n.t('theme.parts.home_introduction.hint') },
    { name: 'home_main_image', title: I18n.t('theme.parts.home_main_image.title'), part_type: "Spina::Parts::Image", hint: I18n.t('theme.parts.home_main_image.hint') },
    { name: 'home_projects', title: I18n.t('theme.parts.home_projects.title'), part_type: "Spina::Parts::Text", hint: I18n.t('theme.parts.home_projects.hint') },
    { name: 'home_skills', title: I18n.t('theme.parts.home_skills.title'), part_type: "Spina::Parts::Text", hint: I18n.t('theme.parts.home_skills.hint') },

    { name: 'rich_content', title: I18n.t('theme.parts.rich_content.title'), part_type: "Spina::Parts::Text", hint: I18n.t('theme.parts.rich_content.hint') },
    { name: 'main_image', title: I18n.t('theme.parts.main_image.title'), part_type: "Spina::Parts::Image", hint: I18n.t('theme.parts.main_image.hint') },
    { name: 'image_collection', title: I18n.t('theme.parts.image_collection.title'), part_type: "Spina::Parts::ImageCollection", hint: I18n.t('theme.parts.image_collection.hint') },
    { name: 'single_tag_selector', title: I18n.t('theme.parts.single_tag_selector.title'), part_type: "Spina::Parts::Tag", hint: I18n.t('theme.parts.single_tag_selector.hint') },
    { name: 'tags_selector', title: I18n.t('theme.parts.tags_selector.title'), part_type: "Spina::Parts::Repeater", parts: %w(single_tag_selector), hint: I18n.t('theme.parts.tags_selector.hint') },
    { name: 'skills_selector', title: I18n.t('theme.parts.skills_selector.title'), part_type: "Spina::Parts::Repeater", parts: %w(single_tag_selector), hint: I18n.t('theme.parts.skills_selector.hint') },

    { name: 'footer', title: I18n.t('theme.parts.footer.title'), part_type: "Spina::Parts::Text", hint: I18n.t('theme.parts.footer.hint') },
    { name: 'footer_text', title: I18n.t('theme.parts.footer_text.title'), part_type: "Spina::Parts::MultiLine", hint: I18n.t('theme.parts.footer_text.hint') },
  ]

  # View templates
  # Every page has a view template stored in app/views/my_theme/pages/*
  # You define which parts you want to enable for every view template
  # by referencing them from the theme.parts configuration above.
  theme.view_templates = [
    { name: 'homepage', title: I18n.t('theme.homepage'), parts: %w(home_welcome home_sub_heading home_introduction home_main_image home_projects home_skills skills_selector) },
    { name: 'default_template', title: I18n.t('theme.default_template'), parts: %w(rich_content) },
    { name: 'page_template', title: I18n.t('theme.page_template'), parts: %w(rich_content) },
    { name: 'resource_template', title: I18n.t('theme.resource_template'), parts: %w(main_image tags_selector rich_content image_collection skills_selector) },
  ]

  # Custom pages
  # Some pages should not be created by the user, but generated automatically.
  # By naming them you can reference them in your code.
  theme.custom_pages = [
    { name: 'homepage', title: I18n.t('theme.homepage'), deletable: false, view_template: "homepage" },
    { name: 'legal', title: I18n.t('theme.legal'), deletable: false, view_template: "page_template" },
    { name: 'articles', title: I18n.t('theme.articles'), deletable: false, view_template: "page_template" },
    { name: 'projects', title: I18n.t('theme.projects'), deletable: false, view_template: "page_template" },
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
  theme.layout_parts = %w(footer footer_text)

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
