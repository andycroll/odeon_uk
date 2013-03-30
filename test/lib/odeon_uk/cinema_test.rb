require_relative '../../test_helper'
 
describe OdeonUk::Cinema do

  describe 'all' do
    subject { OdeonUk::Cinema.all }
 
    it 'returns a list of symbols' do
      subject.must_be_instance_of(Array)
      subject.each do |value|
        value.must_be_instance_of(String)
      end
    end
  end

end