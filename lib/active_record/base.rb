module ActiveRecord
  class Base
    class << self
      def table_name
        name.downcase + 's'
      end

      def all
        Relation.new(self)
      end

      def where(*args)
        all.where(*args)
      end

      def find(id)
        all.where("id = #{id.to_i}").first
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

      def abstract_class=(value)
        # Not implemented
      end
    end

    def initialize(attributes = {})
      @attributes = attributes
    end

    def method_missing(name, *args)
      columns = self.class.connection.columns(self.class.table_name)
      if columns.include?(name)
        @attributes[name]
      else
        super
      end
    end
  end
end
