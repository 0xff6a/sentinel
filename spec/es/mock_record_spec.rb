require 'spec_helper'

describe ES::MockRecord do
  context 'Factories' do
    let(:ip_regex) { /\b(?:\d{1,3}\.){3}\d{1,3}\b/ }

    it '#default - builds a MockRecord instance with all fields' do
      record = ES::MockRecord.default

      expect(record.fields.ip).to match ip_regex
      expect(Time.parse(record.timestamp)).to be_an_instance_of Time
      expect(record.fields.to_h.keys).to eq([
        :method,
        :path,
        :format,
        :controller,
        :action,
        :status,
        :duration,
        :ip,
        :route,
        :request_id
      ])
    end

    it '#with_fields - builds a MockRecord instance with selected fields' do
      record = ES::MockRecord.with_fields([:ip, :duration])

      expect(record.fields.ip).to match ip_regex
      expect(Time.parse(record.timestamp)).to be_an_instance_of Time
      expect(record.fields.to_h.keys).to eq([
        :duration,
        :ip
      ])
    end
  end
end