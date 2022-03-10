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
  theme.parts = []

  # View templates
  # Every page has a view template stored in app/views/my_theme/pages/*
  # You define which parts you want to enable for every view template
  # by referencing them from the theme.parts configuration above.
  theme.view_templates = [
    { name: 'homepage', title: I18n.t('theme.homepage'), parts: %w() },
    { name: 'legal_template', title: I18n.t('theme.legal'), parts: %w() },
    { name: 'articles_template', title: I18n.t('theme.articles'), parts: %w() },
    { name: 'projects_template', title: I18n.t('theme.projects'), parts: %w() },

    { name: 'article_template', title: I18n.t('theme.article'), exclude_from: ["projects"], parts: %w() },
    { name: 'project_template', title: I18n.t('theme.project'), exclude_from: ["articles"], parts: %w() },
  ]

  # Custom pages
  # Some pages should not be created by the user, but generated automatically.
  # By naming them you can reference them in your code.
  theme.custom_pages = [
    {name: 'homepage', title: I18n.t('theme.homepage'), deletable: false, view_template: "homepage"},
    {name: 'legal', title: I18n.t('theme.legal'), deletable: false, view_template: "legal_template"},
    {name: 'articles', title: I18n.t('theme.articles'), deletable: false, view_template: "articles_template"},
    {name: 'projects', title: I18n.t('theme.projects'), deletable: false, view_template: "projects_template"},
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
  theme.layout_parts = []

  # Resources (optional)
  # Think of resources as a collection of pages. They are managed separately in Spina
  # allowing you to separate these pages from the 'main' collection of pages.
  theme.resources = [
    { name: "articles", label: I18n.t('theme.articles'), view_template: "article_template", slug_en: I18n.t('theme.articles', locale: :en), slug_de: I18n.t('theme.articles', locale: :de) },
    { name: "projects", label: I18n.t('theme.projects'), view_template: "project_template", slug_en: I18n.t('theme.projects', locale: :en), slug_de: I18n.t('theme.projects', locale: :de) },
  ]

  # Plugins (optional)
  theme.plugins = []

  # Embeds (optional)
  theme.embeds = []
end
