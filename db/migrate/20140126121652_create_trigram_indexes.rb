class CreateTrigramIndexes < ActiveRecord::Migration
  def change
    execute "CREATE INDEX users_trgm_idx ON users USING gist (username gist_trgm_ops);"
    execute "CREATE INDEX sonics_trgm_idx ON sonics USING gist (tags gist_trgm_ops);"
  end
end
