require 'net/http'
require 'uri'

require_relative '../settings'

module ES
  class MockApiServerRunner
    HOST               = Settings.mock_api.host
    PORT               = Settings.mock_api.port 
    PID_FILEPATH       = File.expand_path('../../tmp/mock_api_server.pid', __dir__)
    LOG_FILEPATH       = File.expand_path('../../log/mock-api.log', __dir__)
    RACK_CONFIG_PATH   = File.expand_path('./mock-api-config.ru', __dir__)
    CWD                = File.expand_path('../../', __dir__)
    HEARTBEAT_ENDPOINT = '/'

    def start
      cmd = "bundle exec rackup -p #{PORT} -P #{PID_FILEPATH} #{RACK_CONFIG_PATH} &> #{LOG_FILEPATH}"

      if File.exists?(PID_FILEPATH)
        pid   = File.read(PID_FILEPATH)
        error = "Found pid file #{PID_FILEPATH}. " +
                "Please kill process #{pid} and make sure the pid file is deleted"
                
        raise ServerAlreadyRunning, error
      else
        puts '[+] Starting Mock ES API'
        Process.spawn(cmd, :chdir => CWD)
        wait_for_app
      end
    end

    def stop
      if File.exists?(PID_FILEPATH)
        Process.kill(:SIGINT, File.read(PID_FILEPATH).to_i)
      else
        warn "#{self.class}#stop: No process running"
      end
    end

    private

    def wait_for_app(attempts_left = 100)
      raise "Mock ES API timed out! Please try starting it manually" if attempts_left < 1
      resp_code =
        begin
          sleep 0.1
          Net::HTTP.get_response(app_uri).code
        rescue Errno::ECONNREFUSED
        end

      wait_for_app(attempts_left - 1) unless resp_code == '200'
    end

    def app_uri
      URI.parse("#{HOST}:#{PORT}/#{HEARTBEAT_ENDPOINT}")
    end

    class ServerAlreadyRunning < StandardError
    end
  end
end