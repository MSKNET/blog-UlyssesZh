# frozen_string_literal: true

require 'jekyll'
require 'json'

module Jekyll
	class RPGMapGenerator < Generator
		safe true
		def generate site
			Dir.chdir 'rpg'
			site.config['rpg-map']['enabled'].each do |dist|
				result = { dist => {} }
				build result[dist], Dir.new(dist)
				site.pages.push RPGMapJSON.new site, dist, result
			end
			Dir.chdir '..'
		end
		def build hash, dir
			dir.each_child do |child|
				if Dir.exist? file_name = "#{dir.path}/#{child}"
					build hash[child] = {}, Dir.new(file_name)
				else
					hash[child] = 'f'
				end
			end
		end
	end
	class RPGMapJSON < Page
		def initialize site, dist, hash
			@site = site
			@base = site.source
			@dir = File.join 'rpg', dist
			@name = 'map.json'
			process @name
			@data = {}
			@content = JSON.generate hash
		end
	end
end
