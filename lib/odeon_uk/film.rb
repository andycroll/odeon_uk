module OdeonUk

  # Public: The object representing a film on the Odeon UK website
  class Film
    include Comparable

    # Public: Returns the String name of the film
    attr_reader :name
    # Public: Returns the String slug of the film
    attr_reader :slug

    # Public: Initialize a screening
    #
    # name - String of the film name
    def initialize(name)
      @name = name
      @slug = name.downcase.gsub(/[^0-9a-z ]/,'').gsub(/\s+/, '-')
    end

    # Public: Allows sort on objects
    def <=> other
      self.slug <=> other.slug
    end

    # Public: Check an object is the same as another object.
    #
    # True if both objects are the same exact object, or if they are of the same
    # type and share an equal slug
    #
    # Guided by http://woss.name/2011/01/20/equality-comparison-and-ordering-in-ruby/
    #
    # object - object to be compared
    #
    # Returns Boolean
    def eql? other
      self.class == other.class && self == other
    end

    # Public: generates hash of slug in order to allow two records of the same
    # type and id to work with something like:
    #
    #   [ Film.new('ABC'), Film.new('DEF') ] & [ Film.new('DEF'), Film.new('GHI') ]
    #   #=> [ Film.new('DEF') ]
    #
    # Guided by http://woss.name/2011/01/20/equality-comparison-and-ordering-in-ruby/
    #
    # Returns an Integer hash of the slug
    def hash
      self.slug.hash
    end
  end
end
