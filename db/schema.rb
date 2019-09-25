# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_190_923_090_715) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'
  enable_extension 'postgis'

  create_table 'activities', force: :cascade do |t|
    t.string   'external_id'
    t.string   'athlete_id'
    t.string   'activity_type'
    t.string   'name'
    t.string   'description'
    t.string   'start_date'
    t.float    'distance'
    t.float    'average_speed'
    t.integer  'moving_time'
    t.integer  'elapsed_time'
    t.float    'average_heartrate'
    t.integer  'kudos_count'
    t.jsonb    'start_latlng'
    t.jsonb    'end_latlng'
    t.boolean  'commute'
    t.datetime 'created_at',                                                    null: false
    t.datetime 'updated_at',                                                    null: false
    t.geometry 'map', limit: { srid: 3785, type: 'line_string' }
    t.index ['external_id'], name: 'index_activities_on_external_id', unique: true, using: :btree
  end

  create_table 'race_events', force: :cascade do |t|
    t.integer  'race_id'
    t.integer  'year'
    t.date     'occured_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[race_id year], name: 'index_race_events_on_race_id_and_year', using: :btree
    t.index ['race_id'], name: 'index_race_events_on_race_id', using: :btree
  end

  create_table 'races', force: :cascade do |t|
    t.string   'name',       null: false
    t.string   'kind',       null: false
    t.string   'picture'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'users', force: :cascade do |t|
    t.string   'email',                  default: '', null: false
    t.string   'encrypted_password',     default: '', null: false
    t.string   'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.integer  'sign_in_count', default: 0, null: false
    t.datetime 'current_sign_in_at'
    t.datetime 'last_sign_in_at'
    t.string   'current_sign_in_ip'
    t.string   'last_sign_in_ip'
    t.datetime 'created_at',                          null: false
    t.datetime 'updated_at',                          null: false
    t.string   'provider'
    t.string   'uid'
    t.string   'authorization_token'
    t.index ['email'], name: 'index_users_on_email', unique: true, using: :btree
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true, using: :btree
    t.index ['uid'], name: 'index_users_on_uid', unique: true, using: :btree
  end

  add_foreign_key 'activities', 'users', column: 'athlete_id', primary_key: 'uid'
  add_foreign_key 'race_events', 'races'
end
