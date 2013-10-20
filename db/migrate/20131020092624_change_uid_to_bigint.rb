class ChangeUidToBigint < ActiveRecord::Migration
  def change

    add_column :users, :uid_int, :integer, :limit => 8
    
    User.all.each do |u|
      u.uid_int = u.uid.to_i
      u.save!
    end
    
    execute "alter table users drop column uid"
    execute "alter table users rename uid_int to uid"

  end
end
