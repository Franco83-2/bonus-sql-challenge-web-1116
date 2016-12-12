class Query
  def self.all
    sql = <<-SQL
          SELECT *
          FROM guests
        SQL
    DB[:conn].execute(sql)
  end

  def self.on_the_most
    sql = <<-SQL
          SELECT raw_guest_lists
          FROM guests
          GROUP BY raw_guest_lists
          HAVING COUNT(*) = (
                            SELECT Max(Cnt)
                            FROM (
                                  SELECT COUNT(*) as Cnt
                                  FROM guests
                                  GROUP BY raw_guest_lists
                                ) tmp
                              )
        SQL
    DB[:conn].execute(sql)[0]
  end

  def self.professions(annual)
    sql = <<-SQL
    SELECT googleknowlege_occupations, COUNT(googleknowlege_occupations) AS jobs
    FROM guests
    WHERE years = #{annual}
    GROUP BY googleknowlege_occupations
    ORDER BY jobs DESC LIMIT 1
        SQL
    puts "Job: #{DB[:conn].execute(sql)[0][0].capitalize} with a total of #{DB[:conn].execute(sql)[0][1]} for the year #{annual}."

  end


  def self.popular_profession
    time = (1999..2015).to_a
    time.each {|annual| self.professions(annual)}
  end

  def self.number_of_bills
    sql = <<-SQL
        SELECT raw_guest_lists, COUNT(raw_guest_lists)
        AS cnt FROM guests
        WHERE raw_guest_lists LIKE '%Bill%'
        GROUP BY raw_guest_lists
        ORDER BY cnt DESC LIMIT 1
        SQL
    puts "Most Bills: #{DB[:conn].execute(sql)[0][0].capitalize} was on #{DB[:conn].execute(sql)[0][1]} times."
  end

  def self.patrick
    sql = <<-SQL
        SELECT shows, raw_guest_lists
        FROM guests
        WHERE raw_guest_lists LIKE '%patrick stewart%'
        GROUP BY shows
        ORDER BY shows ASC
        SQL
    dates = DB[:conn].execute(sql).map {|shows| shows[0]}
    puts "Patrick Stewart Dates: "
    dates.each_with_index {|date, index| puts "#{index+1}. #{date}"}
  end

  def self.most_guests
    sql = <<-SQL
          SELECT years
          FROM guests
          GROUP BY years
          HAVING COUNT(*) = (
                            SELECT Max(Cnt)
                            FROM (
                                  SELECT COUNT(*) as Cnt
                                  FROM guests
                                  GROUP BY years
                                ) tmp
                              )
        SQL
    puts "The year #{DB[:conn].execute(sql)[0][0]} had the most guests!"
  end


  def self.most_groups
    time = (1999..2015).to_a
    time.each {|annual| self.most_groups_annual(annual)}
  end

  def self.most_groups_annual(annual)
    sql = <<-SQL
    SELECT groups, COUNT(groups) AS jobs
    FROM guests
    WHERE years = #{annual}
    GROUP BY groups
    ORDER BY jobs DESC LIMIT 1
        SQL
    puts "The year #{annual},  #{DB[:conn].execute(sql)[0][0]} was the group with the most appearances, with a total of #{DB[:conn].execute(sql)[0][1]}!"
  end

end
