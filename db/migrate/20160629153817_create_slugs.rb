class CreateSlugs < ActiveRecord::Migration
  def change
    create_table :slugs do |t|
      t.references :resource, index: true, polymorphic: true, null: false
      t.boolean :active, null: false, default: true
      t.string :slug_prefix, null: false, default: ''
      t.string :slug, null: false
      t.string :computed_slug, null: false
      t.timestamps

      t.index :computed_slug, unique: true, where: "active = true"
      t.index :computed_slug
    end
  end
end
