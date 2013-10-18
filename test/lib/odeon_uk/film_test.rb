require_relative '../../test_helper'

describe OdeonUk::Film do

  before { WebMock.disable_net_connect! }

  describe '.new(name)' do
    it 'stores name' do
      film = OdeonUk::Film.new 'Iron Man 3'
      film.name.must_equal 'Iron Man 3'
    end
  end

  describe 'Comparable' do
    it 'includes comparable methods' do
      film = OdeonUk::Film.new 'AAAA'
      film.methods.must_include :<
      film.methods.must_include :>
      film.methods.must_include :==
      film.methods.must_include :<=>
      film.methods.must_include :<=
      film.methods.must_include :>=
    end

    describe 'uniqueness' do
      it 'defines #hash' do
        film = OdeonUk::Film.new 'AAAA'
        film.methods.must_include :hash
      end

      describe '#hash' do
        it 'returns a hash of the slug' do
          film = OdeonUk::Film.new 'AAAA'
          film.hash == film.slug.hash
        end
      end

      it 'defines #eql?(other)' do
        film = OdeonUk::Film.new 'AAAA'
        film.methods.must_include :eql?
      end

      describe 'two identically named films' do
        let(:film)      { OdeonUk::Film.new 'AAAA' }
        let(:otherfilm) { OdeonUk::Film.new 'AAAA' }

        it 'retuns only one' do
          result = [film, otherfilm].uniq
          result.count.must_equal 1
          result.must_equal [ OdeonUk::Film.new('AAAA') ]
        end
      end
    end

    describe '<=> (other)' do
      subject { film <=> otherfilm }

      describe 'film less than other' do
        let(:film)      { OdeonUk::Film.new 'AAAA' }
        let(:otherfilm) { OdeonUk::Film.new 'BBBB' }

        it 'retuns -1' do
          subject.must_equal -1
        end
      end

      describe 'film greater than other' do
        let(:film)      { OdeonUk::Film.new 'CCCC' }
        let(:otherfilm) { OdeonUk::Film.new 'BBBB' }

        it 'retuns 1' do
          subject.must_equal 1
        end
      end

      describe 'film same as other (exact name)' do
        let(:film)      { OdeonUk::Film.new 'AAAA' }
        let(:otherfilm) { OdeonUk::Film.new 'AAAA' }

        it 'retuns 0' do
          subject.must_equal 0
        end
      end

      describe 'film same as other (inexact name)' do
        let(:film)      { OdeonUk::Film.new 'blue jasmine' }
        let(:otherfilm) { OdeonUk::Film.new 'Blue Jasmine' }

        it 'retuns 0' do
          subject.must_equal 0
        end
      end
    end
  end
end
