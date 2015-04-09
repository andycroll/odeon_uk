require_relative '../../../test_helper'

describe OdeonUk::Internal::TitleSanitizer do
  let(:described_class) { OdeonUk::Internal::TitleSanitizer }

  describe '#sanitized' do
    subject { described_class.new(title).sanitized }

    describe 'with 2d in title' do
      let(:title) { 'Iron Man 3 2D' }

      it 'removes dimension' do
        subject.must_equal('Iron Man 3')
      end
    end

    describe 'with 3d in title' do
      let(:title) { 'Iron Man 3 3D' }

      it 'removes dimension' do
        subject.must_equal('Iron Man 3')
      end
    end

    describe 'Austism screening' do
      let(:title) { 'Autism Friendly Screening - Planes' }

      it 'removes prefix' do
        subject.must_equal('Planes')
      end
    end

    describe 'Bolshoi screeening' do
      let(:title) { 'Bolshoi - Spartacus (Live)' }

      it 'removes prefix' do
        subject.must_equal('Bolshoi: Spartacus')
      end
    end

    describe 'Cinemagic screeening' do
      let(:title) { 'Cinemagic 2013 - Echo Planet' }

      it 'removes prefix' do
        subject.must_equal('Echo Planet')
      end
    end

    describe 'Globe on Screen screeening' do
      let(:title) { 'Globe On Screen: Twelfth Night' }

      it 'removes prefix' do
        subject.must_equal('Globe: Twelfth Night')
      end
    end

    describe 'Met Opera screeening' do
      let(:title) { 'Met Opera - Eugene Onegin 2013' }

      it 'removes prefix' do
        subject.must_equal('Met Opera: Eugene Onegin 2013')
      end
    end

    describe 'NT Live screeening' do
      let(:title) { 'NT Live - War Horse' }

      it 'removes prefix' do
        subject.must_equal('National Theatre: War Horse')
      end
    end

    describe 'National Theatre screeening' do
      let(:title) { 'National Theatre Live - Frankenstein (Encore Screening)' }

      it 'removes prefix' do
        subject.must_equal('National Theatre: Frankenstein')
      end
    end

    describe 'ROH screeening' do
      let(:title) { 'Autism Friendly Screening - Planes' }

      it 'removes prefix' do
        subject.must_equal('Planes')
      end
    end

    describe 'RSC screeening' do
      let(:title) { 'Richard II - RSC Live 2013' }

      it 'removes prefix' do
        subject.must_equal('Royal Shakespeare Company: Richard II')
      end
    end

    describe 'UK Jewish FF screeening' do
      let(:title) { 'UKJFF - From Cable Street To Brick Lane' }

      it 'removes prefix' do
        subject.must_equal('From Cable Street To Brick Lane')
      end
    end

    describe 'singalong screeening' do
      let(:title) { 'Frozen Sing-a-long' }

      it 'removes prefix' do
        subject.must_equal('Frozen')
      end
    end

    describe 'HTML ampersands' do
      let(:title) { 'Fast &amp; Furious 7' }

      it 'removes prefix' do
        subject.must_equal('Fast & Furious 7')
      end
    end
  end
end
