# -----------------------------------------------------------------------------
#
# MySQL2 Spatial ActiveRecord Adapter Gemspec
#
# -----------------------------------------------------------------------------
# Copyright 2011-2012 Daniel Azuma
#
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice,
#   this list of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
# * Neither the name of the copyright holder, nor the names of any other
#   contributors to this software, may be used to endorse or promote products
#   derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
# -----------------------------------------------------------------------------


::Gem::Specification.new do |spec|
  spec.name = 'activerecord-mysql2spatial-adapter'
  spec.summary = 'An ActiveRecord adapter for MySQL Spatial Extensions, based on RGeo and the mysql2 gem.'
  spec.description = 'This is an ActiveRecord connection adapter for MySQL Spatial Extensions. It is based on the stock MySQL2 adapter, but provides built-in support for spatial columns. It uses the RGeo library to represent spatial data in Ruby.'
  spec.version = "#{::File.read('Version').strip}"
  spec.authors = ['Daniel Azuma', 'fjl82']
  spec.homepage = 'https://github.com/fjl82/activerecord-mysql2spatial-adapter'
  spec.required_ruby_version = '>= 2.5.0'
  spec.files = ::Dir.glob('lib/**/*.rb') +
    ::Dir.glob('test/**/*.rb') +
    ::Dir.glob('*.rdoc') +
    ['Version']
  spec.extra_rdoc_files = ::Dir.glob('*.rdoc')
  spec.test_files = ::Dir.glob('test/**/tc_*.rb')
  spec.platform = ::Gem::Platform::RUBY

  spec.add_dependency('rgeo-activerecord', '>= 6.0', '< 7.0')
  spec.add_dependency('mysql2', '>= 0.5.0', '< 0.6')
end
