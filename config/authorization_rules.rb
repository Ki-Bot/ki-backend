privileges do

  privilege :rest do
    includes :index, :show, :new, :create, :edit, :update, :destroy, :delete
  end

end

authorization do

  role :super_user do
    has_permission_on :users, :points, to: [:rest]
  end

end