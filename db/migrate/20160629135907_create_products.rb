class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :sku, null: false

      t.index :sku, unique: true
    end
  end
end
