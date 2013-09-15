module OdeonUk

  # Public: The object representing a film on the Odeon UK website
  class Film

    # Public: Returns the String name of the film
    attr_reader :name

    # Public: Initialize a screening
    #
    # name - String of the film name
    def initialize(name)
      @name = name
    end

  end

end
