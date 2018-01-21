require "bundler"
require "pathname"
current_path = Pathname.pwd
relative_gem_paths = []
Bundler.load.specs.each do |gem|
  relative_gem_paths << Pathname.new(gem.full_gem_path).relative_path_from(current_path)
end
%x(ctags -R --languages=ruby --exclude=.git --exclude=log . #{relative_gem_paths.join(" ")})
