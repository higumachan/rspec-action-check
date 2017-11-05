RSpec.describe 'Branch Example' do
  before do
    @some_state1 = nil
    @some_state2 = nil
    @some_state3 = nil
  end

  actions 'some actions like a scenario test story with branching' do
    action 'set some_state1 = 100' do
      @some_state1 = 100
    end

    branch 'branch1' do
      check 'some_state1 = 100' do
        expect(@some_state1).to eq 100
      end

      action 'set some_state2 = 200' do
        @some_state2 = 200
      end

      check 'some_state1 = 100 and some_state2 == 200' do
        expect(@some_state1).to eq 100
        expect(@some_state2).to eq 200
      end

      branch 'branch in branch1' do
        action 'set some_state3 = 300' do
          @some_state3 = 300
        end

        check 'some_state1 = 100 and some_state2 == 200 and some_state3 == 300' do
          expect(@some_state1).to eq 100
          expect(@some_state2).to eq 200
          expect(@some_state3).to eq 300
        end
      end

      branch 'branch` in branch1' do
        check 'some_state1 = 100 and some_state2 == 200 and some_state3 is nil' do
          expect(@some_state1).to eq 100
          expect(@some_state2).to eq 200
          expect(@some_state3).to be_nil
        end
      end
    end

    branch 'branch2' do
      check 'some_state1 = 100 and some_state2 is nil' do
        expect(@some_state1).to eq 100
        expect(@some_state2).to be_nil
      end
    end
  end
end
