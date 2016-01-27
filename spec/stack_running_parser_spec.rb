require_relative '../lib/cfn-toolkit/stack_running_parser'

describe 'Parser for stack create or update cli options' do
  let(:json_params) { "[{\"ParameterKey\": \"k\", \"ParameterValue\": \"v\"}]" }
  before do
    expect(File).to receive(:read).with('/my/file').and_return(json_params)
  end

  describe '#opts_parser' do
    let(:options) { opts_parser }
    it 'parses the key value of params and tags' do
      expect(options.parse(%w[--params k=v,a=b --tags c=d --paramsfile /my/file]).to_h).to eq({
        tags: [
          { key: 'c', value: 'd'},
        ],
        params: [
          { key: 'k', value: 'v'},
          { key: 'a', value: 'b'}
        ],
        paramsfile: [
          { key: 'k', value: 'v'}
        ]
      })
    end
  end

  describe '#parse_args' do
    let(:args)  { %w[mystack --tags a=b,c=d --params e=f,h=j --paramsfile /my/file] }
    let(:input) { double('stdin', read: "I am a template")}

    it 'parses flags, positional and stdin' do
      expect(parse_args(args, input)).to eq({
        stack_name: "mystack",
        tags: [
          { key: 'a', value: 'b'},
          { key: 'c', value: 'd'},
        ],
        params: [
          { key: 'e', value: 'f'},
          { key: 'h', value: 'j'},
          { key: 'k', value: 'v'}
        ],
        template: "I am a template"
      })
    end
  end
end
