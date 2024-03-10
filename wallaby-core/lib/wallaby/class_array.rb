# frozen_string_literal: true

module Wallaby
  # This is a constant-safe array that stores Class value as String.
  class ClassArray
    include Classifier

    # @param [Array] array
    def initialize(*array)
      @internal = (array || []).flatten
      return if @internal.blank?

      @internal.map! { |klass| class_name_of(klass) }.compact!
    end

    # @!attribute [r] internal
    # @return [Array] The array to store Class values as String.
    attr_reader :internal

    # @!attribute [r] origin
    # @return [Array] The original array.
    def origin
      # NOTE: DO NOT cache it using instance variable!
      @internal.map { |klass| to_class(klass) }.compact
    end

    # Save the value to the {#internal} array at the given index, and convert the Class value to String
    def []=(index, value)
      @internal[index] = class_name_of value
    end

    # Return the value for the given index
    def [](index)
      to_class @internal[index]
    end

    # @param other [Array]
    # @return [ClassArray] new Class array
    def concat(other)
      self.class.new origin.concat(other.try(:origin) || other)
    end

    # @param item [Class, String]
    # @return [ClassArray] self
    def <<(item)
      @internal << class_name_of(item)
      self
    end

    # @return [ClassArray] self
    def each(&block)
      origin.each(&block)
      self
    end

    # @!method ==(other)
    # Compare #{origin} with other.
    delegate :==, to: :origin

    # @!method to_a
    # Get the array of #{origin}.
    delegate :to_a, to: :origin

    # @!method blank?
    delegate :blank?, to: :internal

    # @!method each_with_object(object)
    delegate :each_with_object, to: :origin

    # @!method to_sentence
    delegate :to_sentence, to: :origin

    # Ensure to freeze the {#internal}
    # @return [ClassArray] self
    def freeze
      @internal.freeze
      super
    end
  end
end
