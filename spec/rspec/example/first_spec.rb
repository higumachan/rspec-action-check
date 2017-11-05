RSpec.describe 'First Example' do
  before do
    @some_state1 = nil
    @some_state2 = nil
  end

  actions 'some actions like a scenario test story' do
    action 'set some_state1 = 100' do
      @some_state1 = 100
    end

    check 'some_state1 = 100' do
      expect(@some_state1).to eq 100
    end

    action 'set some_state2 = 200' do
      @some_state2 = 200
    end

    check 'some_state2 = 200' do
      expect(@some_state2).to eq 200
    end
  end
end
