# -----------------------------------------------------------------------------
#
# Mysql2Spatial adapter for ActiveRecord
#
# -----------------------------------------------------------------------------
# Copyright 2010 Daniel Azuma
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

# :stopdoc:

module ActiveRecord
  module ConnectionAdapters
    module Mysql2SpatialAdapter
      class MainAdapter < ConnectionAdapters::Mysql2Adapter

        NATIVE_DATABASE_TYPES = Mysql2Adapter::NATIVE_DATABASE_TYPES.merge(spatial: { name: 'geometry' })

        def initialize(*args_)
          super
          if defined?(@visitor) && @visitor
            @visitor = ::Arel::Visitors::MySQL2Spatial.new(self)
          end
        end

        def adapter_name
          Mysql2SpatialAdapter::ADAPTER_NAME
        end

        def spatial_column_constructor(name)
          ::RGeo::ActiveRecord.geometric_type_from_name(name)
        end

        def native_database_types
          NATIVE_DATABASE_TYPES
        end

        def quote(value_)
          value_ = value_.value_for_database if value_.respond_to?(:value_for_database)
          if ::RGeo::Feature::Geometry.check_type(value_)
            "GeomFromWKB(0x#{::RGeo::WKRep::WKBGenerator.new(hex_format: true).generate(value_)},#{value_.srid})"
          else
            super
          end
        end

        def type_to_sql(type_, limit: nil, precision: nil, scale: nil, unsigned: nil, **)
          if (info_ = spatial_column_constructor(type_.to_sym))
            type_ = limit[:type] || type_ if limit.is_a?(::Hash)
            type_ = 'geometry' if type_.to_s == 'spatial'
            type_ = type_.to_s.gsub('_', '').upcase
          end
          super
        end

        def add_index(table_name_, column_name_, options_ = {})
          if options_[:spatial]
            index_name_ = index_name(table_name_, column: Array(column_name_))
            if ::Hash === options_
              index_name_ = options_[:name] || index_name_
            end
            execute "CREATE SPATIAL INDEX #{index_name_} ON #{table_name_} (#{Array(column_name_).join(", ")})"
          else
            super
          end
        end

        def columns(table_name_, name_ = nil)
          result_ = @connection.query "SHOW FULL FIELDS FROM #{quote_table_name(table_name_)}"
          columns_ = []
          result_.each(symbolize_keys: true, as: :hash) do |field_|
            type_metadata = fetch_type_metadata(field_[:Type], field_[:Extra])
            columns_ << SpatialColumn.new(field_[:Field], field_[:Default], type_metadata, field_[:Null] == 'YES', collation: field_[:Collation])
          end
          columns_
        end

        protected

        def initialize_type_map(m = type_map)
          super
          register_class_with_limit m, %r(geometry)i, ActiveModel::Type::Spatial
          m.alias_type %r(point)i, 'geometry'
          m.alias_type %r(linestring)i, 'geometry'
          m.alias_type %r(polygon)i, 'geometry'
        end

      end
    end
  end
end

# :startdoc:
