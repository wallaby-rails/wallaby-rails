module Wallaby
  module Resources
    module Index
      class HasManyHtml < Cell
        def render
          unique_collection = value.uniq
          concat raw unique_collection.first(2).map { |item| show_link item, options: { readonly: true } }.join(', ')
          if unique_collection.length > 2
            title = metadata[:label]
            body = unique_collection.map { |item| show_link item, options: { readonly: true } }.to_sentence.html_safe
            label = "#{unique_collection.length - 2} more"
            concat 'and'
            imodal title, body, label: label
          elsif unique_collection.blank?
            null
          end
        end
      end
    end
  end
end
