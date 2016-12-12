require_relative 'query.rb'
require 'active_support/inflector'
require 'sqlite3'
require 'csv'
require 'pry'

DB = {:conn => SQLite3::Database.new("../db/guests.db")}
DB[:conn].execute("DROP TABLE IF EXISTS guests")
sql = <<-SQL
  CREATE TABLE IF NOT EXISTS guests (
  id INTEGER PRIMARY KEY,
  years INTEGER,
  googleknowlege_occupations TEXT,
  shows TEXT,
  groups TEXT,
  raw_guest_lists TEXT
)
SQL
DB[:conn].execute(sql)

class Guest < Query

  def self.get_from_csv
    CSV.read('../daily_show_guests.csv')
  end

  def self.create_db
    keys = get_from_csv.shift.map {|key| key.downcase.pluralize}
    array = get_from_csv.drop(1).map do |arr|
      if arr[4].include?("\'")
        arr[4].gsub!("\'", "")
        arr
      else
        arr
      end
    end
    array.each {|row| self.create(row)}
  end

  attr_accessor :years, :googleknowlege_occupations, :shows, :groups, :raw_guest_lists, :id

  def initialize(row, id=nil)
    @id = id
    @years = row[0]
    @googleknowlege_occupations = row[1]
    @shows = row[2]
    @groups = row[3]
    @raw_guest_lists = row[4]
  end

  def self.create(row)
    guest = Guest.new(row)
    guest.save
    guest
  end

  def self.create_table
    sql =  <<-SQL
    CREATE TABLE IF NOT EXISTS guests (
    id INTEGER PRIMARY KEY,
    years INTEGER,
    googleknowlege_occupations TEXT,
    shows TEXT,
    groups TEXT,
    raw_guest_lists TEXT
  )
  SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql =  <<-SQL
      DROP TABLE guests
        SQL
    DB[:conn].execute(sql)
  end

  def save
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO guests (years, googleknowlege_occupations, shows, groups,raw_guest_lists)
        VALUES (?, ?, ?, ?, ?)
      SQL
      DB[:conn].execute(sql, self.years, self.googleknowlege_occupations, self.shows, self.groups, self.raw_guest_lists)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM guests")[0][0]
      self
     end
  end

  def update
    sql = "UPDATE guests SET years = ?, googleknowlege_occupations = ?, shows = ?, groups = ?, raw_guest_lists = ? WHERE id = ?"
    DB[:conn].execute(sql, self.years, self.googleknowlege_occupations, self.shows, self.groups, self.raw_guest_lists)
  end

  def self.find_by_id(id)
    Guest.all.select {|guest| guest if guest.id == id}.first
  end

end
