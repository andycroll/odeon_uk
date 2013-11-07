module OdeonUk

  # The object representing a film on the Odeon UK website
  class Film
    include Comparable

    # @!attribute [r] name
    # @return [String] the name of the film
    attr_reader :name
    # @!attribute [r] slug
    # @return [String] the normalized slug derived from the film name
    attr_reader :slug

    # @param [String] name the film name
    # @return [OdeonUk::Film]
    def initialize(name)
      @name = name
      @slug = name.downcase.gsub(/[^0-9a-z ]/,'').gsub(/\s+/, '-')
    end

    # Allows sort on objects
    # @param [OdeonUk::Film] other another film object
    # @return [Integer] -1, 0 or 1
    def <=> other
      self.slug <=> other.slug
    end

    # Check an object is the same as another object.
    # @param [OdeonUk::Film] other another film
    # @return [Boolean] True if both objects are the same exact object, or if
    #   they are of the same type and share an equal slug
    # @note Guided by http://woss.name/2011/01/20/equality-comparison-and-ordering-in-ruby/
    def eql? other
      self.class == other.class && self == other
    end

    # Generates hash of slug in order to allow two records of the same type and
    # id to work with something like:
    #
    #   [ Film.new('ABC'), Film.new('DEF') ] & [ Film.new('DEF'), Film.new('GHI') ]
    #   #=> [ Film.new('DEF') ]
    #
    # @return [Integer] hash of slug
    # @note Guided by http://woss.name/2011/01/20/equality-comparison-and-ordering-in-ruby/
    def hash
      self.slug.hash
    end
  end
end
