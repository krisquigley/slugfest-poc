class CreateAdmin < ActiveRecord::Migration
  def change
    create_table :admin do |t|
      t.string :product_slug, null: false, default: 'products'
    end
  end
end
