# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "alembic-jekyll-theme"
  spec.version       = "3.1.0"
  spec.authors       = ["Ozer Gul"]
  spec.email         = ["ozergul@yandex.com"]

  spec.summary       = %q{Yet another front-end developer from Istanbul.}
  spec.description   = "Yet another front-end developer from Istanbul."
  spec.homepage      = "https://ozergul.net"
  spec.license       = "MIT"

  spec.metadata["plugin_type"] = "theme"

  spec.files         = `git ls-files -z`.split("\x0").select { |f| f.match(%r{^(assets|_layouts|_includes|_sass|LICENSE|README|sw|manifest)}i) }

  spec.add_runtime_dependency "jekyll", "~> 3.8"
  spec.add_runtime_dependency "jekyll-sitemap", "~> 0.13"
  spec.add_runtime_dependency "jekyll-mentions", "~> 1.2"
  spec.add_runtime_dependency "jekyll-paginate", "~> 1.1"
  spec.add_runtime_dependency "jekyll-seo-tag", "~> 2.3"
  spec.add_runtime_dependency "jekyll-redirect-from", "~> 0.12"
  spec.add_runtime_dependency "jekyll-default-layout", "~> 0.1"
  spec.add_runtime_dependency "jekyll-feed", "~> 0.9"
  spec.add_runtime_dependency "jekyll-commonmark", "~> 1.2"
  spec.add_runtime_dependency "jekyll-include-cache", "~> 0.1"
  spec.add_runtime_dependency "jemoji", "~> 0.11"
end
