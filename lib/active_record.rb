require 'active_record/connection_adapter'

module ActiveRecord
  class Base
    class << self
      def class_name
        name.downcase + 's'
      end

      def all
        find_by_sql("SELECT * from #{class_name}")
      end

      def find(id)
        find_by_sql("SELECT * from #{class_name} WHERE id = #{id.to_i}").first
      end

      def establish_connection(options)
        @@connection = ConnectionAdapter::SqliteAdapter.new(options[:database])
      end

      def connection
        @@connection
      end

      def find_by_sql(sql)
        connection
          .execute(sql)
          .map do |attributes|
            new(attributes)
          end
      end

      def find_by_sql(sql)
        connection
          .execute(sql)
          .map do |attributes|
            new(attributes)
          end
      end

      def abstract_class=(value)
        # Not implemented
      end
    end

    def initialize(attributes = {})
      @attributes = attributes
    end

    def method_missing(name, *args)
      columns = self.class.connection.columns(self.class.class_name)
      if columns.include?(name)
        @attributes[name]
      else
        super
      end
    end
  end
end
