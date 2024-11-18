require 'spec_helper'
require 'rails_flags/adapters/memory_adapter'

RSpec.describe RailsFlags::Adapters::MemoryAdapter do
  let(:adapter) { described_class.new }
  let(:flag_name) { :test_flag }
  let(:flag_data) { { enabled: true, description: "Test flag" } }

  describe '#initialize' do
    it 'initializes with empty features hash' do
      expect(adapter.all).to eq({})
    end
  end

  describe '#read' do
    context 'when flag exists' do
      before do
        adapter.write(flag_name, flag_data)
      end

      it 'returns the flag data' do
        expect(adapter.read(flag_name)).to eq(flag_data)
      end
    end

    context 'when flag does not exist' do
      it 'returns nil' do
        expect(adapter.read(flag_name)).to be_nil
      end
    end
  end

  describe '#write' do
    it 'writes the flag data' do
      adapter.write(flag_name, flag_data)
      expect(adapter.read(flag_name)).to eq(flag_data)
    end

    it 'overwrites existing flag data' do
      adapter.write(flag_name, enabled: true)
      adapter.write(flag_name, enabled: false)
      expect(adapter.read(flag_name)).to eq(enabled: false)
    end
  end

  describe '#delete' do
    before do
      adapter.write(flag_name, flag_data)
    end

    it 'deletes the flag' do
      adapter.delete(flag_name)
      expect(adapter.read(flag_name)).to be_nil
    end
  end

  describe '#all' do
    let(:flags) do
      {
        flag1: { enabled: true },
        flag2: { enabled: false }
      }
    end

    before do
      flags.each { |flag, data| adapter.write(flag, data) }
    end

    it 'returns all flags' do
      expect(adapter.all).to eq(flags)
    end

    it 'returns a copy of the flags hash' do
      result = adapter.all
      result[:flag1] = { enabled: false }
      expect(adapter.read(:flag1)).to eq(enabled: true)
    end
  end

  describe '#clear' do
    before do
      adapter.write(:flag1, enabled: true)
      adapter.write(:flag2, enabled: false)
    end

    it 'removes all flags' do
      adapter.clear
      expect(adapter.all).to eq({})
    end
  end
end
