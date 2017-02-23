module ActiveRecord
  class Relation
    def initialize(klass)
      @klass = klass
      @where_values = []
    end

    def where!(where_value)
      @where_values << where_value
      self
    end

    def where(where_value)
      clone.where!(where_value)
    end

    def to_sql
      sql = "SELECT * FROM #{@klass.table_name}"
      if @where_values.any?
        sql += " WHERE " + @where_values.join(' AND ')
      end
      sql
    end

    def records
      @records ||= @klass.find_by_sql(to_sql)
    end

    def first
      records.first
    end

    def each(&block)
      records.each(&block)
    end
  end
end
