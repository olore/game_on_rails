class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :home_team
      t.string :away_team
      t.datetime :date
      t.string :station

      t.timestamps
    end
  end
end
