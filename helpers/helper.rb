require('pg')

class Helper

  def Helper.sql_run(sql, values = [])
    database_connection = PG.connect({dbname: 'cinema', host: 'localhost'})
    database_connection.prepare("query", sql)
    result = database_connection.exec_prepared("query", values)
    database_connection.close()
    return result
  end

  def Helper.map(array, class_name)
    return array.map{|object| class_name.new(object)} if array != nil
  end

  def Helper.sql_run_and_map(sql, values, class_name)
    return Helper.map(Helper.sql_run(sql, values), class_name)
  end

  def Helper.round(float_number, round_decimal = 2)
    return float_number.round(round_decimal)
  end

end
