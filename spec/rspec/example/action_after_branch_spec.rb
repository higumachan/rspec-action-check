RSpec.describe 'Action after branch' do
  before do
    @some_state1 = nil
    @some_state2 = nil
    @some_state3 = nil
  end

  actions 'some actions like a scenario test story' do
    action 'start' do
    end

    branch 'branch1' do
      action 'set some_state1 = 100' do
        @some_state1 = 100
      end

      action 'set some_state2 = 200' do
        @some_state2 = 200
      end
    end

    branch 'branch2' do
      action 'set some_state1 = 200' do
        @some_state1 = 200
      end

      action 'set some_state2 = 100' do
        @some_state2 = 100
      end
    end

    check 'both state is not nil' do
      expect(@some_state1).not_to be_nil
      expect(@some_state2).not_to be_nil
    end

    action 'set some_state3 = 300' do
      @some_state3 = 300
    end

    check 'some_state3 = 300' do
      expect(@some_state3).to eq 300
    end
  end
end
