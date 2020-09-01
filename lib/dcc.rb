# frozen_string_literal: true

require 'zeitwerk'

# Custom inflector for Zeitwerk.
# @api private
class MyInflector < Zeitwerk::Inflector
  # Convert file's base name to class name when
  # Zeitwerk's included inflector gets it wrong.
  # @param basename [String] the file's base name (no path or extension)
  # @param _abspath [String] the file's absolute path
  # @return [String] the class name
  def camelize(basename, _abspath)
    case basename
    when 'version' then 'VERSION'
    else
      super
    end
  end
end

loader = Zeitwerk::Loader.for_gem
loader.inflector = MyInflector.new
loader.setup

# DCC calculators (and namespeace for the gem).
module Dcc
  # Get a long loco address from the values of CVs 17 and 18.
  # @param cv17 [Integer] the value read from CV17 (0-255)
  # @param cv18 [Integer] the value read from CV18 (0-255)
  # @return [Integer] the long loco address resulting from the passed values
  def self.long_loco_address(cv17, cv18)
    fail ArgumentError, 'cv17 is out of range (0-255)' unless cv17.between? 0, 255
    fail ArgumentError, 'cv18 is out of range (0-255)' unless cv18.between? 0, 255

    ((cv17 - 192) * 256) + cv18
  end

  # Calculate the bytes to store in CVs 17 and 18 for a long loco address.
  # @param address [Integer] the long loco address (1-102390)
  # @return [Array<Integer, Integer>] the bytes for CVs 17 and 18 (in that order)
  def self.long_loco_address_bytes(address)
    fail ArgumentError, 'address is out of range (1-10239)' unless address.between? 1, 10_239

    [
      (address / 256).floor + 192,
      address % 256
    ]
  end

  # Calculate the value of CV 29 for the passed options.
  # @param options [Array<Symbol>] any combination of:
  #   :reverse_direction, :speed_steps, :dc_operation, :railcom,
  #   :complex_speed_curve or :long_address
  # @return [Integer] the byte for CV 29
  def self.cv29(*options)
    value = 0
    value += 1 if options.include? :reverse_direction
    value += 2 if options.include? :speed_steps
    value += 4 if options.include? :dc_operation
    value += 8 if options.include? :railcom
    value += 16 if options.include? :complex_speed_curve
    value += 32 if options.include? :long_address
    value
  end

  # Check if an option is set in a given value of CV 29.
  # @param value [Integer] the value read from CV 29
  # @param option [Symbol] either:
  #   :reverse_direction, :speed_steps, :dc_operation, :railcom,
  #   :complex_speed_curve or :long_address
  # @return [Boolean]
  def self.cv29?(value, option)
    case option
    when :reverse_direction   then (value & 1).positive?
    when :speed_steps         then (value & 2).positive?
    when :dc_operation        then (value & 4).positive?
    when :railcom             then (value & 8).positive?
    when :complex_speed_curve then (value & 16).positive?
    when :long_address        then (value & 32).positive?
    else
      fail ArgumentError, "#{option.inspect} is not a valid option"
    end
  end
end
