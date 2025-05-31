require 'dotenv/load'
require_relative '../db/setup'
require 'zeitwerk'

loader = Zeitwerk::Loader.new
loader.push_dir("#{__dir__}/../lib", namespace: Object)
loader.push_dir("#{__dir__}/../models", namespace: Object)
loader.push_dir("#{__dir__}/../lib/services", namespace: Object)
loader.setup

loader.eager_load
