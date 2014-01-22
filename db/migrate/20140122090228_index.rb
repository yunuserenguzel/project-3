class Index < ActiveRecord::Migration
  def change
    CREATE INDEX trgm_idx ON sonics USING gist (tags gist_trgm_ops);
    
  end
end
