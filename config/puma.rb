bind 'tcp://0.0.0.0:4567'

workers 2

threads 1, 4

environment ENV.fetch('RACK_ENV', 'production')
