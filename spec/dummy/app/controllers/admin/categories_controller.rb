# frozen_string_literal: true

module Admin
  class CategoriesController < Admin::ApplicationController
    add_mapping_actions(member_edit: 'form', collection_list: 'index')

    def member_only
      render plain: "This is a member only action for #{self.class.name}"
    end

    def collection_only
      render plain: "This is a collection only action for #{self.class.name}"
    end

    def links
      render json: {
        category: {
          index: index_path(Category),
          new: new_path(Category),
          show: show_path(Category.new(id: 1)),
          edit: edit_path(Category.new(id: 1))
        },
        product: {
          index: index_path(Product),
          new: new_path(Product),
          show: show_path(Product.new(id: 1)),
          edit: edit_path(Product.new(id: 1))
        }
      }
    end

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
