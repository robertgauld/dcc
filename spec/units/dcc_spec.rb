# frozen_string_literal: true

describe Dcc do
  describe '#long_loco_address' do
    it 'Calulates values' do
      expect(described_class.long_loco_address(196, 210)).to eq 1234
    end

    it 'Fails if CV17 is out of range' do
      expect { described_class.long_loco_address(-1, 128) }.to raise_error ArgumentError, 'cv17 is out of range (0-255)'
      expect { described_class.long_loco_address(256, 128) }.to raise_error ArgumentError, 'cv17 is out of range (0-255)'
    end

    it 'Fails if CV18 is out of range' do
      expect { described_class.long_loco_address(128, -1) }.to raise_error ArgumentError, 'cv18 is out of range (0-255)'
      expect { described_class.long_loco_address(128, 256) }.to raise_error ArgumentError, 'cv18 is out of range (0-255)'
    end
  end

  describe '#long_loco_address_bytes' do
    it 'Calculates address' do
      expect(described_class.long_loco_address_bytes(1234)).to eq [196, 210]
    end

    it 'Fails if address is out of range' do
      expect { described_class.long_loco_address_bytes(0) }
        .to raise_error ArgumentError, 'address is out of range (1-10239)'
      expect { described_class.long_loco_address_bytes(10_240) }
        .to raise_error ArgumentError, 'address is out of range (1-10239)'
    end
  end

  describe '#cv29' do
    describe 'Sets bit for' do
      it 'reverse_direction' do
        expect(described_class.cv29(:reverse_direction)).to eq 1
      end

      it 'speed_steps' do
        expect(described_class.cv29(:speed_steps)).to eq 2
      end

      it 'dc_operation' do
        expect(described_class.cv29(:dc_operation)).to eq 4
      end

      it 'railcom' do
        expect(described_class.cv29(:railcom)).to eq 8
      end

      it 'complex_speed_curve' do
        expect(described_class.cv29(:complex_speed_curve)).to eq 16
      end

      it 'long_address' do
        expect(described_class.cv29(:long_address)).to eq 32
      end
    end

    it 'Sets multiple bits' do
      expect(described_class.cv29(:speed_steps, :railcom, :long_address)).to eq 42
    end
  end

  describe '#cv29?' do
    describe 'Checks bit for' do
      it 'reverse_direction' do
        expect(described_class.cv29?(0b00000001, :reverse_direction)).to be true
        expect(described_class.cv29?(0b11111110, :reverse_direction)).to be false
      end

      it 'speed_steps' do
        expect(described_class.cv29?(0b00000010, :speed_steps)).to be true
        expect(described_class.cv29?(0b11111101, :speed_steps)).to be false
      end

      it 'dc_operation' do
        expect(described_class.cv29?(0b00000100, :dc_operation)).to be true
        expect(described_class.cv29?(0b11111011, :dc_operation)).to be false
      end

      it 'railcom' do
        expect(described_class.cv29?(0b00001000, :railcom)).to be true
        expect(described_class.cv29?(0b11110111, :railcom)).to be false
      end

      it 'complex_speed_curve' do
        expect(described_class.cv29?(0b00010000, :complex_speed_curve)).to be true
        expect(described_class.cv29?(0b11101111, :complex_speed_curve)).to be false
      end

      it 'long_address' do
        expect(described_class.cv29?(0b00100000, :long_address)).to be true
        expect(described_class.cv29?(0b11011111, :long_address)).to be false
      end
    end

    it 'Fails on invalid option' do
      expect { described_class.cv29?(255, :invalid) }.to raise_error ArgumentError, ':invalid is not a valid option'
    end
  end
end
