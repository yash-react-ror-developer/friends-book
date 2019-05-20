ActiveAdmin.register User do

  index do
    column :first_name
    column :last_name
    actions
  end

  permit_params :activate

end
