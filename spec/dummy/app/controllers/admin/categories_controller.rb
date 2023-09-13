module Admin
  class CategoriesController < Wallaby::ResourcesController
    add_mapping_actions(member_edit: 'form', collection_list: 'index')

    def collection_list
      index!(template: :index, prefixes: wallaby_prefixes)
    end

    def member_edit
      flash.now[:notice] = "member_edit for #{self.class.name}"
      edit!
    end

    def member_update
      flash.now[:notice] = "member_update for #{self.class.name}"
      update! location: { action: :member_edit }
    end
  end
end
