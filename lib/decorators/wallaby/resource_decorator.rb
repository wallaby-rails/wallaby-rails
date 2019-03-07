module Wallaby
  # Resource Decorator
  # @see Wallaby::AbstractResourceDecorator
  # @see Wallaby::ModelDecorator
  class ResourceDecorator < AbstractResourceDecorator
    # @!attribute fields
    #   @scope class
    #   @param (see Wallaby::ModelDecorator#fields)
    #   @return (see Wallaby::ModelDecorator#fields)
    #   @see Wallaby::ModelDecorator#fields

    # @!attribute index_fields
    #   @scope class
    #   @param (see Wallaby::ModelDecorator#index_fields)
    #   @return (see Wallaby::ModelDecorator#index_fields)
    #   @see Wallaby::ModelDecorator#index_fields

    # @!attribute show_fields
    #   @scope class
    #   @param (see Wallaby::ModelDecorator#show_fields)
    #   @return (see Wallaby::ModelDecorator#show_fields)
    #   @see Wallaby::ModelDecorator#show_fields

    # @!attribute form_fields
    #   @scope class
    #   @param (see Wallaby::ModelDecorator#form_fields)
    #   @return (see Wallaby::ModelDecorator#form_fields)
    #   @see Wallaby::ModelDecorator#form_fields

    # @!attribute field_names
    #   @scope class
    #   @param (see Wallaby::ModelDecorator#field_names)
    #   @return (see Wallaby::ModelDecorator#field_names)
    #   @see Wallaby::ModelDecorator#field_names

    # @!attribute index_field_names
    #   @scope class
    #   @param (see Wallaby::ModelDecorator#index_field_names)
    #   @return (see Wallaby::ModelDecorator#index_field_names)
    #   @see Wallaby::ModelDecorator#index_field_names

    # @!attribute show_field_names
    #   @scope class
    #   @param (see Wallaby::ModelDecorator#show_field_names)
    #   @return (see Wallaby::ModelDecorator#show_field_names)
    #   @see Wallaby::ModelDecorator#show_field_names

    # @!attribute form_field_names
    #   @scope class
    #   @param (see Wallaby::ModelDecorator#form_field_names)
    #   @return (see Wallaby::ModelDecorator#form_field_names)
    #   @see Wallaby::ModelDecorator#form_field_names

    # @!attribute filters
    #   @scope class
    #   @param (see Wallaby::ModelDecorator#filters)
    #   @return (see Wallaby::ModelDecorator#filters)
    #   @see Wallaby::ModelDecorator#filters

    # @!method type_of
    #   @scope class
    #   @param (see Wallaby::Fieldable#type_of)
    #   @return (see Wallaby::Fieldable#type_of)
    #   @see Wallaby::Fieldable#type_of

    # @!method index_type_of
    #   @scope class
    #   @param (see Wallaby::Fieldable#index_type_of)
    #   @return (see Wallaby::Fieldable#index_type_of)
    #   @see Wallaby::Fieldable#index_type_of

    # @!method show_type_of
    #   @scope class
    #   @param (see Wallaby::Fieldable#show_type_of)
    #   @return (see Wallaby::Fieldable#show_type_of)
    #   @see Wallaby::Fieldable#show_type_of

    # @!method form_type_of
    #   @scope class
    #   @param (see Wallaby::Fieldable#form_type_of)
    #   @return (see Wallaby::Fieldable#form_type_of)
    #   @see Wallaby::Fieldable#form_type_of

    # @!method metadata_of
    #   @scope class
    #   @param (see Wallaby::Fieldable#metadata_of)
    #   @return (see Wallaby::Fieldable#metadata_of)
    #   @see Wallaby::Fieldable#metadata_of

    # @!method index_metadata_of
    #   @scope class
    #   @param (see Wallaby::Fieldable#index_metadata_of)
    #   @return (see Wallaby::Fieldable#index_metadata_of)
    #   @see Wallaby::Fieldable#index_metadata_of

    # @!method show_metadata_of
    #   @scope class
    #   @param (see Wallaby::Fieldable#show_metadata_of)
    #   @return (see Wallaby::Fieldable#show_metadata_of)
    #   @see Wallaby::Fieldable#show_metadata_of

    # @!method form_metadata_of
    #   @scope class
    #   @param (see Wallaby::Fieldable#form_metadata_of)
    #   @return (see Wallaby::Fieldable#form_metadata_of)
    #   @see Wallaby::Fieldable#form_metadata_of

    # @!method label_of
    #   @scope class
    #   @param (see Wallaby::Fieldable#label_of)
    #   @return (see Wallaby::Fieldable#label_of)
    #   @see Wallaby::Fieldable#label_of

    # @!method index_label_of
    #   @scope class
    #   @param (see Wallaby::Fieldable#index_label_of)
    #   @return (see Wallaby::Fieldable#index_label_of)
    #   @see Wallaby::Fieldable#index_label_of

    # @!method show_label_of
    #   @scope class
    #   @param (see Wallaby::Fieldable#show_label_of)
    #   @return (see Wallaby::Fieldable#show_label_of)
    #   @see Wallaby::Fieldable#show_label_of

    # @!method form_label_of
    #   @scope class
    #   @param (see Wallaby::Fieldable#form_label_of)
    #   @return (see Wallaby::Fieldable#form_label_of)
    #   @see Wallaby::Fieldable#form_label_of

    # @!attribute fields
    #   @param (see Wallaby::ModelDecorator#fields)
    #   @return (see Wallaby::ModelDecorator#fields)
    #   @see Wallaby::ModelDecorator#fields

    # @!attribute index_fields
    #   @param (see Wallaby::ModelDecorator#index_fields)
    #   @return (see Wallaby::ModelDecorator#index_fields)
    #   @see Wallaby::ModelDecorator#index_fields

    # @!attribute show_fields
    #   @param (see Wallaby::ModelDecorator#show_fields)
    #   @return (see Wallaby::ModelDecorator#show_fields)
    #   @see Wallaby::ModelDecorator#show_fields

    # @!attribute form_fields
    #   @param (see Wallaby::ModelDecorator#form_fields)
    #   @return (see Wallaby::ModelDecorator#form_fields)
    #   @see Wallaby::ModelDecorator#form_fields

    # @!attribute field_names
    #   @param (see Wallaby::ModelDecorator#field_names)
    #   @return (see Wallaby::ModelDecorator#field_names)
    #   @see Wallaby::ModelDecorator#field_names

    # @!attribute index_field_names
    #   @param (see Wallaby::ModelDecorator#index_field_names)
    #   @return (see Wallaby::ModelDecorator#index_field_names)
    #   @see Wallaby::ModelDecorator#index_field_names

    # @!attribute show_field_names
    #   @param (see Wallaby::ModelDecorator#show_field_names)
    #   @return (see Wallaby::ModelDecorator#show_field_names)
    #   @see Wallaby::ModelDecorator#show_field_names

    # @!attribute form_field_names
    #   @param (see Wallaby::ModelDecorator#form_field_names)
    #   @return (see Wallaby::ModelDecorator#form_field_names)
    #   @see Wallaby::ModelDecorator#form_field_names

    # @!attribute filters
    #   @param (see Wallaby::ModelDecorator#filters)
    #   @return (see Wallaby::ModelDecorator#filters)
    #   @see Wallaby::ModelDecorator#filters

    # @!method type_of
    #   @param (see Wallaby::Fieldable#type_of)
    #   @return (see Wallaby::Fieldable#type_of)
    #   @see Wallaby::Fieldable#type_of

    # @!method index_type_of
    #   @param (see Wallaby::Fieldable#index_type_of)
    #   @return (see Wallaby::Fieldable#index_type_of)
    #   @see Wallaby::Fieldable#index_type_of

    # @!method show_type_of
    #   @param (see Wallaby::Fieldable#show_type_of)
    #   @return (see Wallaby::Fieldable#show_type_of)
    #   @see Wallaby::Fieldable#show_type_of

    # @!method form_type_of
    #   @param (see Wallaby::Fieldable#form_type_of)
    #   @return (see Wallaby::Fieldable#form_type_of)
    #   @see Wallaby::Fieldable#form_type_of

    # @!method metadata_of
    #   @param (see Wallaby::Fieldable#metadata_of)
    #   @return (see Wallaby::Fieldable#metadata_of)
    #   @see Wallaby::Fieldable#metadata_of

    # @!method index_metadata_of
    #   @param (see Wallaby::Fieldable#index_metadata_of)
    #   @return (see Wallaby::Fieldable#index_metadata_of)
    #   @see Wallaby::Fieldable#index_metadata_of

    # @!method show_metadata_of
    #   @param (see Wallaby::Fieldable#show_metadata_of)
    #   @return (see Wallaby::Fieldable#show_metadata_of)
    #   @see Wallaby::Fieldable#show_metadata_of

    # @!method form_metadata_of
    #   @param (see Wallaby::Fieldable#form_metadata_of)
    #   @return (see Wallaby::Fieldable#form_metadata_of)
    #   @see Wallaby::Fieldable#form_metadata_of

    # @!method label_of
    #   @param (see Wallaby::Fieldable#label_of)
    #   @return (see Wallaby::Fieldable#label_of)
    #   @see Wallaby::Fieldable#label_of

    # @!method index_label_of
    #   @param (see Wallaby::Fieldable#index_label_of)
    #   @return (see Wallaby::Fieldable#index_label_of)
    #   @see Wallaby::Fieldable#index_label_of

    # @!method show_label_of
    #   @param (see Wallaby::Fieldable#show_label_of)
    #   @return (see Wallaby::Fieldable#show_label_of)
    #   @see Wallaby::Fieldable#show_label_of

    # @!method form_label_of
    #   @param (see Wallaby::Fieldable#form_label_of)
    #   @return (see Wallaby::Fieldable#form_label_of)
    #   @see Wallaby::Fieldable#form_label_of
  end
end
