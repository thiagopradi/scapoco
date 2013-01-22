class Scapoco::BulkInsert
  attr_accessor :model, :data

  def initialize(model)
    self.model = model
    self.data  = []
  end

  def save!
    execute(insert_sql)
  end

  def attribute_list
    @attribute_list ||= model.column_names.delete_if {|attr| ['created_at', 'updated_at', 'id'].include?(attr) }.sort
  end

  def values_for_insert
    sql = []

    data.each do |values|
      new_arr = []

      attribute_list.each do |attr|
        new_arr << cast_value(values[attr.to_sym])
      end

      new_arr << ["'#{Time.now.utc.to_formatted_s(:db)}'", "'#{Time.now.utc.to_formatted_s(:db)}'"]

      sql << '(' + new_arr.join(', ') + ')'
    end

    sql.join(', ')
  end

  def cast_value(value)
    if value.is_a? String
      "'#{value}'"
    elsif value.is_a? Date
      "'#{value.to_formatted_s(:db)}'"
    else
      value.to_s
    end
  end

  private
  def execute(sql)
    ActiveRecord::Base.connection.execute(sql)
  end

  def insert_sql
    "INSERT INTO #{model.table_name} (#{ (attribute_list.dup +  ['created_at', 'updated_at']).join(',')})
     VALUES #{values_for_insert};"
  end
end
